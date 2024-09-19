module ULA(
    input reset,
    input clk,
    input[28:0] a,
    input[28:0] b,
    input [22:0] fractA, fractB,
    input sign_a, sign_b,
    input start,
    input op,
    output  [28:0] c,
    output reg done,
    output  reg sign_c 
);

parameter IDLE = 0, START = 1, SOMA = 2, MULT = 3, DONE = 4, TRATAR_MULT = 6;
wire [23:0]  multiplicador;
reg[23:0] multiplicador_efetivo;
wire [47:0] multiplicando; 
reg [4:0] counter;
reg [47:0] mult_result;
reg [28:0] soma_result;
reg [2:0] states;

assign multiplicando = (a > b) ? {24'b0, a[26:3]} : {24'b0, b[26:3]};
assign multiplicador = (a < b) ? {a[26:3]} : {b[26:3]};
assign c = !op ? soma_result : {1'b0,mult_result[47:21],1'b0};

always @* begin
    if(reset)
        states <= IDLE;
end

always @(posedge clk ) begin
    case (states)
        IDLE: begin
            if(start == 1)
                states <= START;
            else
                states <= IDLE;
        end

        START: begin
            if(op == 0)
                states <= SOMA;
            else
                states <= MULT;
        end

        SOMA: 
            states <= DONE;
        

        MULT: begin
            if(counter == 24)
                states <= DONE;
            else
                states <= MULT;
        end

        DONE:
            states <= DONE;

    endcase
end


always @(posedge clk) begin
    if(reset)
        states <= IDLE;

    case(states)
        IDLE:
            done <= 0;

        START: begin
            counter <= 0;
            mult_result <= 0;
        end

        SOMA: begin
            if(sign_a == sign_b) begin //sign_a and sign_b == 1 ou sign_a and sign_b == 0 
                soma_result <= a + b;
                sign_c <= sign_a;
            end
            

            
            else begin
                if (sign_a == 1) begin //sign_a == 1 e sign_b == 0
                    if(fractA > fractB) begin  //fractA > fractB -> resultado negativo
                        soma_result <= b - a;
                        sign_c <= sign_a;
                    end
                    else begin                 //fractA < fractB -> resultado positivo
                        soma_result <= b - a;
                        sign_c <= sign_b;    
                    end
                end
                else begin      //sign_a == 0 e sign_b == 1,
                    if(fractA > fractB) begin  //fractA > fractB -> resultado positivo
                        soma_result <= b - a;
                        sign_c <= sign_a;
                    end
                    else begin                 //fractA < fractB -> resultado negativo
                        soma_result <= b - a;
                        sign_c <= sign_b;    
                    end
                end
            end
        end

        MULT: begin
            sign_c <= sign_a ^ sign_b;
            if (multiplicador[counter] == 1) begin
                mult_result <= mult_result + (multiplicando << counter);
            end
            counter <= counter + 1;
        end

        DONE:
            done <= 1;

    endcase
    
end


endmodule








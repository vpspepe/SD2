

// Grupo 06
// Integrantes
// Marcelo Takayama Russo - 13680164
// Victor Pedreira Santos de Pepe - 
// Thainara de Assis Goulart - 13874413


module multiplier8bits_ROM (
    input [7:0] w,
    input [7:0] y,
    input wire S, //start
    input wire RESET,
    input wire CLK,
    output [15:0] result,
    output reg PRONTO //done
);

reg [4:0] D,E;

reg [9:0] rom1; //rom2; //fios que entram na rom (multiplicando e multiplicador)
wire [9:0] rom_result; //fio que sai da ROM com o resultado da multiplicação
reg [15:0] ABshiftsum, DE_AB; //fios que recebem soma do A+Bshiftado e subtração de DE-AB
reg [8:0] ABsum; //Fio recebe soma de A+B
reg [3:0] states;

reg [7:0] W, Y;
reg [9:0] A, B, DE;
reg [15:0] result_reg;

assign result = result_reg;

multiplier_ROM ROM(.a(rom1), .z(rom_result));

parameter IDLE = 4'b0000, START = 4'b0001, SOMA_WY = 4'b0010, MULT_A = 4'b0011, MULT_B = 4'b0100, MULT_DE = 4'b0101, 
          SOMA_AB = 4'b0110, SOMA_DE_ABshift = 4'b0111, SOMA_FINAL = 4'b1000, DONE = 4'b1001;

always @(posedge CLK or posedge S or posedge RESET) begin
    if (RESET == 1)
        states <= IDLE;
    else begin
        case (states)
            IDLE: begin
                if (S == 1)
                    states <= START;
            end

            START: begin
                states <= SOMA_WY;
            end

            SOMA_WY: begin
                states <= MULT_A;
            end

            MULT_A: begin
                states <= MULT_B;
            end

            MULT_B: begin
                states <= MULT_DE;
            end

            MULT_DE: begin
                states <= SOMA_AB;
            end

            SOMA_AB: begin
                states <= SOMA_DE_ABshift;
            end

            SOMA_DE_ABshift: begin
                states <= SOMA_FINAL;
            end

            SOMA_FINAL: begin
                states <= DONE;
            end    

            DONE: begin
                states <= IDLE;
            end
            
        endcase
    end
end

always @(posedge CLK) begin
    case (states)
        
        IDLE: begin
            PRONTO <= 0;
        end

        START: begin
            result_reg <= 0;
            W <= w;
            Y <= y;
        end 

        SOMA_WY: begin
            //result_reg <= 1;
            D <= w[7:4] + w[3:0];
            E <= y[7:4] + y[3:0];
        end
    
        MULT_A: begin

            rom1 <= {w[3:0], y[3:0]};
            //rom2 <= y[3:0];
            A <= rom_result;
            //result_reg <= rom_result;
        end

        MULT_B: begin
            
            rom1 <= {w[7:4], y[7:4]};
            //rom2 <= y[7:4];
            //B <= rom_result;
            result_reg <= rom_result;
        end
        
        MULT_DE: begin 
            //result_reg <= 2;
            rom1 <= {D, E};
            //rom2 <= E;
            DE <= rom_result;
            //result_reg <= rom_result;
        end
        
        SOMA_AB: begin
            //result_reg <= 3;
            ABsum <= A + B;
            ABshiftsum <= A + (B<<8);
        end

        SOMA_DE_ABshift: begin
            //result_reg <= 4;
            DE_AB <= (DE - ABsum)<<4;
        end

        SOMA_FINAL: begin
            //result_reg <= A + B;
            result_reg <= ABshiftsum + DE_AB;
        end 

        DONE: begin
            PRONTO <= 1;
        end  
        
    endcase
end

endmodule
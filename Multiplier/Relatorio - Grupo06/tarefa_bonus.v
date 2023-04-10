module tarefa_bonus(M1,M2,CLK,RESET,RESULT,ready);

    input wire [7:0] M1;//multiplicando
    input wire [7:0] M2; //multiplicador
    input CLK;
    input RESET;
    output wire [15:0] RESULT;
    output reg ready;



reg [2:0] states;
reg [7:0] A, B, Q;
reg [2:0] COUNTER;
reg C;

parameter IDLE = 3'b000, START = 3'b001, SUM = 3'b010, SHIFT1 = 3'b100,  SHIFT2 = 3'b101, STOP = 3'b110;

assign RESULT = {Q,A};

always @(posedge CLK or posedge RESET) begin
   if (RESET == 1)
      states <= IDLE;
    else begin
        case (states)
            IDLE: begin
                    states <= START;
                end
            

            START: begin
                    states <= SUM;
            end

            SUM: begin
                states <= SHIFT1;
            end

            SHIFT1: begin
                states <= SHIFT2;
            end

            SHIFT2: begin
                if (COUNTER != 0) begin
                        states <= SUM;
                end
                else begin
                    states <= STOP;
                end
            end

            STOP: begin
                if (RESET == 1) begin
                    states <= IDLE;
                end
                else begin
                states <= STOP;
                end
            end

        endcase 
    end
end

always @(posedge CLK) begin
    case (states)
        IDLE: begin
            A <= 0;
            Q <= 0;
            C <= 0;
            B <= 0;
        end
        START: begin 
            B <= M1;
            A <= M2;
            Q <= 0;
            COUNTER <= 8;
        end
        SUM: begin
            if(A[0] == 1) begin
                Q <= Q + B;
                if (Q + B > 255) begin
                    C <= 1;
                end
            end
            else
            C <= 0;
        end
        SHIFT1: begin
            A <= A>>1;
            A[7] <= Q[0];
            COUNTER <= COUNTER - 8'b1;
        end
        SHIFT2: begin
            Q = Q>>1;
            Q[7] <= C;
        end
        STOP: begin
            ready <= 1;
        end

    endcase
    
end
endmodule
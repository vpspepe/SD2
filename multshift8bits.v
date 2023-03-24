module multshift8bits(
    input wire [7:0] M1,//multiplicando
    input wire [7:0] M2, //multiplicador
    input wire CLK,
    input wire RESET,
    output wire [15:0] RESULT,
    output reg ready
);

reg [2:0] states;
reg [7:0] A, B, Q;
reg [3:0] COUNTER;
reg C;

parameter IDLE = 0, START = 1, SUM = 2, SHIFT1 = 3,  SHIFT2 = 4, STOP = 5;

assign RESULT = {Q,A};

always @(posedge CLK or posedge RESET) begin
   if (RESET == 1)
      states <= IDLE;
    else begin
        case (states)
            IDLE: begin
                if (RESET==1) begin
                    states <= START;
                end
            end
            START: begin
                if(A[0]==1) begin
                    states <= SUM;
                end
                else begin
                    states <= SHIFT1;
                end
            end
            SUM: begin
                states <= SHIFT1;
            end
            SHIFT1: begin
                states <= SHIFT2;
            end
            SHIFT2: begin
                if (COUNTER != 0) begin
                    if (A[0]==0) begin
                        states <= SHIFT1;  
                    end
                    else begin
                        states <= SUM;
                    end
                end
                else begin
                    states <= STOP;
                end
            end
            STOP: begin
                states <= IDLE;
            end
        endcase 
    end
end

always @(posedge CLK) begin
    case (states)
        IDLE: begin
            C <= 0;
        end
        START: begin
            B <= M1;
            A <= M2;
            Q <= 0;
            COUNTER <= 7;
        end
        SUM: begin
            Q <= Q + B;
            if (Q + B > 255) begin
                C <= 1;
            end
        end
        SHIFT1: begin
            A <= A>>1;
            A[7] <= Q[0];
            COUNTER <= COUNTER - 8'b1;
        end
        SHIFT2: begin
            Q = Q>>1;
        end
        STOP: begin
            ready <= 1;
        end

    endcase
    
end


endmodule
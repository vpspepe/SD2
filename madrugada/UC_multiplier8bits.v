module UC_multiplier8bits(
    input clk, start, RESET,
    output reg LD_XY, LD_DE0,LD_A,LD_B,LD_DE1, LD_AB, LD_DE_ABshift, LD_RES,
    output reg[1:0] SELROM, SELSOMA,
    output reg DONE
);
reg[3:0] states;
parameter IDLE = 0, START = 1, LD1=2, MULT1=3, LDA=4, MULT2=5, LDB=6, MULT3=7, LDDE=8, SOMA_AB=9,LDAB = 10, SUB_DE_AB=11, LDDEABshift = 12, SOMA_FINAL=13, FIM=14;

always @(posedge clk or posedge start or posedge RESET) begin
    if (RESET == 1)
        states <= IDLE;
    else begin
        case (states)
            IDLE: begin
                if (start == 1)
                    states <= START;
            end

            START: begin
                states <= LD1;
            end

            LD1: begin
                states <= MULT1;
            end

            MULT1: begin
                states <= LDA;
            end

            LDA: begin
                states <= MULT2;
            end

            MULT2: begin
                states <= LDB;
            end

            LDB: begin
                states <= MULT3;
            end

            MULT3: begin
                states <= LDDE;
            end

            LDDE: begin
                states <= SOMA_AB;
            end

            SOMA_AB: begin
                states <= LDAB;
            end

            LDAB: begin
                states <= SUB_DE_AB;
            end

            SUB_DE_AB: begin
                states <= LDDEABshift;
            end

            LDDEABshift: begin
                states <= SOMA_FINAL;
            end

            SOMA_FINAL: begin
                states <= FIM;
            end    

        endcase
    end
end

always @(posedge clk) begin
    case (states) 

            IDLE: begin

                LD_XY <=0;
                LD_DE0 <=0;
                LD_A<=0;
                LD_B<=0;
                LD_DE1<=0;
                LD_AB<=0;
                LD_DE_ABshift <=0;
                LD_RES<=0;
                SELROM<=0;
                SELSOMA<=0;
                DONE <=0;
            end

            START: begin
                LD_XY<= 1;
            end

            LD1: begin
                LD_XY<= 0;
                LD_DE0<=1;
            end

            MULT1: begin
                LD_DE0<=0;
                SELROM<= 1;
            end

            LDA: begin
                SELROM<= 0;
                LD_A<= 1;
            end

            MULT2: begin
                LD_A<= 0;
                SELROM<= 2;
            end

            LDB: begin
                SELROM<= 0;
                LD_B<= 1;
            end

            MULT3: begin
                LD_B<= 0;
                SELROM <= 3; 
            end

            LDDE: begin
                SELROM<= 0;
                LD_DE1 <= 1;
            end

            SOMA_AB: begin
                SELROM <= 0; 
                LD_DE1 <= 0;
                SELSOMA <= 1;

            end

            LDAB: begin
                LD_AB <= 1;
                SELSOMA <= 0;
            end

            SUB_DE_AB: begin
                LD_AB <=0;
                SELSOMA <= 2;
            end

            LDDEABshift: begin
                LD_DE_ABshift<= 1;
                SELSOMA <= 0;
            end

            SOMA_FINAL: begin
                LD_DE_ABshift <= 0;
                SELSOMA <= 3;
            end    

            FIM: begin
                LD_RES <= 1;
                DONE <= 1;
                SELSOMA <= 0;
            end
    endcase
end

endmodule
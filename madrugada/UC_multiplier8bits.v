module UC_multiplier8bits(
    input clk, start, RESET,
    output reg LD_XY, LD_D, LD_E,LD_A,LD_B,LD_DE, LD_RES,
    output reg[1:0] SELROM, SELSOMA,
    output reg DONE
);
reg[3:0] states;
parameter IDLE = 0, START = 1, LD1=2, MULT1=3, LDA=4, MULT2=5, LDB=6, MULT3=7, LDDE=8, SOMA_AB=9, SOMA_ABSHIFT = 10, SUB_DE_AB=11, SOMA_FINAL=12, FIM=13;

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
                states <= SOMA_ABSHIFT;
            end

            SOMA_ABSHIFT: begin
                states <= SUB_DE_AB;
            end

            SUB_DE_AB: begin
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
                LD_D <=0;
                LD_E<=0;
                LD_A<=0;
                LD_B<=0;
                LD_DE<=0;
                LD_RES<=0;
                SELROM<=0;
                SELSOMA<=0;
                DONE <=0;
            end

            START: begin
                LD_XY<= 1;
            end

            LD1: begin
                LD_D<=1;
                LD_E<=1;
            end

            MULT1: begin
                SELROM<= 0;
            end

            LDA: begin
                LD_A<= 1;
            end

            MULT2: begin
                SELROM<= 1;
            end

            LDB: begin
                LD_B<= 1;
            end

            MULT3: begin
                SELROM <= 2; 
            end

            LDDE: begin
                LD_DE <= 1;
            end

            SOMA_AB: begin
                SELSOMA <= 0;
            end

            SOMA_ABSHIFT: begin
                SELSOMA <= 1;
            end

            SUB_DE_AB: begin
                SELSOMA <= 2;
            end

            SOMA_FINAL: begin
                SELSOMA <= 3;
            end    

            FIM: begin
                LD_RES <= 1;
                DONE <= 1;
            end
    endcase
end



endmodule
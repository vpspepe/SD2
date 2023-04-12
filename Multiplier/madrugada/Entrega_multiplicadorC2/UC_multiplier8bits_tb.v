`timescale 10ns/100ps

module UC_multiplier8bits_tb;
reg clk_tb, start_tb, RESET_tb;
wire LD_XY_tb, LD_DE0_tb, LD_A_tb,LD_B_tb,LD_DE1_tb, LD_AB_tb, LD_DE_ABshift_tb, LD_RES_tb;
wire[1:0] SELROM_tb,SELSOMA_tb; 
wire DONE_tb;

UC_multiplier8bits uut(
    .clk(clk_tb), .start(start_tb), .RESET(RESET_tb),
    .LD_XY(LD_XY_tb), .LD_DE0(LD_DE0_tb), .LD_A(LD_A_tb), .LD_B(LD_B_tb),.LD_DE1(LD_DE1_tb), .LD_AB(LD_AB_tb), .LD_DE_ABshift(LD_DE_ABshift_tb), .LD_RES(LD_RES_tb),
    .SELROM(SELROM_tb), .SELSOMA(SELSOMA_tb),
    .DONE(DONE_tb)
);

initial begin

        $monitor("LD_XY = %d || LD_DE0 = %d || LD_A = %d || LD_B = %d LD_DE1 = %d || LD_AB = %d || LD_DE_ABshift = %d || LD_RES = %d || SELROM = %d || SELSOMA = %d || DONE = %d || RESET = %d || start = %d", LD_XY_tb, LD_DE0_tb, LD_A_tb,LD_B_tb,LD_DE1_tb, LD_AB_tb, LD_DE_ABshift_tb, LD_RES_tb,SELROM_tb, SELSOMA_tb,DONE_tb, RESET_tb,start_tb);
        clk_tb = 0;
        RESET_tb = 0;
        start_tb = 1;
        #10
        RESET_tb = 1;
        #100 
        RESET_tb = 0;
        #20000
        RESET_tb = 1;
    end

always begin
    #10 clk_tb = ~clk_tb;
end

endmodule
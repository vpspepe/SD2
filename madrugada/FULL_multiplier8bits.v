`timescale 100ns/10ps

module FULL_multiplier8bits;
reg clk_tb, start_tb, RESET_tb;
wire LD_XY_tb, LD_DE0_tb, LD_A_tb,LD_B_tb,LD_DE1_tb, LD_AB_tb, LD_DE_ABshift_tb, LD_RES_tb;
wire[1:0] SELROM_tb,SELSOMA_tb; 
wire DONE_tb;

reg [7:0] x_tb, y_tb;
wire [15:0] result_tb;

UC_multiplier8bits UC(
    
)
endmodule
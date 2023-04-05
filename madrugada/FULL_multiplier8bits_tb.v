`timescale 100ns/10ps

module FULL_multiplier8bits_tb;
reg CLK_tb, start_tb, RESET_tb;
wire LD_XY_tb, LD_DE0_tb, LD_A_tb,LD_B_tb,LD_DE1_tb, LD_AB_tb, LD_DE_ABshift_tb, LD_RES_tb;
wire[1:0] SELROM_tb,SELSOMA_tb; 
wire DONE_tb;

reg [7:0] x_tb, y_tb;
wire [15:0] result_tb;

UC_multiplier8bits UC(
    .clk(CLK_tb), .start(start_tb), .RESET(RESET_tb),
    .LD_XY(LD_XY_tb), .LD_DE0(LD_DE0_tb),.LD_A(LD_A_tb),.LD_B(LD_B_tb),.LD_DE1(LD_DE1_tb), .LD_AB(LD_AB_tb), .LD_DE_ABshift(LD_DE_ABshift_tb), .LD_RES(LD_RES_tb),
    .SELROM(SELROM_tb), .SELSOMA(SELSOMA_tb),
    .DONE(DONE_tb)
);

FD_multiplier8bits FD(
    .x(x_tb), .y(y_tb),
    .LD_XY(LD_XY_tb), .LD_DE0(LD_DE0_tb), .LD_A(LD_A_tb), .LD_B(LD_B_tb), 
    .LD_DE1(LD_DE1_tb),.LD_AB(LD_AB_tb), .LD_DE_ABshift(LD_DE_ABshift_tb), .LD_RES(LD_RES_tb),   
    .SELROM(SELROM_tb), .SELSOMA(SELSOMA_tb),
    .CLK(CLK_tb), .RESET(RESET_tb), 
    .result(result_tb)
);

initial begin

$monitor("X = %d || Y = %d || resultado = %d || PRONTO = %d || start = %d",x_tb,y_tb,result_tb,DONE_tb,start_tb);
        CLK_tb = 1;
        RESET_tb = 1;
        start_tb = 1;
        #10
        RESET_tb = 0;

        #10
        x_tb = 8'd17; 
        y_tb = 8'd23; 
end 

always #10 CLK_tb = ~CLK_tb;







endmodule
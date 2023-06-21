`timescale  10ns/100ps

module float_addition_tb();

reg op_tb;
reg [31:0] A_tb, B_tb;
reg clk_tb;
reg reset_tb;


float_addition float_addition_tb(
     .op(op_tb), 
     .A(A_tb),
     .B(B_tb),
     .clk(clk_tb),
     .reset(reset_tb)
);

initial begin
$dumpfile("_testbenches/vvp/float_addition.vcd");
$dumpvars(0, float_addition_tb);

A_tb = {1'b0,8'b10000000,23'b00000000000000000000001};
B_tb = {1'b0,8'b10000000,23'b00000000000000000000001};
op_tb = 0;
reset_tb = 0;
clk_tb = 0;
#10 
reset_tb = 1;

#10 
reset_tb = 0;

#3000
$finish;

end

always #10 
    clk_tb = ~clk_tb;

endmodule
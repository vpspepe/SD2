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
// iverilog .\float_addition_tb.v .\float_addition.v .\FD.v .\incremento_decremento.v .\left_right.v .\shift_right.v .\small_ULA.v .\ULA.v .\UC.v .\MUX2_23bits.v .\MUX2_29bits.v .\MUX2_8bits.v .\arredonda.v
A_tb = {32'b01000000000000000000000000001111};
B_tb = {32'b11000000000000000000000000000111};
op_tb = 0;
reset_tb = 0;
clk_tb = 0;
#10 
reset_tb = 1;

#10 
reset_tb = 0;

#5000
$finish;

end

always #10 
    clk_tb = ~clk_tb;

endmodule
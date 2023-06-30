`timescale  10ns/100ps

module floating_point_tb();

reg start_tb;
reg [1:0] op_tb;
reg [31:0] A_tb, B_tb;
reg clk_tb;
reg reset_tb;
wire [31:0] result_tb;
wire done_tb;

fpu floating_point_tb(
     .clk(clk_tb),
     .reset(reset_tb),
     .start(start_tb),
     .op(op_tb),
     .A(A_tb), 
     .B(B_tb),
     .R(result_tb),
     .done(done_tb)
);

initial begin
$dumpfile("_testbenches/vvp/floating_point.vcd");
$dumpvars(0, floating_point_tb);
// iverilog .\floating_point_tb.v .\floating_point.v .\FD.v .\incremento_decremento.v .\left_right.v .\shift_right.v .\small_ULA.v .\ULA.v .\UC.v .\MUX2_23bits.v .\MUX2_29bits.v .\MUX2_8bits.v .\arredonda.v
//1 CONTA
A_tb = {1'b0, 8'b10000000, 23'b00000000000000000001111};
B_tb = {1'b1, 8'b10000000, 23'b00000000000000000000111};
op_tb = 2'b00;
reset_tb = 0;
clk_tb = 0;

#10 
reset_tb = 1;
start_tb = 1;

#10 
reset_tb = 0;

// #1600
// start_tb = 0;
// // 2 CONTA
// #10
// A_tb = {1'b0, 8'b10000000, 23'b00000000000000000001111};
// B_tb = {1'b1, 8'b10000000, 23'b00000000000000000000111};
// op_tb = 2'b00;


// #10
// start_tb = 1;

#1500
start_tb = 0;
//3 CONTA
#10
A_tb = {1'b1, 8'b10000000, 23'b00000000000000000001111};
B_tb = {1'b1, 8'b10000000, 23'b00000000000000000000111};
op_tb = 2'b00;

#10 
start_tb = 1;

#2000
start_tb = 0;
//4 CONTA
#10
A_tb = {1'b1, 8'b10000000, 23'b00000000000000000001111};
B_tb = {1'b1, 8'b10000011, 23'b00000000000000000000111};
op_tb = 2'b10;

#10 
start_tb = 1;

#2000
$finish;

end

always #10 
    clk_tb = ~clk_tb;

endmodule
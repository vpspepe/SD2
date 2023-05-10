module MUX2_64(
             a, b,       //0 1
             select,
             result);   // output 
parameter N = 64;
input select;
input [N-1:0] a, b;
output [N-1:0] result;
assign result = select == 1'b1 ? b[N-1:0]: a[N-1:0];

endmodule
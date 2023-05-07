module MUX(
            input a, b,       //0 1
            input select,
            output result);   // output 
parameter N = 64;
input [N-1:0] a, b;
output [N-1:0] result;
assign result = select == 1'b1 ? b: a;

endmodule
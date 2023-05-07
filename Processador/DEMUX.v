module DEMUX(
    input[63:0] a,
    input select,
    output[63:0] result0, result1
);

assign result0 = select == 1'b1 ? a: 64'b0 ;
assign result1 = select == 1'b1 ? 64'b0: a;

endmodule
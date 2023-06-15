module MUX_64(
            input[63:0] a, b,
            input select,
            output[63:0] result); // output 

assign result = select == 1'b1 ? b: a;
endmodule
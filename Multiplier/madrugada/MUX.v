module MUX(
            input[63:0] a, b,
            input select,
            output[63:0] result); // output 

assign result = (a&select)|(b&(~select));
endmodule

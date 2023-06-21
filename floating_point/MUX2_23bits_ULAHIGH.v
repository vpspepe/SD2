module MUX2_23bits_ULAHIGH(
            input[22:0] a, 
            input[22:0] b,       //0 1
            input [1:0] select,
            output[22:0] result
);

assign result = (select == 1) ? b :( (select == 0) ? a : ((a > b) ? a : b));


endmodule
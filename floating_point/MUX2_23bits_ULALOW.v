module MUX2_23bits_ULALOW(
            input[22:0] a, 
            input[22:0] b,       //0 1
            input [1:0] select,
            output[22:0] result
);

assign result = (select == 1) ? a : ((select == 0) ? b : ((a > b) ? b : a));


endmodule
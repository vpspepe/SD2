module MUX2_23bits(
            input[22:0] a, 
            input[22:0] b,       //0 1
            input select,
            output[22:0] result
);

assign result = (select == 1) ? b : a;


endmodule
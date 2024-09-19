module MUX2_29bits(
            input[28:0] a, 
            input[28:0] b,       //0 1
            input select,
            output[28:0] result
);

assign result = (select == 1) ? b[28:0] : a[28:0];


endmodule
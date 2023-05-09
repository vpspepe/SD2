module MUX2_32(
            input[31:0] a, b,       //0 1
            input select,
            output[31:0] result);   // output 

assign result = select == 1'b1 ? b: a;


endmodule
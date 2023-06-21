module MUX2_8bits_1(
            input[7:0] a, 
            input[7:0] b,       //0 1
            input  select,
            output[7:0] result);   // output 

assign result = select == 1 ? b[7:0] : a[7:0];


endmodule
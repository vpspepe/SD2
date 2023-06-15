module MUX4_64(
            input[63:0] a, b, c, d,    //00 01 10 11
            input[1:0] select,
            output[63:0] result);      // output 

assign result = select[1] ? (select[0] ? d : c) : (select[0] ? b : a); 

endmodule
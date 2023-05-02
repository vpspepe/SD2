module ULA(
            input[63:0] a , b,
            input soma_sub,
            output[63:0] result
);

assign result = soma_sub == 1'b1 ? (a-b): (a+b);



endmodule
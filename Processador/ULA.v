module ULA(
            input[63:0] a , b,
            input soma_sub,
            output[63:0] result,
            output[5:0] flags
);

parameter BEQ = 0, BNE = 1, BLT = 2, BGE = 3, BLTU = 4, BGEU = 5 ;
assign result = soma_sub == 1'b1 ? (a-b): (a+b);

assign flags[BEQ] = a == b ? 1 : 0;
assign flags[BNE] = a == b ? 0 : 1;
assign flags[BLT] = a < b ? 1 : 0;
assign flags[BGE] = a >= b ? 1 : 0;
assign flags[BLTU] = $unsigned(a) < $unsigned(b) ? 1 : 0;
assign flags[BGEU] = $unsigned(a) >= $unsigned(b) ? 1 : 0;

endmodule
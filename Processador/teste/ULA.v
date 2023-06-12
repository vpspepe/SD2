module ULA(
            input[63:0] a , b,
            input [3:0] op, // input vem da ULA_control
            output[63:0] result,
            output[3:0] flags
);
wire[63:0] ula_out;
parameter BEQ = 0, MSB = 1, Overflow = 2;
parameter SOMA = 4'b0010, SUB = 4'b0110, AND = 4'b0000, OR = 4'b0001;
//parameter BNE = 1, BLT = 2, BGE = 3, BLTU = 4, BGEU = 5 ;
assign ula_out = op == SUB ? (a-b):
        (op == SOMA ? (a+b) :
        (op == AND ? (a&b) : (a|b)));
assign result = ula_out;

assign flags[3] = 0;
assign flags[BEQ] = a == b ? 1 : 0;
assign flags[MSB] = ula_out[63];
assign flags[Overflow] = (op == 4'b0110) ? 
                ( (a[63] != b[63] & ula_out[63] != a[63]) ? 1 : 0) : // se for uma sub, o msb de a e b forem diferentes e o msb do resultado for diferente do msb de a, deu overflow
                ((a[63] == b[63] & ula_out[63] != a[63]) ? 1 : 0);  // se for uma add, o msb de a e b forem iguais e o msb do resultado for diferente do msb de a, deu overflow
// assign flags[BNE] = a == b ? 0 : 1;
// assign flags[BLT] = a < b ? 1 : 0;
// assign flags[BGE] = a >= b ? 1 : 0;
// assign flags[BLTU] = $unsigned(a) < $unsigned(b) ? 1 : 0;
// assign flags[BGEU] = $unsigned(a) >= $unsigned(b) ? 1 : 0;


endmodule
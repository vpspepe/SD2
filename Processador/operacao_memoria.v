module operacao_memoria(
    input [63:0] dinA,
    input [63:0] dinB,
    input [63:0] OFFSET,
    input [1:0] OP_MEM_I,
    input ADD_SUB,
    output [63:0] dout
    output [63:0] doutA, //valor de leitura do Registrador Ra
    output [63:0] doutB, //valor de leitura do Rb
);

wire [63:0] ULA_IN0,ULA_IN1; //saida da ULA para OPERAÇÃO e MEMORIA, respectivamente
wire [63:0] ULA_OUT;

assign dout = ULA_OUT;

MUX4_64 mux0(.a(dinA),.b(dinB),.c(dinA),.d(64'b0),.select(OP_MEM_I),.result(ULA_IN0));
MUX4_64 mux1(.a(dinB),.b(OFFSET),.c(OFFSET),.d(64'b0),.select(OP_MEM_I),.result(ULA_IN1));
ULA addsub(.a(ULA_IN0),.b(ULA_IN1),.soma_sub(ADD_SUB),.result(ULA_OUT));


endmodule
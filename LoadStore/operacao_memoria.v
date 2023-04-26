module operacao_memoria(
    input [63:0] dinA,
    input [63:0] dinB,
    input [4:0] OFFSET,
    input OP_MEM,
    input clk,
    input ADD_SUB,
    output [63:0] dout
);

assign dout = ULA_OUT;

wire [63:0] ULA_IN0,ULA_IN1; //saida da ULA para OPERAÇÃO e MEMORIA, respectivamente
wire [63:0] ULA_OUT;

MUX mux0(.a(dinA),.b(dinB),.select(OP_MEM),.result(ULA_IN0));
MUX mux1(.a(dinB),.b(OFFSET),.select(OP_MEM),.result(ULA_IN1));

ULA addsub(.a(ULA_IN0),.b(ULA_IN1),.soma_sub(ADD_SUB),.result(ULA_OUT));







endmodule
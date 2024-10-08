module ULA_selector(
    input [63:0] dinA,
    input [63:0] dinB,
    input [63:0] OFFSET,
    input [1:0] OP_MEM_I,
    input [3:0] op, // vem da ULA_control
    output [63:0] dout,
    output [63:0] doutA, //valor de leitura do Registrador Ra
    output [63:0] doutB, //valor de leitura do Rb
    output [5:0] flags
);

wire [63:0] ULA_IN0,ULA_IN1; //saida da ULA para OPERAÇÃO e MEMORIA, respectivamente
wire [63:0] ULA_OUT;



assign dout = ULA_OUT;

MUX4_64 mux0(.a(dinA),.b(dinB),.c(dinA),.d(64'b0),.select(OP_MEM_I),.result(ULA_IN0));
MUX4_64 mux1(.a(dinB),.b(OFFSET),.c(OFFSET),.d(64'b0),.select(OP_MEM_I),.result(ULA_IN1));


ULA ULA(.a(ULA_IN0),.b(ULA_IN1),.op(op),.result(ULA_OUT), .flags(flags));


endmodule
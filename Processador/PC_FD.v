module PC_FD(
     inc, //INCREMENTO
     load, 
     reset,
     in, //end_instruction DE ENTRADA
     instruction //SAIDA
);

input inc;
input load;
input reset;

parameter N = 32;
input [N-1:0] in; //end_instruction DE ENTRADA
output [N-1:0] instruction; //SAIDA

reg [N-1:0] end_instruction;
wire mux_inc, mux_load, mux_reset;

MemInstruction instrucoes(
    .instruction(end_instruction),.dout(instruction)
);

MUX MUX_inc(
    .a(end_instruction), .b(end_instruction + 1),
    .select(inc),
    .result(mux_inc)
);

MUX MUX_load(
    .a(end_instruction), .b(in),
    .select(load),
    .result(mux_load)
);

MUX MUX_reset(
    .a(end_instruction), .b(0),
    .select(reset),
    .result(end_instruction)
);

endmodule

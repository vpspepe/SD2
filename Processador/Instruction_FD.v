module Instruction_FD(
    input clk, 
    input reset,
    input inc,
    input load,
    input [31:0] in
);

    wire[31:0] instruction;

    PC_FD u1(
        .inc(inc),.load(load),.reset(reset),.in(in),.instruction(instruction);
    );
    
    FD u2(
    .Ra(instruction[19:15]),   //guarda endereço de acesso ao banco de registradores
    .Rb(instruction[24:20]),   //guarda endereço de acesso da memória (constante e igual a 0)
    .Rw(instruction[11:7]),  
     .WE_reg(instruction[]), .WE_mem(),       
     .doutA() ,//valor de leitura do Registrador Ra
     .doutB(), //valor de leitura do Rb
     .doutMem(),
     .clk(),
     .OFFSET(),
     .OP_MEM(),
     .ADD_SUB()
);


//ta incompleto huh?

endmodule
module Instruction_FD(
    input clk, 
    input WE_mem,
    input WE_reg,
    input [1:0] OP_MEM_I,
    input ADD_SUB,
    input PC_load,
    output [31:0] instruction_out,
    input [5:0] flags
);

    
    wire[31:0] addr_instruction;
    wire[31:0] instruction;
    wire [4:0] Ra,Rb,Rw;
    wire [31:0] imm;
    wire [31:0] imm_or_const;
    wire [31:0] PC_addr;

    assign imm = instruction[6:0] == 7'b0110011 ? {5'b00000,instruction[31:25]} : instruction[31:20];
    assign Ra = instruction[19:15];
    assign Rb = instruction[6:0] == 7'b0110011 ? instruction [24:20] : 0;
    assign Rw = instruction[11:7];


    assign imm_out = imm;
    assign instruction_out = instruction;
    
FD FD(
    .Ra(Ra),   //guarda endereço de acesso ao banco de registradores
    .Rb(Rb),   //guarda endereço de acesso da memória (constante e igual a 0)
    .Rw(Rw),  
    .WE_reg(WE_reg), .WE_mem(WE_mem),       
    .clk(clk),
    .OFFSET(imm),
    .OP_MEM_I(OP_MEM_I),
    .ADD_SUB(ADD_SUB)
);

Reg32 PC(
    .clk(clk),
    .x(PC_addr), 
    .load(PC_load),
    .x_out(addr_instruction)
);

MemInstruction mem_instruction(
    .instruction(addr_instruction),
    .dout(instruction)
);

MUX2_32 MUX2(.a(1),.b(imm),.select(flags),.result(imm_or_const));

adder add(.a(imm_or_const),.b(addr_instruction),.result(PC_addr));

endmodule
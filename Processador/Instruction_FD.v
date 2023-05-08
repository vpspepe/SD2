module Instruction_FD(
    input clk, 
    input WE_mem,
    input WE_reg,
    input [1:0] OP_MEM_I,
    input ADD_SUB,
    input PC_load,
    input[31:0] PC_add,
    output [31:0] instruction_out,
    output [4:0] Ra_out,Rb_out,Rw_out,
    output [63:0] offset_out
);

    
    wire[31:0] add_instruction;
    wire[31:0] instruction;
    wire [4:0] Ra,Rb,Rw;
    wire [63:0] offset;


    assign offset = instruction[6:0] == 7'b0110011 ? {5'b00000,instruction[31:25]} : instruction[31:20];
    assign Ra = instruction[19:15];
    assign Rb = instruction[6:0] == 7'b0110011 ? instruction [24:20] : 0;
    assign Rw = instruction[11:7];
    assign Ra_out = Ra;
    assign Rb_out = Rb;
    assign Rw_out = Rw;


    assign offset_out = offset;
    assign instruction_out = instruction;
    
FD FD(
    .Ra(Ra),   //guarda endereço de acesso ao banco de registradores
    .Rb(Rb),   //guarda endereço de acesso da memória (constante e igual a 0)
    .Rw(Rw),  
    .WE_reg(WE_reg), .WE_mem(WE_mem),       
    .clk(clk),
    .OFFSET(offset),
    .OP_MEM_I(OP_MEM_I),
    .ADD_SUB(ADD_SUB)
);

Reg32 PC(
    .clk(clk),
    .x(PC_add), 
    .load(PC_load),
    .x_out(add_instruction)
);

MemInstruction mem_instruction(
    .instruction(add_instruction),
    .dout(instruction)
);



endmodule
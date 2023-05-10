module Instruction_FD(
    input clk, 
    input WE_mem,
    input WE_reg,
    input [1:0] OP_MEM_I,
    input ADD_SUB,
    input PC_load, IR_load,
    input [2:0] select_flags,
    input reset
);

    wire [31:0] PC_addr;
    wire[31:0] addr_instruction;
    wire[31:0] instruction, instruction_IR_out;
    wire [4:0] Ra,Rb,Rw;
    wire [63:0] imm;
    wire [31:0] imm_or_const;
    wire selected_flag;
    wire [5:0] flags;

    //parameter R_TYPE = 7'b0110011 , I_TYPE_ADD = 77'b0010011, I_TYPE_LOAD = 7'b0000011, S_TYPE = 7'b0010011, B_TYPE = 7'b1100011, JTYPE_REG = 7'b1100111, JTYPE = 7'b1101111, UTYPE = 7'0110111, UTYPE_ADD = 7'b0010111; 
    //OLHEM o instructionMEM para entender os valores. O type indica isso la.
    assign imm = instruction_IR_out[6:0] == 7'b0110011 ?
        ((instruction_IR_out[31]) ?  //se o 1o bit for 1 ... se for 0 ...
            {5'b11111,instruction_IR_out[31:25]} :
            {5'b00000,instruction_IR_out[31:25]}) 
        : instruction_IR_out[6:0] == 7'b1100011 ? 
            {5'b00000,instruction_IR_out[31:25]} :   //era pra ser {instruction_IR_out[31:25],instruction_IR_out[11:7]} 
            instruction_IR_out[31:20];
    assign Ra = instruction_IR_out[19:15];
    assign Rb = (instruction_IR_out[6:0] == 7'b0110011 | instruction_IR_out[6:0] == 7'b1100011) ? instruction_IR_out [24:20] : 5'b0;
    assign Rw = instruction_IR_out[6:0] == 7'b1100011 ? 5'b0 : instruction_IR_out[11:7];
    
FD FD(
    .Ra(Ra),   //guarda endereço de acesso ao banco de registradores
    .Rb(Rb),   //guarda endereço de acesso da memória (constante e igual a 0)
    .Rw(Rw),  
    .WE_reg(WE_reg), .WE_mem(WE_mem),       
    .clk(clk),
    .OFFSET(imm),
    .OP_MEM_I(OP_MEM_I),
    .ADD_SUB(ADD_SUB),
    .flags(flags)
);

Reg32 PC(
    .clk(clk),
    .x(PC_addr), 
    .load(PC_load),
    .x_out(addr_instruction),
    .reset(reset)
);


MemInstruction mem_instruction( //ROM COM A MEMORIA DE INSTRUCOES
    .instruction(addr_instruction),
    .dout(instruction)
);

Reg32 InstructionRegister(
    .clk(clk),
    .x(instruction), 
    .load(IR_load),
    .x_out(instruction_IR_out),
    .reset(reset)
);


MUX8_32 MUX8(.flags(flags),.select(select_flags),.flag(selected_flag)); //

MUX2_32 MUX2(.a(1),.b(imm[31:0]),.select(selected_flag),.result(imm_or_const));


adder add(.a(imm_or_const),.b(addr_instruction),.result(PC_addr));



endmodule
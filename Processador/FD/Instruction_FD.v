module Instruction_FD(
    input clk, 
    input WE_mem,
    input WE_reg,
    input [1:0] OP_MEM_I,
    input ADD_SUB,
    input PC_load, IR_load,
    input JAL, JALR, AUIPC,
    input [2:0] select_flags,
    input reset
);

    wire [31:0] PC_addr;
    wire[31:0] addr_instruction;
    wire[31:0] instruction, instruction_IR_out;
    wire [4:0] Ra,Rb,Rw;
    wire [31:0] imm;
    wire [31:0] imm_or_const;
    wire selected_flag;
    wire [5:0] flags;
    wire [63:0] doutA;
    wire soma_PC_sel;
    wire[31:0] PC_or_RS;
    wire [63:0] dIN;
    wire [63:0] OFFSET;

    assign OFFSET = imm[31] ? {32'b1,imm} : {32'b0,imm} ;
    
    Generator instruction_organizor (.opcode(instruction_IR_out[6:0]),
    .instruction(instruction_IR_out),
    .immediate(imm),
    .Ra(Ra), 
    .Rb(Rb),
    .Rw(Rw));
    
    /*assign imm = instruction_IR_out[6:0] == 7'b0110011 ?
        ((instruction_IR_out[31]) ?  //se o 1o bit for 1 ... se for 0 ...
            {5'b11111,instruction_IR_out[31:25]} :
            {5'b00000,instruction_IR_out[31:25]}) 
        : instruction_IR_out[6:0] == 7'b1100011 ? 
            {5'b00000,instruction_IR_out[31:25]} :   //era pra ser {instruction_IR_out[31:25],instruction_IR_out[11:7]} 
            instruction_IR_out[31:20];
    assign Ra = instruction_IR_out[19:15];
    assign Rb = (instruction_IR_out[6:0] == 7'b0110011 | instruction_IR_out[6:0] == 7'b1100011) ? instruction_IR_out [24:20] : 5'b0;
    assign Rw = instruction_IR_out[6:0] == 7'b1100011 ? 5'b0 : instruction_IR_out[11:7];*/
    
FD FD(
    .Ra(Ra),   //guarda endereço de acesso ao banco de registradores
    .Rb(Rb),   //guarda endereço de acesso da memória (constante e igual a 0)
    .Rw(Rw),  
    .WE_reg(WE_reg), .WE_mem(WE_mem),
    .doutA_IFD(doutA),
    .dIN(dIN), 
    .clk(clk),
    .OFFSET(OFFSET),
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
    .clk(~clk),
    .x(instruction), 
    .load(IR_load),
    .x_out(instruction_IR_out),
    .reset(reset)
);


MUX8_1 MUX8(.flags(flags),.select(select_flags),.flag(selected_flag)); //escolhe a flag

assign soma_PC_sel = (JAL | JALR) ? 1 : selected_flag; //se for jal ou jalr, vai passar o imediato para o adder. se não, vai passar a flag

MUX2_32 MUX2(.a(4),.b(imm[31:0]),.select(soma_PC_sel),.result(imm_or_const)); // escolhe se 4 ou o imediato será somado na entrada do pc

assign PC_or_RS = JALR ? doutA : addr_instruction; //Se JALR for 1, entao doutA soma no adder, se JALR for 0, entao soma o PC (addr_instruction) -> RS = regFile[s]

adder add(.a(imm_or_const),.b(PC_or_RS),.result(PC_addr)); //cooloca a entrada do pc como (imm + pc / jal e branch), (pc + 4 / normal, auipc) ou (RF[Ra] + imm/ jalr)

assign dIN = (JAL | JALR) ? ( addr_instruction + 4) : (addr_instruction + imm); //quando JAL ou JALR, o DIN do RF vale (PC+4). Caso contrário (AUIPC) o dIN = (PC + IMM + 12'b0)

endmodule
module Processador_FD(
    input  clk,
    input  clk_IR, //clock do IR que usa sinal contrario do clk
    input  rf_we, PC_load, IR_load, 
    input  JAL, JALR, //sinais indicam se operacao eh de jump and link (reg)
    input  reset, //reseta o PC pra 0, como se fosse um boot
    input  [1:0] OP_MEM_I,
    input  [31:0] instruction, //intrucao que chegar da memoria de instrucoes
    input  [63:0] Data, //dado que vem da memória(load), ula (add/addi/sub) ou do pc (jal)
    input  [1:0] ULAop,
    output [6:0] opcode, //opcode enviado para UC
    output [63:0] addr_RAM, //endereco enviado para a memoria RAM
    output [63:0] data_RAM, //dados enviados a memoria RAM
    output [31:0] PC //endereco enviado para a memoria de instrucoes
);

wire [31:0] addr_instruction;
wire [31:0] PC_addr; //endereco que entra no PC
wire [31:0] instruction_IR_out; //entrada e saida do IR
wire [6:0] funct7;
wire [2:0] funct3;
wire [4:0] Ra,Rb,Rw; //entradas do reg file e da ula
wire ADD_SUB; //com base no funct 7 ele vai definir se a ULA soma ou subtrai
wire [31:0] imm; //imediato
wire [63:0] doutA; //saida do regfile (reg[Ra])
wire [63:0] doutB; //saida do regfile (reg[Ra])
wire [63:0] RF_input; //entrada do Regfile   
wire [63:0] OFFSET;
wire [3:0] op;
wire [63:0] ULA_OUT;
wire [5:0] flags;
wire [2:0] select_flags; //ISSO N EXISTE ASSIM EH SO PRA TESTE

assign OFFSET = imm[31] ? {32'b1,imm} : {32'b0,imm} ; // completa os demais bits com 1 ou 0 (- ou +)
assign opcode = instruction_IR_out[6:0];
assign PC = addr_instruction;
assign addr_RAM = ULA_OUT;
assign data_RAM = doutA;


Generator instruction_organizor ( //organiza os valores com base na instrucao de 32 bits
    .opcode(instruction_IR_out[6:0]),
    .instruction(instruction_IR_out),
    .immediate(imm),
    .Ra(Ra), 
    .Rb(Rb),
    .Rw(Rw),
    .funct3(funct3),
    .funct7(funct7)
);

Reg32 PCreg( //PROGRAM COUNTER
    .clk(clk),
    .x(PC_addr), 
    .load(PC_load),
    .x_out(addr_instruction),
    .reset(reset)
);
 // se o sinal da ula (pc_src) for 1, faz PC+IMM na entrada do PC. Se nao faz PC + 4
assign x = pc_src ? (addr_instruction + OFFSET) : (addr_instruction + 4);

Reg32 IR( //INSTRUCTION_REGISTER
    .clk(clk_IR),
    .x(instruction), 
    .load(IR_load),
    .x_out(instruction_IR_out),
    .reset(reset)
);

Reg_Banco RegFile( //REGISTER fILE QUE CONTEM O BANCO DE REGISTRADORES
    .Ra(Ra),
    .Rb(Rb),
    .Rw(Rw),
    .WE_Reg(rf_we),
    .dIN(RF_input),
    .doutA(doutA),
    .doutB(doutB),
    .clk(clk)
);

ULA_control ULAcontrol(
    .funct7(funct7), 
    .funct3(funct3),
    .ULAop(ULAop),
    //input [5:0] flags,
    //output branch,
    .op(op)
);

ULA_selector ULA_seletor( //seleciona o que entra na ULA principal
    .dinA(doutA),
    .dinB(doutB),
    .OFFSET(OFFSET),
    .OP_MEM_I(OP_MEM_I),
    .op(op),
    .dout(ULA_OUT),
    .flags(flags)
);


RF_e_PC_Input Inputs_rf_pc_controller(
    .flags(flags),
    .select_flags(select_flags),
    .doutA(doutA), //imediato e doutA
    .addr_instruction32(addr_instruction), 
    .imm32(imm), //endereco de 32bits que SAI do PC
    .ULA_OUT(ULA_OUT), 
    .Data(Data), //saida da ULA pricnipal, 
    .select_RF(OP_MEM_I),
    .JAL(JAL), 
    .JALR(JALR),
    .PC_addr32(PC_addr),
    .RF_input(RF_input)
);
// MUX4_64 MUX4(.a(ULA_OUT),.b(Data),.c(ULA_OUT),.d(dIN_JAL),.select(OP_MEM_I),.result(Dw)); //seleciona a entrada do regfile

// MUX8_1 MUX8(.flags(flags),.select(select_flags),.flag(selected_flag)); //escolhe a flag

// assign soma_PC_sel = (JAL | JALR) ? 1 : selected_flag; //se for jal ou jalr, vai passar o imediato para o adder. se não, vai passar a flag

// MUX2_32 MUX2(.a(4),.b(imm[31:0]),.select(soma_PC_sel),.result(imm_or_const)); // escolhe se 4 ou o imediato será somado na entrada do pc

// assign PC_or_RS = JALR ? doutA : addr_instruction; //Se JALR for 1, entao doutA soma no adder, se JALR for 0, entao soma o PC (addr_instruction) -> RS = regFile[s]

// adder add(.a(imm_or_const),.b(PC_or_RS),.result(PC_addr)); //cooloca a entrada do pc como (imm + pc / jal e branch), (pc + 4 / normal, auipc) ou (RF[Ra] + imm/ jalr)

// assign dIN_JAL = (JAL | JALR) ? ( addr_instruction + 4) : (addr_instruction + imm); //quando JAL ou JALR, o DIN do RF vale (PC+4). Caso contrário (AUIPC) o dIN = (PC + IMM + 12'b0)

endmodule
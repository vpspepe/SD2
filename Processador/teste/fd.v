module fd(
    input  clk,
    input  rf_we, d_mem_we, pc_src, rf_src, alu_src,
    input  rst_n, //rst_na o PC pra 0, como se fosse um boot
    input  [3:0] alu_cmd,
    output [6:0] opcode, //opcode enviado para UC
    output [5:0] d_mem_addr, //endereco enviado para a memoria RAM
    inout [63:0] d_mem_data, //dados enviados a memoria RAM
    output [5:0] i_mem_addr, //endereco enviado para a memoria de instrucoes
    input  [31:0] i_mem_data, //intrucao que chegar da memoria de instrucoes
    output [3:0] alu_flags

);

wire [63:0] d_mem_data_in, d_mem_data_out; //entrada e saida da memoria ram
wire [31:0] addr_instruction; //endereco da memoria que chega ate o memoria de instruoes
wire [31:0] PC_addr; //endereco que entra no PC
wire [31:0] instruction_IR_out; //entrada e saida do IR ( a instrucao)
wire [6:0] funct7;
wire [2:0] funct3;
wire [4:0] Ra,Rb,Rw; //entradas do reg file e da ula
wire [31:0] imm; //imediato
wire [63:0] doutA; //saida do regfile (reg[Ra])
wire [63:0] doutB; //saida do regfile (reg[Ra])s
wire [63:0] RF_input; //entrada do Regfile   
wire [63:0] OFFSET; //imediado com sinal ajsutado
wire [3:0] op; //saida do ula control e indica o que deve ser feito na ula
wire [63:0] ULA_OUT;
wire [5:0] flags;
wire [2:0] select_flags; //ISSO N EXISTE ASSIM EH SO PRA TESTE

assign OFFSET = imm[31] ? {32'b1,imm} : {32'b0,imm} ; // completa os demais bits com 1 ou 0 (- ou +)
assign opcode = instruction_IR_out[6:0];
assign i_mem_addr = addr_instruction[7:2];
assign d_mem_addr = ULA_OUT[5:0];
assign d_mem_data_out = doutB;


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
    .load(1'b1),
    .x_out(addr_instruction),
    .reset(rst_n)
);
 // se o sinal da ula (pc_src) for 1 E a flag BEQ for 1, faz PC+IMM na entrada do PC. Se nao faz PC + 4
assign PC_addr = pc_src ? 
        (flags[0] ? (addr_instruction + OFFSET) : (addr_instruction + 4) ) 
        :   (addr_instruction + 4);

Reg32 IR( //INSTRUCTION_REGISTER
    .clk(~clk),
    .x(i_mem_data), 
    .load(1'b1),
    .x_out(instruction_IR_out),
    .reset(rst_n)
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

assign RF_input = rf_src ? d_mem_data_in : ULA_OUT;
assign d_mem_data = d_mem_we ? d_mem_data_out : 64'bz;
assign d_mem_data_in = d_mem_data;

ULA_control ULAcontrol(
    .funct7(funct7), 
    .funct3(funct3),
    .alu_cmd(alu_cmd),
    .op(op)
);

ULA_selector ULA_seletor( //seleciona o que entra na ULA principal
    .dinA(doutA),
    .dinB(doutB),
    .OFFSET(OFFSET),
    .alu_src(alu_src),
    .op(op),
    .dout(ULA_OUT),
    .flags(flags)
);


// RF_e_PC_Input Inputs_rf_pc_controller(
//     .flags(flags),
//     .select_flags(select_flags),
//     .doutA(doutA), //imediato e doutA
//     .addr_instruction32(addr_instruction), 
//     .imm32(imm), //endereco de 32bits que SAI do PC
//     .ULA_OUT(ULA_OUT), 
//     .Data(Data), //saida da ULA pricnipal, 
//     .select_RF(OP_MEM_I),
//     .JAL(JAL), 
//     .JALR(JALR),
//     .PC_addr32(PC_addr),
//     .RF_input(RF_input)
// );

endmodule
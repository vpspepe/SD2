module RF_e_PC_Input(
    input[5:0] flags,
    input[2:0] select_flags,
    input[63:0] doutA, //imediato e doutA
    input[31:0] addr_instruction32, imm32, //endereco de 32bits que SAI do PC
    input[63:0] ULA_OUT, Data, //saida da ULA pricnipal, 
    input[1:0] select_RF,
    output[31:0] PC_addr32,
    output[63:0] RF_input
);

wire soma_PC_selector, selected_flag;
wire[31:0] PC_or_RS; //-> RS = regFile[s]
wire[31:0] imm_or_const; //uma das entradas do somador que cai no PC
input [63:0] dIN_JAL, addr_instruction64, imm64;

assign addr_instruction64 = addr_instruction32[31] ? {32'b1,addr_instruction32} : {32'b0,addr_instruction32} ; // completa os demais bits com 1 ou 0 (- ou +)
assign imm64 = imm32[31] ? {32'b1,imm32} : {32'b0,imm32} ; // completa os demais bits com 1 ou 0 (- ou +)



MUX8_1 MUX8(.flags(flags),.select(select_flags),.flag(selected_flag)); //escolhe a flag

assign soma_PC_selector = (JAL | JALR) ? 1 : selected_flag; //se for jal ou jalr, vai passar o imediato para o adder. se não, vai passar a flag

MUX2_32 MUX2(.a({29'b0,3'b100}),.b(imm32),.select(soma_PC_selector),.result(imm_or_const)); // escolhe se 4 ou o imediato será somado na entrada do pc

assign PC_or_RS = JALR ? doutA[31:0] : addr_instruction32; //Se JALR for 1, entao doutA soma no adder, se JALR for 0, entao soma o PC (addr_instruction) 

adder addPC(.a(imm_or_const),.b(PC_or_RS),.result(PC_addr32)); //cooloca a entrada do pc como (imm + pc / jal e branch), (pc + 4 / normal, auipc) ou (RF[Ra] + imm/ jalr)

assign dIN_JAL = (JAL | JALR) ? ( addr_instruction64 + 4) : (addr_instruction64 + imm64); //quando JAL ou JALR, o DIN do RF vale (PC+4). Caso contrário (AUIPC) o dIN = (PC + IMM + 12'b0)

MUX4_64 MUX4_RF(.a(ULA_OUT),.b(Data),.c(ULA_OUT),.d(dIN_JAL),.select(select_RF),.result(RF_input)); //seleciona a entrada do regfile

endmodule

module Processador(
    input reset,
    input clk
);

//UC:
    // UC -> FD
        wire RF_load, JAL, JALR;
        wire PC_load, IR_load;
        wire [1:0] ULAop;
        wire [1:0] OP_MEM_I;
    //UC -> Memoria
        wire WE;

//FD: 
    // FD -> UC
        wire [6:0] opcode;
    // FD -> Memoria
        wire [63:0] address;
        wire [63:0] dout_FD;
        wire [31:0] PC;
    //

//Memoria:
    // Memoria -> FD
        wire [31:0] instruction;
        wire [63:0] dout_memoria;
        
    // Memoria -> UC


UC UnitControl(
    .opcode(opcode),
    .clk(clk), 
    .reset(reset),
    .PC_load(PC_load),
    .WEMem(WE),
    .RF_load(RF_load), 
    .ULAop(ULAop),
    .IR_load(IR_load),
    .OP_MEM_I(OP_MEM_I),
    .select_JAL(JAL),
    .select_JALR(JALR)
); 


Memoria Mem(
    .dIn(dout_FD),
    .PC(PC),
    .address(address),
    .WE(WE),
    .clk(clk),
    .instruction(instruction),
    .data_out(dout_memoria)
);


Processador_FD FD(
    .clk(clk),
    .clk_IR(~clk), //clock do IR que usa sinal contrario do clk
    .RF_load(RF_load), .PC_load(PC_load), .IR_load(IR_load), 
    .JAL(JAL), .JALR(JALR), //sinais indicam se operacao eh de jump and link (reg)
    .reset(reset), //reseta o PC pra 0, como se fosse um boot
    .OP_MEM_I(OP_MEM_I),
    .instruction(instruction), //intrucao que chegar da memoria de instrucoes
    .Data(dout_memoria), //dado que vem da memória(load), ula (add/addi/sub) ou do pc (jal)
    .ULAop(ULAop),
    .opcode(opcode), //opcode enviado para UC
    .addr_RAM(address), //endereco enviado para a memoria RAM
    .data_RAM(dout_FD), //dados enviados a memoria RAM
    .PC(PC) //endereco enviado para a memoria de instrucoes

);


endmodule
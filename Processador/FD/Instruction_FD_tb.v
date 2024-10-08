`timescale  10ns/100ps

module Instruction_FD_tb();

reg clk_tb; 
reg WE_mem_tb;
reg WE_reg_tb;
reg [1:0] OP_MEM_I_tb;
reg ADD_SUB_tb;
reg PC_load_tb, IR_load_tb;
reg [2:0] select_flags_tb;
reg reset_tb;
reg JAL_tb, JALR_tb, AUIPC_tb;



Instruction_FD instruction_fd(
    .clk(clk_tb), 
    .WE_mem(WE_mem_tb),
    .WE_reg(WE_reg_tb),
    .OP_MEM_I(OP_MEM_I_tb),
    .ADD_SUB(ADD_SUB_tb),
    .PC_load(PC_load_tb),
    .IR_load(IR_load_tb),
    .JAL(JAL_tb),
    .JALR(JALR_tb),
    .AUIPC(AUIPC_tb),
    .select_flags(select_flags_tb),
    .reset(reset_tb)
);

initial begin

/*INSTRUÇÔES DESSA TEST_BENCH

    1.INICIALIZAÇÃO DA MEMÓRIA COM VALORES NA POSIÇÃO 0 e 1. Mem[1] = 10; Mem[2] = 20
    2. LOAD DESSES VALORES NO BANCO DE REGISTRADORES, memória 1 no reg 1 e memória 2 no reg 2.
    3. SOMA ENTRE ESSES VALORES do banco, guardando valor no registrador 3, também do banco. (20 + 10 = 30)
    4. SUBTRAÇÃO entre valor do reg 3 e valor do reg 1, guardando no reg 4. (30 - 10 = 20)
    5. STORE dos valores de reg 3 e reg 4 na mem 3 e mem 4, respectivamente.

*/


    $dumpfile("testbenches/vvp/waveforms3.vcd");
    $dumpvars(0, Instruction_FD_tb);

    // $monitor("PC_AD = %d|| OP_MEM = %d|ADD_SUB = %d|We_reg = %d|WE_mem = %d|doutMem = %d,doutA = %d, doutB = %d,Ra = %d, Rb = %d, Rw = %d, OFFSET = %d",
    // 
    // ,OP_MEM_I_tb,
    // ADD_SUB_tb,
    // WE_reg_tb,
    // WE_mem_tb,
    // doutMem_tb,
    // doutA_tb,
    // doutB_tb,
    // Ra_tb,
    // Rb_tb,
    // Rw_tb,
    // offset_tb);

//0. INICIALIZAÇÃO DE TODOS OS PARAMETROS EM 0

WE_mem_tb = 0;
WE_reg_tb = 0;
ADD_SUB_tb = 0;
OP_MEM_I_tb = 0;
clk_tb = 1;
PC_load_tb = 1;
IR_load_tb = 1;
reset_tb = 1;
JAL_tb = 0;
JALR_tb = 0;
AUIPC_tb = 0;

//1. INICIALIZANDO VALOR NA MEMORIA (linha 25 -> arquivo 'Memoria.v')

//2. LOADs no Banco de registradores ld x1,0(x0) e ld x2,1(x0)
#15
reset_tb = 0;

//ld x1,1(x0)
#15
OP_MEM_I_tb = 1;
WE_mem_tb = 0;
WE_reg_tb = 1;
ADD_SUB_tb = 0;

//ld x2,2(x0)
#20
OP_MEM_I_tb = 1;
WE_mem_tb = 0;
WE_reg_tb = 1;
ADD_SUB_tb = 0;

//3. Operação de Soma dos valores armazenados no reg[1] e reg[2] do banco e guardando no reg[3] do banco (10 + 20 = 30)

#20
OP_MEM_I_tb = 0;
WE_mem_tb = 0;
WE_reg_tb = 1;
ADD_SUB_tb = 0;
 //soma

//4. Agora, Subtração do que está no reg[3] e no reg[1], guardando no reg[4] (30 - 10 = 20)
#20
OP_MEM_I_tb = 0;
WE_mem_tb = 0;
WE_reg_tb = 1;
ADD_SUB_tb = 1;//sub

//5. Store do que está no reg[3] para a posição 3 da memória e do que está no reg[4] para a posição 4 da memória.

#20 //store 1  
OP_MEM_I_tb = 1;
WE_mem_tb = 1;
WE_reg_tb = 0;
ADD_SUB_tb = 0;




#20 //store 2
OP_MEM_I_tb = 1;
WE_mem_tb = 1;
WE_reg_tb = 0;
ADD_SUB_tb = 0;

//addi x9, #10(x4) -> addi Rw, #IMM(Ra)

#20
OP_MEM_I_tb = 2;
WE_mem_tb = 0;
WE_reg_tb = 1;
ADD_SUB_tb = 0;

//store x9,#9(x0)
#20 
OP_MEM_I_tb = 1;
WE_mem_tb = 1;
WE_reg_tb = 0;
ADD_SUB_tb = 0;

//BEQ x3,x3 #8
#20
select_flags_tb = 0;
OP_MEM_I_tb = 0;
WE_mem_tb = 0;
WE_reg_tb = 0;
ADD_SUB_tb = 0;

//add x5,x1,x2
#20
select_flags_tb = 8;
OP_MEM_I_tb = 0;
WE_mem_tb = 0;
WE_reg_tb = 1;
ADD_SUB_tb = 0;


//jal x11, #8    -> regfile[11] = PC + 4; PC = PC + 8  [mem48] 
#20
select_flags_tb = 8;
OP_MEM_I_tb = 3;
WE_mem_tb = 0;
WE_reg_tb = 1;
ADD_SUB_tb = 0;
JAL_tb = 1;
JALR_tb = 0;
AUIPC_tb = 0;

//jalr x14,#8(x11)    regfile[14] = PC + 4   ; PC = regfile[11] + 8   [mem56]
#20
select_flags_tb = 8;
OP_MEM_I_tb = 3;
WE_mem_tb = 0;
WE_reg_tb = 1;
ADD_SUB_tb = 0;
JAL_tb = 0;
JALR_tb = 1;
AUIPC_tb = 0;



#20 //load x6, #5(x0) x6 = -10
OP_MEM_I_tb = 1;
WE_mem_tb = 0;
WE_reg_tb = 1;
ADD_SUB_tb = 0;
JALR_tb = 0;

#20 //x7 = x1 + x6 
OP_MEM_I_tb = 0;
WE_mem_tb = 0;
WE_reg_tb = 1;
ADD_SUB_tb = 0;
 //soma

#20 //sub x8,x2 x1 (x8=10)
OP_MEM_I_tb = 0;
WE_mem_tb = 0;
WE_reg_tb = 1;
ADD_SUB_tb = 1;//sub

//auipc x10, #4096  regfile[10] = PC + 4096 [mem60]
#20 
select_flags_tb = 8;
OP_MEM_I_tb = 3;
WE_mem_tb = 0;
WE_reg_tb = 1;
ADD_SUB_tb = 0;
JAL_tb = 0;
JALR_tb = 0;
AUIPC_tb = 1;
#20
reset_tb = 1;

$finish;

end
always #10
    clk_tb = ~clk_tb;

/*
iverilog .\Instruction_FD_tb.v .\Instruction_FD.v .\FD.v .\Memoria.v .\MemInstruction.v .\Reg_Banco.v .\Reg64.v .\Reg32.v .\ULA.v .\operacao_memoria.v .\MUX4_64.v .\MUX2_32.v .\MUX8_1.v .\adder.v .\Generator.v
*/
    
endmodule
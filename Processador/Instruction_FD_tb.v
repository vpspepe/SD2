`timescale  10ns/100ps

module Instruction_FD_tb();

reg clk_tb; 
reg WE_mem_tb;
reg WE_reg_tb;
reg [1:0] OP_MEM_I_tb;
reg ADD_SUB_tb;
reg PC_load_tb;
reg[31:0] PC_add_tb;
wire [63:0] doutA_tb,doutB_tb;
wire [63:0] doutMem_tb;
wire [31:0] instruction_tb;
wire [4:0] Ra_tb,Rb_tb,Rw_tb;
wire [63:0] offset_tb;


Instruction_FD uut(
    .clk(clk_tb), 
    .WE_mem(WE_mem_tb),
    .WE_reg(WE_reg_tb),
    .OP_MEM_I(OP_MEM_I_tb),
    .ADD_SUB(ADD_SUB_tb),
    .PC_load(PC_load_tb),
    .PC_add(PC_add_tb),
    .doutMem(doutMem_tb),
    .doutA(doutA_tb),
    .doutB(doutB_tb),
    .instruction_out(instruction_tb),
    .Ra_out(Ra_tb),.Rb_out(Rb_tb),.Rw_out(Rw_tb),
    .offset_out(offset_tb)
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
    // PC_add_tb
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
PC_add_tb = 0;
PC_load_tb = 1;

//1. INICIALIZANDO VALOR NA MEMORIA (linha 25 -> arquivo 'Memoria.v')

//2. LOADs no Banco de registradores ld x1,0(x0) e ld x2,1(x0)

//ld x1,1(x0)
#20
PC_add_tb =1;
OP_MEM_I_tb = 1;
WE_mem_tb = 0;
WE_reg_tb = 1;
ADD_SUB_tb = 0;

//ld x2,2(x0)
#20
PC_add_tb = 2;
OP_MEM_I_tb = 1;
WE_mem_tb = 0;
WE_reg_tb = 1;
ADD_SUB_tb = 0;

//3. Operação de Soma dos valores armazenados no reg[1] e reg[2] do banco e guardando no reg[3] do banco (10 + 20 = 30)

#20
PC_add_tb = 3;
OP_MEM_I_tb = 1;
WE_mem_tb = 0;
WE_reg_tb = 1;
ADD_SUB_tb = 0;
 //soma

//4. Agora, Subtração do que está no reg[3] e no reg[1], guardando no reg[4] (30 - 10 = 20)
#20 
PC_add_tb = 4;
OP_MEM_I_tb = 0;
WE_mem_tb = 0;
WE_reg_tb = 1;
ADD_SUB_tb = 1;//sub

//5. Store do que está no reg[3] para a posição 3 da memória e do que está no reg[4] para a posição 4 da memória.

#20 //store 1  
PC_add_tb = 5;
OP_MEM_I_tb = 1;
WE_mem_tb = 1;
WE_reg_tb = 0;
ADD_SUB_tb = 0;




#20 //store 2
PC_add_tb = 6;
OP_MEM_I_tb = 1;
WE_mem_tb = 1;
WE_reg_tb = 0;
ADD_SUB_tb = 0;

//addi x9, #10(x4) -> addi Rw, #IMM(Ra)

#20
PC_add_tb = 7;
OP_MEM_I_tb = 2;
WE_mem_tb = 0;
WE_reg_tb = 1;
ADD_SUB_tb = 0;




//store x9,#9(x0)
#20 
PC_add_tb = 8;
OP_MEM_I_tb = 1;
WE_mem_tb = 1;
WE_reg_tb = 0;
ADD_SUB_tb = 0;


#20
PC_add_tb = 9;
OP_MEM_I_tb = 1;
WE_mem_tb = 0;
WE_reg_tb = 0;
ADD_SUB_tb = 0;


#20
PC_add_tb = 10;

#20
PC_add_tb = 11;

end

always #10
    clk_tb = ~clk_tb;


    
endmodule
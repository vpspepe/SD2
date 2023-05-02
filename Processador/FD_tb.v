`timescale  10ns/100ps

module FD_tb();

reg[4:0] Ra_tb;             //guarda endereço que só mexe no Banco de Registradores 
reg[4:0] Rb_tb;             //guarda endereço que só mexe na Memória
reg[4:0] Rw_tb;             // guarda endereço para escrever no Banco de Registradores
reg WE_reg_tb, WE_mem_tb;   //Controlam as operações    
wire [63:0] doutA_tb;       //valor de leitura do Registrador Ra
wire [63:0] doutB_tb;       //valor de leitura do Rb
wire [63:0] doutMem_tb;     //valor de saída da memória e entrada do Banco de Registradores
reg clk_tb;
reg [63:0] OFFSET_tb; 
reg ADD_SUB_tb, OP_MEM_tb;      


FD uut(
    .Ra(Ra_tb),
    .Rb(Rb_tb),   
    .Rw(Rw_tb),  
    .WE_reg(WE_reg_tb), 
    .WE_mem(WE_mem_tb),       
    .doutA(doutA_tb),                  
    .doutB(doutB_tb),                   
    .doutMem(doutMem_tb),
    .clk(clk_tb),
    .OFFSET(OFFSET_tb),
    .ADD_SUB(ADD_SUB_tb),
    .OP_MEM(OP_MEM_tb)
);


initial begin

/*INSTRUÇÔES DESSA TEST_BENCH

    1.INICIALIZAÇÃO DA MEMÓRIA COM VALORES NA POSIÇÃO 0 e 1. Mem[1] = 10; Mem[2] = 20
    2. LOAD DESSES VALORES NO BANCO DE REGISTRADORES, memória 1 no reg 1 e memória 2 no reg 2.
    3. SOMA ENTRE ESSES VALORES do banco, guardando valor no registrador 3, também do banco. (20 + 10 = 30)
    4. SUBTRAÇÃO entre valor do reg 3 e valor do reg 1, guardando no reg 4. (30 - 10 = 20)
    5. STORE dos valores de reg 3 e reg 4 na mem 3 e mem 4, respectivamente.

*/

    $monitor("Ra = %d|OFFSET = %d|Rb = %d|Rw = %d|OP_MEM = %d|ADD_SUB = %d|We_reg = %d|WE_mem = %d|doutA[%d] = %d|doutB[%d]= %d|doutMem[%d] = %d",
    Ra_tb,
    OFFSET_tb,
    Rb_tb,
    Rw_tb,
    OP_MEM_tb,
    ADD_SUB_tb,
    WE_reg_tb,
    WE_mem_tb,
    Ra_tb,
    doutA_tb,
    Rb_tb,
    doutB_tb,
    OFFSET_tb,
    doutMem_tb);

//0. INICIALIZAÇÃO DE TODOS OS PARAMETROS EM 0

OFFSET_tb = 0;
Ra_tb = 0;
Rb_tb = 0; 
Rw_tb = 0;
WE_mem_tb = 0;
WE_reg_tb = 0;
ADD_SUB_tb = 0;
OP_MEM_tb = 1; 
clk_tb = 1;

//1. INICIALIZANDO VALOR NA MEMORIA (linha 25 -> arquivo 'Memoria.v')

//2. LOADs no Banco de registradores ld x1,0(x0) e ld x2,1(x0)

//ld x1,1(x0)
#40

OP_MEM_tb = 1;
OFFSET_tb = 1;
Rw_tb = 1;
WE_reg_tb = 1;
Ra_tb = 1;

#40
OP_MEM_tb = 0;
OFFSET_tb = 0;
Rw_tb = 0;
WE_reg_tb = 0;
Ra_tb = 1;

//ld x2,2(x0)

#40
WE_reg_tb = 1;
OP_MEM_tb = 1;
OFFSET_tb = 2;
Rw_tb = 2;
Ra_tb = 2;

#40
WE_reg_tb = 0;
Rw_tb = 0;
OFFSET_tb = 0;

//3. Operação de Soma dos valores armazenados no reg[1] e reg[2] do banco e guardando no reg[3] do banco (10 + 20 = 30)

#40
WE_reg_tb = 1;
Ra_tb = 2;
Rb_tb = 1;
Rw_tb = 3;
OP_MEM_tb = 0;
ADD_SUB_tb = 0; //soma

#40
WE_reg_tb = 0;
Ra_tb = 3;
Rb_tb = 0;
Rw_tb = 0;
OP_MEM_tb = 0;
ADD_SUB_tb = 0; //soma

//4. Agora, Subtração do que está no reg[3] e no reg[1], guardando no reg[4] (30 - 10 = 20)
#40 //sub
WE_reg_tb = 1;
Ra_tb = 3;
Rb_tb = 1;
Rw_tb = 4;
ADD_SUB_tb = 1;

#40
Rw_tb = 0;
ADD_SUB_tb = 0;
Ra_tb = 0;
OP_MEM_tb = 0;
Rb_tb = 0;
WE_reg_tb = 0;

//5. Store do que está no reg[3] para a posição 3 da memória e do que está no reg[4] para a posição 4 da memória.

#40 //store 1  
OP_MEM_tb = 1;
Ra_tb = 3;
OFFSET_tb = 3;
WE_mem_tb = 1;

#40
WE_mem_tb = 0;
Rw_tb = 0;
ADD_SUB_tb = 0;
Ra_tb = 0;
Rb_tb = 0;

#40 //store 2
WE_mem_tb = 1;
Ra_tb = 4;
OFFSET_tb = 4;

#40 
WE_mem_tb = 0;

end

always #10
     clk_tb = ~clk_tb;
    
endmodule
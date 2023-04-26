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

    1.INICIA-SE ATRIBUINDO O VALOR 100 EM UM ENDEREÇO QUALQUER DA MEMÓRIA,  digamos no endereço 15. Então, MEM[15] = 100
    2.Agora, vamos dar LOAD desse endereço 15 da memória no registrador 5 do banco de registradores. ( ld x5,15(x0) )
    3a.Após isso, vamos dar STORE do valor que se encontra no endereço 5 do banco de registrador e colocaremos esse valor no endereço
20 da memória.
    3b.Ao fim, espera-se que o valor 100 se encontre na posição 20 da memória, ou seja, MEM[20] = 100.
*/

    $monitor("Ra = %d | OFFSET = %d | Rb = %d | Rw = %d | OP_MEM = %d | ADD_SUB = %d | We_reg = %d | WE_mem = %d | doutA[%d] = %d | doutB= %d | doutMem[%d] = %d",
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
    doutB_tb,
    OFFSET_tb,
    doutMem_tb);

//0. INICIALIZAÇÃO DE TODOS OS PARAMETROS EM 0

OFFSET_tb = 0;
Ra_tb = 0;
Rb_tb = 0; // Rb_tb = 0 durante toda a descrição, uma vez que o OFFSET irá controlar em qual posicao da memoria será o acesso
Rw_tb = 0;
WE_mem_tb = 0;
WE_reg_tb = 0;
ADD_SUB_tb = 0;
OP_MEM_tb = 1; //operações de memoria
clk_tb = 0;

//1. INICIALIZANDO VALOR NA MEMORIA (linha 25 -> arquivo 'Memoria.v')

//2. LOAD nos Banco de registradores ld x5,15(x0)

#50
//Rb_tb = 0;
OFFSET_tb = 0;
Rw_tb = 1;
WE_reg_tb = 1;

#50
OFFSET_tb = 1;
Rw_tb = 2;

#50
WE_reg_tb = 0;
Rw_tb = 0;

//3. STORE na Memória ( sw x5,20(x0) )

#50//add 

Ra_tb = 2;
Rb_tb = 1;
Rw_tb = 3;
OP_MEM_tb = 0;
ADD_SUB_tb = 0; //soma


#50 //sub
Ra_tb = 3;
Rb_tb = 1;
Rw_tb = 4;

#50
OP_MEM_tb = 1;


#50 //store 1  
Ra_tb = 3;
OFFSET_tb = 2;
WE_mem_tb = 1;

#50 //store 2
Ra_tb = 4;
OFFSET_tb = 3;

#50 
WE_mem_tb = 0;

end

always #10 clk_tb = ~clk_tb;
    
endmodule
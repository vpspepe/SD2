`timescale  10ns/100ps

module FD_loadstore_tb();

reg[4:0] Ra_tb;   //guarda endereço que será alterado tanto na mem quanto no banco_de_registradore
reg[4:0] Rb_tb;   //guarda endereço que será usado SÓ PARA LER valores (por enquanto 0)
reg[4:0] Rw_tb;  
reg WE_reg_tb, WE_mem_tb;       
wire [63:0] doutA_tb; //valor de leitura do Registrador Ra
wire [63:0] doutB_tb; //valor de leitura do Rb
wire [63:0] doutMem_tb;
//o endereço que entra na memoria (final_address) é doutA+doutB (5 menos significativos)
reg clk_tb;
reg [4:0] OFFSET_tb;


FD_loadstore uut(
    .Ra(Ra_tb),   //guarda endereço que será alterado tanto na mem quanto no banco_de_registradore
    .Rb(Rb_tb),   //guarda endereço que será usado SÓ PARA LER valores
    .Rw(Rw_tb),  
    .WE_reg(WE_reg_tb), 
    .WE_mem(WE_mem_tb),       
    .doutA(doutA_tb), //valor de leitura do Registrador Ra
    .doutB(doutB_tb), //valor de leitura do Rb
    .doutMem(doutMem_tb),
    //o endereço que entra na memoria (final_address) é doutA+doutB (5 menos significativos)
    .clk(clk_tb),
    .OFFSET(OFFSET_tb)
);


initial begin

/*IMPLEMENTACAO DESTA TEST_BENCH

    1.INICIA-SE ATRIBUINDO O VALOR 100 EM UM ENDEREÇO QUALQUER DA MEMÓRIA,  digamos no endereço 15. Então, MEM[14] = 100
    2.Agora, vamos dar LOAD desse endereço 15 da memória no registrador 5 do banco de registradores. ( ld x5,15(x0) )
    3a.Após isso, vamos dar STORE do valor que se encontra no endereço 5 do banco de registrador e colocaremos esse valor no endereço
20 da memória.
    3b.Ao fim, espera-se que o valor 100 se encontre na posição 20 da memória, ou seja, MEM[19] = 100.
*/

    $monitor("Ra = %d || OFFSET = %d || Rb = %d || Rw = %d || We_reg = %d || WE_mem = %d || doutA = %d || doutB= %d ||doutMem",
    Ra_tb,
    OFFSET_tb,
    Rb_tb,
    Rw_tb,
    WE_reg_tb,
    WE_mem_tb,
    doutA_tb,
    doutB_tb,
    doutMem_tb);

//0. INICIALIZAÇÃO DE TODOS OS PARAMETROS EM 0

OFFSET_tb = 0;
Ra_tb = 0;
Rb_tb = 0; // Rb_tb = 0 durante toda a descrição, uma vez que o OFFSET irá controlar em qual posicao da memoria será o acesso
Rw_tb = 0;
WE_mem_tb = 0;
WE_reg_tb = 0;
clk_tb = 0;

//1. INICIALIZANDO VALOR NA MEMORIA (linha 59 -> arquivo 'Memoria.v')

//2. LOAD nos Banco de registradores ld x5,15(x0)

#50
//Rb_tb = 0;
OFFSET_tb = 15;
Rw_tb = 5;
WE_reg_tb = 1;

#50
WE_reg_tb = 0;
Rw_tb = 0;

//3. STORE na Memória sw x5,20(x0)

#50
Ra_tb = 5;
OFFSET_tb = 20;

#50
WE_mem_tb = 1;

#50 
WE_mem_tb = 0;

end

always #10 clk_tb = ~clk_tb;
    
endmodule
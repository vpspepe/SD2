module FD_loadstore(
    input[4:0] Ra,   //guarda endereço que será alterado tanto na mem quanto no banco_de_registradore
    input[4:0] Rb,   //guarda endereço que será usado SÓ PARA LER valores
    input[4:0] Rw,  
    input WE_reg, WE_mem,       
    input[63:0]dIN, //dOUT da memoria eh o dIN dos regs
    output [63:0] doutA, //valor de leitura do Registrador Ra
    output [63:0] doutB, //valor de leitura do Rb
    //o endereço que entra na memoria (final_address) é doutA+doutB (5 menos significativos)
    input clk,
    input [4:0] OFFSET
);

wire [5:0] final_address;
wire[63:0] regIN_memOUT, doutA, doutB;

assign  final_address = doutA[4:0] + OFFSET;  //5 bits menos significativos do doutA

Reg_Banco u1(
            .Ra(Ra),
            .Rb(Rb),
            .Rw(RW),
            .WE(WE),
            .dIN(regIN_memOUT),
            .doutA(doutA),
            .doutB(doutB),
            .clk(clk)
);

Memoria u2( 
     .final_address(final_address),         //guarda endereço que será alterado tanto 
     .WE_mem(WE_mem),
     .dIN(doutB),
     .dout(regIN_memOUT), //valor de leitura do Registrador Ra
     .clk(clk)
);



endmodule

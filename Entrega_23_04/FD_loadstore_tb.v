`timescale  10ns/100ps

module FD_loadstore_tb();

reg[4:0] Ra_tb;   //guarda endereço que será alterado tanto na mem quanto no banco_de_registradore
reg[4:0] Rb_tb;   //guarda endereço que será usado SÓ PARA LER valores
reg[4:0] Rw_tb;  
reg WE_reg_tb, WE_mem_tb;       
reg[63:0]dIN_tb; //dOUT da memoria eh o dIN dos regs
wire [63:0] doutA_tb; //valor de leitura do Registrador Ra
wire [63:0] doutB_tb; //valor de leitura do Rb
//o endereço que entra na memoria (final_address) é doutA+doutB (5 menos significativos)
reg clk_tb;
reg [4:0] OFFSET_tb;

FD_loadstore uut(
    .Ra(Ra_tb),   //guarda endereço que será alterado tanto na mem quanto no banco_de_registradore
    .Rb(Rb_tb),   //guarda endereço que será usado SÓ PARA LER valores
    .Rw(Rw_tb),  
    .WE_reg(WE_reg_tb), 
    .WE_mem(WE_mem_tb),       
    .dIN(dIN_tb), //dOUT da memoria eh o dIN dos regs
    .doutA(doutA_tb), //valor de leitura do Registrador Ra
    .doutB(doutB_tb), //valor de leitura do Rb
    //o endereço que entra na memoria (final_address) é doutA+doutB (5 menos significativos)
    .clk(clk_tb),
    .OFFSET(OFFSET_tb)
);


initial begin
    $monitor("Ra = %d || Rb = %d || Rw = %d || We_reg = %d || WE_mem = %d || dIN = %d || doutA = %d || doutB= %d ||",
    Ra_tb,
    Rb_tb,
    Rw_tb,
    WE_reg_tb,
    WE_mem_tb,
    dIN_tb,
    doutA_tb,
    doutB_tb);
OFFSET_tb = 0;
Ra_tb = 0;
Rb_tb = 0;
Rw_tb = 1;
WE_mem_tb = 0;
dIN_tb = 12;
WE_reg_tb = 0;
clk_tb = 0;

#30
WE_reg_tb = 1;
#30
WE_reg_tb = 1;
Ra_tb = 0;
#30
WE_mem_tb = 0;
#30
WE_mem_tb = 0;
WE_reg_tb = 1;
#30
WE_reg_tb = 0;

end

always #10 clk_tb = ~clk_tb;
    
endmodule
`timescale 100ns/10ps

module Reg_Banco_tb ();

reg[4:0] Ra_tb;   //guarda endereço que será alterado tanto na mem quanto no banco_de_registradore
reg[4:0] Rb_tb;   //guarda endereço que será usado SÓ PARA LER valores
reg[4:0] Rw_tb;  //endereço do reg que vair receber o load
reg WE_Reg_tb;  //write enable     
reg[63:0]dIN_tb;  //data in
wire [63:0] doutA_tb; //valor de leitura do Registrador R
wire [63:0] doutB_tb; //valor de leitura do Rb
reg clk_tb;

Reg_Banco uut(
    .Ra(Ra_tb),   //guarda endereço que será alterado tanto na mem quanto no banco_de_registradore
    .Rb(Rb_tb),   //guarda endereço que será usado SÓ PARA LER valores
    .Rw(Rw_tb),  //endereço do reg que vair receber o load
    .WE_Reg(WE_Reg_tb),  //write enable     
    .dIN(dIN_tb),  //data in
    .doutA(doutA_tb), //valor de leitura do Registrador R
    .doutB(doutB_tb), //valor de leitura do Rb
    .clk(clk_tb)
);

initial begin
    $monitor(" Ra: %d || Rb: %d || Rw: %d || WE: %d || dIn: %d || doutA: %d || doutB: %d", Ra_tb, Rb_tb, Rw_tb, WE_Reg_tb, dIN_tb, doutA_tb, doutB_tb);
Ra_tb = 0;
Rb_tb = 0;
Rw_tb = 1;
dIN_tb = 5;
clk_tb = 0;
WE_Reg_tb = 0;

#50
WE_Reg_tb = 1;

#50
WE_Reg_tb = 0;
Ra_tb = 1;
Rb_tb = 1;
Rw_tb = 7;
dIN_tb = 12;
#50
WE_Reg_tb = 1;
Ra_tb = 7;
Rb_tb = 0;
#50
WE_Reg_tb = 0;

end

always #10
clk_tb = ~clk_tb;

endmodule
// Grupo 06
// Integrantes
// Marcelo Takayama Russo - 13680164
// Victor Pedreira Santos de Pepe - 
// Thainara de Assis Goulart - 13874413
// Implementação do circuito do Grupo 21
// Nota Projeto do grupo:  7/10

`timescale 10ns/10ps

module tarefa_bonus_tb;

reg CLK_tb, RESET_tb;
reg [7:0] M1_tb, M2_tb;
wire [15:0] RES_tb;
wire ready_tb;




tarefa_bonus uut 
    (
    .M1(M1_tb),.M2(M2_tb),
    .CLK(CLK_tb),
    .RESET(RESET_tb),
    .RESULT(RES_tb),
    .ready(ready_tb)
);


initial begin

    $monitor("M1 = %d || M2 = %d || RES = %d || RESET = %d || CLK = %d ready = %d",M1_tb,M2_tb,RES_tb,RESET_tb,CLK_tb,ready_tb);
    RESET_tb = 1;
    CLK_tb = 0;
    M1_tb = 8'd8; //multiplicador
    M2_tb = 8'd5; //multiplicando
    #10 
    RESET_tb = 0;
    #5000 RESET_tb = 1;
    M1_tb = 8'd9; //multiplicador
    M2_tb = 8'd4; //multiplicando
    #10 
    RESET_tb = 0;
    #5000 RESET_tb = 1;
    M1_tb = 8'd24; //multiplicador
    M2_tb = 8'd8; //multiplicando
    #10 
    RESET_tb = 0;


    

end
always begin
    #50 CLK_tb = ~CLK_tb;
end
endmodule
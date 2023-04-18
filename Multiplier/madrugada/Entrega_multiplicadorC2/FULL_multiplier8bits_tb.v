`timescale 1ns/10ps

module FULL_multiplier8bits_tb;
reg CLK_tb, start_tb, RESET_tb;                             //Variáveis comuns para qualquer circuito com registradores.

wire LD_XY_tb, LD_DE0_tb, LD_A_tb,                          //  LOADs que gerenciam os tempos em que cada operação ou armazenamento será feito
LD_B_tb,LD_DE1_tb, LD_AB_tb,                                //  Os valores dos LOADs são configurados por uma máquina de estado, dentro da UC.
LD_DE_ABshift_tb, LD_RES_tb;
wire[1:0] SELROM_tb,SELSOMA_tb;            

wire DONE_tb;                                               // Variável de Controle da UC para indicar quando a multiplicação foi concluída.

reg [7:0] x_tb, y_tb;                                       // Multiplicador e Multiplicando.
wire [15:0] result_tb;                                      // Guarda Resultado da final da multiplicação.

UC_multiplier8bits UC(                                      // Link das varíaveis criadas com o circuito da UC
    .clk(CLK_tb), .start(start_tb), .RESET(RESET_tb),
    .LD_XY(LD_XY_tb), .LD_DE0(LD_DE0_tb),.LD_A(LD_A_tb),
    .LD_B(LD_B_tb),.LD_DE1(LD_DE1_tb), .LD_AB(LD_AB_tb), 
    .LD_DE_ABshift(LD_DE_ABshift_tb), .LD_RES(LD_RES_tb),
    .SELROM(SELROM_tb), .SELSOMA(SELSOMA_tb),
    .DONE(DONE_tb)
);

FD_multiplier8bitsc2 FD(                                      // Link das varíaveis criadas com o circuito do FD.
    .x(x_tb), .y(y_tb),
    .LD_XY(LD_XY_tb), .LD_DE0(LD_DE0_tb), .LD_A(LD_A_tb), 
    .LD_B(LD_B_tb), .LD_DE1(LD_DE1_tb),.LD_AB(LD_AB_tb), 
    .LD_DE_ABshift(LD_DE_ABshift_tb), .LD_RES(LD_RES_tb),   
    .SELROM(SELROM_tb), .SELSOMA(SELSOMA_tb),
    .CLK(CLK_tb), .RESET(RESET_tb), 
    .result(result_tb)
);

initial begin
// Para critérios de teste, o valor do resultado vai recebendo diversos valores ao longo da operação. Isso permite ver a formação do produto final e testar operações intermediárias.
$monitor("X = %b || Y = %b || resultado = %b || PRONTO = %d || start = %d ", x_tb, y_tb, result_tb,DONE_tb,start_tb);
        CLK_tb = 1;
        RESET_tb = 0;
        start_tb = 1;
        #10
        RESET_tb = 1;
        #10 
        RESET_tb = 0;

        #10
        x_tb = -3; 
        y_tb = -2; 
end 

always #10 CLK_tb = ~CLK_tb;

endmodule
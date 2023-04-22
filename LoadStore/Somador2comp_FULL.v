`timescale 10ns/100ps

module Somador2comp_FULL();

parameter N = 5;

reg clk_tb, S_tb, RESET_tb;
wire loadAB_tb, // load nos registradores A, B e os sinais de A e de B
    loadmagAB_tb,  //faz o laod dos valores de A e de B convertidos de complemento de 2
    compmag_tb, //compara as magnitudes de A e de B
    compsigns_tb, //Compara os sinais de A e de B
    add_sub_tb, //reliza a soma ou a subtrada
    loadres_tb, //faz o load do resultado
    done_tb; //indica que esta pronto

Somador2comp_UC UC( .clk(clk_tb), .S(S_tb), .RESET(RESET_tb), .loadAB(loadAB_tb), .loadmagAB(loadmagAB_tb), .compmag(compmag_tb), .compsigns(compsigns_tb), .add_sub(add_sub_tb),  .loadres(loadres_tb), .done(done_tb));

reg [N-1:0] a_tb, b_tb;
wire [N:0] result_tb;

Somador2comp_FD FD(.a(a_tb), .b(b_tb), .clk(clk_tb), .RESET(RESET_tb), 
    .loadAB(loadAB_tb), .loadmagAB(loadmagAB_tb), .comp_mag(compmag_tb),
    .comp_sinais(compsigns_tb), .soma_sub(add_sub_tb),  .loadRES(loadres_tb),
    .result(result_tb));


initial begin
    $monitor("a = %b  || b = %b  || loadAB  = %d || loadmagAB = %d || compmag = %d || comp_sinais = %d || soma_sub = %d || loadres = %d || result = %b ", a_tb,b_tb, loadAB_tb, loadmagAB_tb, compmag_tb, compsigns_tb, add_sub_tb, loadres_tb, result_tb);

    S_tb = 1;
    RESET_tb = 1;
    clk_tb = 0;
    #20
    RESET_tb = 0;
    #10
    a_tb = 3;
    b_tb = -8;
end

always begin
    #10 clk_tb = ~clk_tb;
end



endmodule
`timescale 10ns/1ps

module RegNbits_tb();
parameter N = 64;
reg[N-1:0] x_tb;
reg clk_tb;
reg load_tb;
wire[N-1:0] x_out_tb;

RegNbits uut( .x(x_tb),
    .clk(clk_tb),
    .load(load_tb),
    .x_out(x_out_tb));

initial begin
    $monitor("X_in: %d || load: %d || x_out: %d", x_tb, load_tb, x_out_tb);
    x_tb = 27;
    load_tb = 0;
    clk_tb = 0;

    #10
    load_tb = 1; //Informação armazenada no registrador

    #10
    load_tb = 0; //tira o load para que novos valores de x não entrem no registrador

    #10
    x_tb = 0;   //testa se o valor dado continua dentro do registrador


end
always #10  clk_tb = ~clk_tb;

endmodule
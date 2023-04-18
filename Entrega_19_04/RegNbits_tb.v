`timescale 100ns/10ps

module RegNbits_tb();
parameter N = 64;
reg[N-1:0] x_tb;
reg clk_tb, load_tb;
reg[N-1:0] x_out_tb;

RegNbits uut( .x(x_tb),
    .clk(clk_tb),
    .load(load_tb),
    .x_out(x_out_tb));

initial begin
    $monitor("X_in: %d || load: %d || x_out: %d", x_tb, load_tb, x_out_tb);
    x_tb = 27;
    load_tb = 0;
    clk_tb = 0;

    #15
    load_tb = 1;

end
always #10  clk_tb = ~clk_tb;

endmodule
module atrasa_clk_3x1_tb();
reg clk_tb;
wire clk_out_tb;

atrasa_clk_3x1 uut(
    .clk(clk_tb),
    .clk_out(clk_out_tb)
);


initial begin
    $dumpfile("_testbenches/vvp/atrasaclk.vcd");
    $dumpvars(0, atrasa_clk_3x1_tb);

    clk_tb = 0;
    #100
    $finish;
end
always #5
clk_tb = ~clk_tb;







endmodule
`timescale  10ns/100ps

module Processador_tb();

reg clk_tb;
reg rst_n_tb;

rv_e_mem rv(.rst_n(rst_n_tb),.clk(clk_tb));


initial begin
$dumpfile("_testbenches/vvp/RV.vcd");
$dumpvars(0, Processador_tb);

rst_n_tb = 0;
clk_tb = 0;
#10 
rst_n_tb = 1;

#10 
rst_n_tb = 0;

#300
rst_n_tb =1;
#10
rst_n_tb=0;
#800
$finish;

end

always #10 
    clk_tb = ~clk_tb;

endmodule
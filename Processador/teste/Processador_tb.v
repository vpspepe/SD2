`timescale  10ns/100ps

module Processador_tb();

reg clk_tb;
reg reset_tb;

Processador Proce(.reset(reset_tb),.clk(clk_tb));


initial begin
$dumpfile("_testbenches/vvp/waveforms5.vcd");
$dumpvars(0, Processador_tb);

reset_tb = 0;
clk_tb = 0;
#10 
reset_tb = 1;

#10 
reset_tb = 0;
 
#500
$finish;

end

always #10 
    clk_tb = ~clk_tb;

endmodule
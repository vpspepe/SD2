`timescale 10ns/100ps

module multshift8bits_tb;
  
  reg CLK_tb, RESET_tb;
  reg[7:0] M1_tb, M2_tb;
  wire ready_tb;
  wire[15:0] RESULT_tb;

  multshift8bits UUT (
    .M1(M1_tb),
    .M2(M2_tb),
    .CLK(CLK_tb),
    .RESET(RESET_tb),
    .RESULT(RESULT_tb),
    .ready(ready_tb)
  );

  initial begin
    $monitor("ready = %d, RESULT = %d, clk = %d", ready_tb, RESULT_tb, CLK_tb);
    
    CLK_tb = 0;
    RESET_tb = 0;
    #1000 RESET_tb = 1;
    #1500 RESET_tb = 0;

    #1000 M1_tb = 8'd5;
    #10000 M2_tb = 8'd4;
    #1000

    $finish;

  end

  always begin 
    #10 CLK_tb = ~CLK_tb;
    $monitor("ready = %d, RESULT = %d, clk = %d", ready_tb, RESULT_tb, CLK_tb); 
  end


endmodule
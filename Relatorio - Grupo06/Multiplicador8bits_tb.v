`timescale 10ns/100ps

module Multiplicador8bits_tb;

reg CLK_tb, RESET_tb, lAR_tb, lBR_tb, lPR_tb;
reg [7:0] M1_tb, M2_tb;
wire [15:0] RES_tb;



Multiplicador8bits uut 
    (
    .load_AR(lAR_tb),.load_BR(lBR_tb),.load_PR(lPR_tb),
    .mult1(M1_tb),.mult2(M2_tb),
    .CLK(CLK_tb),
    .RESET(RESET_tb),
    .result(RES_tb)
);


initial begin

    $monitor("M1 = %d || M2 = %d || RES = %d",M1_tb,M2_tb,RES_tb);
    CLK_tb = 1;
    lAR_tb = 1;
    lBR_tb = 1;
    lPR_tb = 1;
    RESET_tb = 1;
    
    #10 
    RESET_tb = 0;

    #10 
    M1_tb = 8'd19;
    M2_tb = 8'd32;

   

end
always #10 CLK_tb = ~CLK_tb;
endmodule
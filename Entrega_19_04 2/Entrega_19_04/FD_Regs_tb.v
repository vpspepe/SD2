`timescale 1ns/10ps

module FD_Regs_tb();
reg [63:0] din_tb;  //valor que vai ser armazenado
reg clk_tb;
reg [63:0] OFFSET_tb;
reg [4:0] x1_tb; // base da memoria
reg [4:0] x2_tb; //offset da memoria
reg WE_tb; // write enable
wire [63:0] dout_tb;



FD_Regs uut(
 .din(din_tb),  //valor que vai ser armazenado
    .clk(clk_tb),
    .OFFSET(OFFSET_tb),//offset da memoria
    .Ra(x1_tb),  // base da memoria
    .Rb(Rb_tb), //endereço
    .dout(dout_tb), //valor armazenado no registrador final
    .WE(WE_tb)
      // write enable
);

initial begin
    $monitor("din = %d | addr = %d  | WE = %d||   lw/sw %d, %d(%d)   || valor armazenado em  %d = %d ",
     din_tb,     Rb_tb,       WE_tb,    Rb_tb,OFFSET_tb,Rb_tb, Ra_tb,dout_tb);
    clk_tb = 0;
    Ra_tb = 5;
    OFFSET_tb = 0;
    Rb_tb = 6;
    din_tb = 1234;
    WE_tb = 0;
    

    #10
    WE_tb = 1;
    din_tb = 0;


    #10
    WE_tb = 0;


end

always @(posedge clk_tb ) begin
    clk_tb = ~clk_tb;
end

endmodule
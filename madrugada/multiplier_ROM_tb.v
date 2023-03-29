`timescale 10ns/100ps  
module multiplier_ROM_tb;

reg[9:0] a_tb;
wire [9:0] res_tb;

multiplier_ROM uut(.a(a_tb),.z(res_tb));


initial begin
    $monitor("A = %d || RES = %d",a_tb,res_tb);
    a_tb = 10'b0000111111;
end
endmodule
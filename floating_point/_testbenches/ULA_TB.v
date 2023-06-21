module ULA_TB();

reg reset_tb;
reg clk_tb;
reg[28:0] a_tb;
reg[28:0] b_tb;
reg sign_a_tb, sign_b_tb;
reg start_tb;
reg op_tb;
wire[28:0] c_tb;
wire done_tb;
wire sign_c_tb; 

ULA UUT(
    .reset(reset_tb),
    .clk(clk_tb),
    .a(a_tb),
    .b(b_tb),
    .sign_a(sign_a_tb), 
    .sign_b(sign_b_tb),
    .start(start_tb),
    .op(op_tb),
    .c(c_tb),
    .done(done_tb),
    .sign_c(sign_c_tb) 
);


initial begin

$dumpfile("_testbenches/vvp/ULA_FLOAT.vcd");
$dumpvars(0, ULA_TB);
    clk_tb = 0;
    start_tb = 1;
    a_tb = {3'b000, 3'b111, 20'b0, 3'b0};
    b_tb = {3'b001, 4'b0, 19'b0, 3'b0};
    sign_a_tb = 0;
    sign_b_tb = 0;
    op_tb = 0;
    reset_tb = 0;

    #5
    reset_tb = 1;

    #5
    reset_tb = 0;
    #20
    start_tb = 0;
    
    #750
    $finish;
end

always #5
clk_tb = ~clk_tb;

endmodule
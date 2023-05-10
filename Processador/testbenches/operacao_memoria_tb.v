`timescale 10ns/100ps
module operacao_memoria_tb();
    reg [63:0] dinA_tb;
    reg [63:0] dinB_tb;
    reg [63:0] OFFSET_tb;
    reg OP_MEM_tb;
    reg clk_tb;
    reg ADD_SUB_tb;
    wire [63:0] dout_tb;

operacao_memoria uut(
    .dinA(dinA_tb),
    .dinB(dinB_tb),
    .OFFSET(OFFSET_tb),
    .OP_MEM(OP_MEM_tb),
    .clk(clk_tb),
    .ADD_SUB(ADD_SUB_tb),
    .dout(dout_tb)
);

initial begin
    $monitor("dinA = %d | dinB = %d | OFFSET = %d | OP_MEM = %d | ADD_SUB = %d  ->  dout = %d",dinA_tb,dinB_tb,OFFSET_tb,OP_MEM_tb,ADD_SUB_tb, dout_tb);

    dinA_tb = 0;
    dinB_tb = 0;
    OFFSET_tb = 0;
    OP_MEM_tb = 0;
    clk_tb = 0;
    ADD_SUB_tb = 0; //soma

    #40

    dinA_tb = 20;
    dinB_tb = 10;
    OP_MEM_tb = 0; 

    #40
    ADD_SUB_tb = 1; //sub

    #40
    //OFFSET
    ADD_SUB_tb = 0;
    OP_MEM_tb = 1;
    dinB_tb = 0;
    OFFSET_tb = 5;




end
always @(posedge clk_tb) begin
    clk_tb = ~clk_tb;
end

endmodule
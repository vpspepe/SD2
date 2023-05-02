`timescale 100ns/10ps
module MUX_TB();

reg[63:0] a_tb, b_tb;
reg select_tb;
wire[63:0] result_tb;

MUX UUT(.a(a_tb), 
        .b(b_tb), 
        .select(select_tb), 
        .result(result_tb));

initial begin
    
    $monitor("a = %d ||  b= %d  || result = %d || select = %d", a_tb, b_tb, result_tb, select_tb);

    a_tb = 15;
    b_tb = 12;
    select_tb = 0;

    #30
    select_tb = 1;
end

endmodule
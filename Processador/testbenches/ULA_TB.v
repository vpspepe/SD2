module ULA_TB();

reg[63:0] a_tb , b_tb;
reg soma_sub_tb;
wire[63:0] result_tb;

ULA UUT(
    .a(a_tb), 
    .b(b_tb), 
    .soma_sub(soma_sub_tb), 
    .result(result_tb)
);

initial begin
    

    $monitor("a = %d ||  b= %d  || soma_sub = %d || result = %b", a_tb, b_tb, soma_sub_tb, result_tb);

    a_tb = 3;
    b_tb = 2;
    soma_sub_tb = 0;

    #30
    soma_sub_tb = 1;
end

endmodule
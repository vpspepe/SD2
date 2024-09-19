module atrasa_clk_3x1(
    input clk,
    output clk_out
);

reg[1:0] counter;
reg out;
assign clk_out = (counter == 0) ? 1 : 0;

initial begin
    counter <= 2;
end

always @(posedge clk ) begin
    if(counter == 2'b10)
        counter <= 2'b0;
    else
        counter <= counter + 1;
        
end




endmodule
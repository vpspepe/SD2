module atrasa_clk_3x1(
    input clk,
    output clk_out
);

reg[1:0] counter;
reg out;
assign clk_out = out;

always @(posedge clk ) begin
    if(counter == 2'b00) out <= 1;
    else out <= 0;
    if (counter == 2) counter <= 0;

    counter <= counter + 1;
    
end

endmodule
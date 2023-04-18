module RegNbits(
    input[N-1:0] x,
    input clk,
    input load,
    output[N-1:0] x_out
);
reg x_data[N-1:0];
parameter N = 64;
assign x_out <= x_data;
always @(posedge clk) begin

    if (load == 1) begin
        x_data <= x;
    end

end

endmodule
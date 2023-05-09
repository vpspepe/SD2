module Reg32(x,
                clk, load, 
                x_out,reset
);

parameter N = 32; //tamanho do registrador parametrizável

input[N-1:0] x;   //entrada
input clk, load,reset;  
output reg[N-1:0] x_out; //saída


always @(posedge clk) begin
    if (reset) begin
        x_out <= 0;
    end
    else begin
        if (load) begin
            x_out <= x;
        end
    end
end

endmodule
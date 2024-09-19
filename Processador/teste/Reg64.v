module Reg64(x,
                clk, load, 
                x_out
);

parameter N = 64; //tamanho do registrador parametrizável

input[N-1:0] x;   //entrada
input clk, load,reset;  
output reg[N-1:0] x_out; //saída


always @(posedge clk) begin
        if (load) begin
            x_out <= x;
        end
end


endmodule
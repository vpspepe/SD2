module Reg32(x,
                clk, load, 
                x_out,reset
);

parameter N = 32; //tamanho do registrador parametrizável

input[N-1:0] x;   //entrada
input clk, load,reset;  
output reg[N-1:0] x_out; //saída

always @(posedge reset) begin
    x_out <= 0;
end

always @(posedge clk) begin
        if (load == 1 & reset == 0) begin
            x_out <= x;
        end
end

endmodule
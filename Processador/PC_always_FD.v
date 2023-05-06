module PC_always_FD (
input inc, //INCREMENTO
input load, 
input reset,
input [32-1:0] in, //VALOR DE ENTRADA
output reg [32-1:0] out //SAIDA
);

parameter N = 32;

reg [N-1:0] valor;

assign out = valor;
always @(*) begin
if (reset)
valor <= N'd0;      
else if (load)
valor <= in;         // Carrega com o valor em "in"
else if (inc)
valor <= valor + 1;    // aumenta o valor em 1
end

endmodule
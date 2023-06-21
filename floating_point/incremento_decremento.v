module incremento_decremento(
    input [1:0] normalize_selector,
    input [7:0] exp_in,
    output [7:0] exp_out
);

assign exp_out = (normalize_selector == 1) ? (exp_in + 1) : ((normalize_selector == 2) ? (exp_in - 1) : (exp_in)); 

//se normalize_selector == 0, quer dizer q o numero é maior que 10 e precisa corrigir o expoente, somando.   ex: 800 x 10E0 -> 8,00 x 10E2
//se normalize_selector == 1, quer dizer q o numero é menor que 1 e precisa corrigir o expoente, subtraindo. ex: 0,08 x 10E0 -> 8,00 x 10E-2


endmodule
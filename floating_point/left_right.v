module left_right(
    input [28:0]A,
    input shift_selector,
    output [28:0]A_shifted
);

assign A_shifted = (shift_selector == 1) ? (A >> 1) : (A); 
//se shift_selector == 0, quer dizer q o numero é maior que 10 e precisa shiftar pra direita ex: 800 -> 8,00 x 10E2
//se shift_selector == 1, quer dizer q o numero é menor que 1 e precisa shiftar pra esquerda ex: 0,08 -> 8,00 x 10E-2

endmodule
module small_ULA(
    input sum_mult_selector,
    input [7:0] a,
    input [7:0] b,
    output [7:0] exp_difference
);

assign exp_difference = (sum_mult_selector == 0) ? (a-b) : (a+b); // sum_mult_selector = 0 -> soma || sum_mult_selector = 1 -> multiplicacao

endmodule
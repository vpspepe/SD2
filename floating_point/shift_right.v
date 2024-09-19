module shift_right(
    input [28:0] A,
    input [7:0] shift_num,
    output [28:0] A_shifted,
    input sum_mult_selector
);

assign A_shifted = (sum_mult_selector == 0) ? A >> shift_num : A;


endmodule
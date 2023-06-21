module float_addition (
    input op, 
    input [31:0] A,
    input [31:0] B,
    input clk,
    input reset
);

wire [1:0] normalize_selector;
wire[7:0] exp_difference;
wire [28:0] big_ULA_out;
wire[28:0] fract_UC;
wire done_ULA;
wire ULA_START;
wire continue_selector;
wire sum_mult_selector;
wire [1:0] exp_fract_selector;
wire[7:0] shift_A;
wire normalized;
wire [31:0] result;

UC UC(
    .clk(clk), 
    .reset(reset),
    .exp_difference(exp_difference),        
    .big_ULA_out(big_ULA_out),          
    .fract_UC(fract_UC), 
    .done_ULA(done_ULA),
    .op(op),                           
    .ULA_START(ULA_START),                   
    .continue_selector(continue_selector),           
    .sum_mult_selector(sum_mult_selector),           
    .normalize_selector(normalize_selector),          
    .exp_fract_selector(exp_fract_selector),         
    .shift_A(shift_A),               
    .normalized(normalized)                   
);

FD FD(
    .clk(clk),
    .reset(reset),        
    .sum_mult_selector(sum_mult_selector), 
    .exp_fract_selector(exp_fract_selector), 
    .normalize_selector(normalize_selector),  
    .ULA_START(ULA_START),         
    .shift_A(shift_A),     
    .A(A),          
    .B(B),  
    .normalized(normalized),       
    .continue_selector(continue_selector),           
    .exp_difference(exp_difference), 
    .ula_out(big_ULA_out),  
    .result(result),
    .done_ULA(done_ULA),
    .fract_UC(fract_UC)
);

//.\float_addition_tb.v .\float_addition.v .\FD.v .\UC.v .\MUX2_23bits.v .\MUX2_29bits.v .\MUX2_8bits.v .\ULA.v .\arredonda.v .\incremento_decremento.v .\left_right.v .\shift_right.v .\small_ULA.v

endmodule

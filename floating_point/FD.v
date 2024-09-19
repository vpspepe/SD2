module FD(
input clk, reset,        
input sum_mult_selector,  //seleciona se vai ser uma operacao de soma ou de multiplicacao entre A e B
input exp_fract_selector, //baseado no valor de (a-b) seleciona quais vao ser as entradas da ULA e qual é o menor expoente     //baseado no valor de ULA_OUT, a UC decide se haverá shift de 1 pra direita ou pra esquerda.
input [1:0]normalize_selector,  //baseado no resultado da ULA, sabe se será necessário shiftar praa direita ou esquerda e se vai incrementar ou decrementar
input ULA_START,         
input [7:0] shift_A,      //baseado no resultado de A-B, indica quantos shifts serão feitos para A entrar na ULA.
input [31:0] A,          
input [31:0] B,  
input normalized,       //encerra a normalização assim que o fract estiver no formato correto. Exemplo: 0.001 (normalized = 0) -> 1.000 (normalized = 1)
input continue_selector,            //será 0 para selecionar a passagem do exp e do fract, mas será 1 após isso, para ficar fazendo looping até a normalização ocorrer.
output [7:0] exp_difference, //valor da diferença entre os expoentes de A e B, que vão para ULA para saber se A ou se B é maior
output [28:0] ula_out,  //resultado da ULA que é usado para saber se é necessário shifitar o resultado para corrígi-lo
output [31:0] result,
output done_ULA,
output [28:0] fract_UC
);

// separar as entradas de A e B entre os sinais, expoentes e fracao
wire sA,sB;
wire [7:0] expA, expB;
wire [22:0] fractA, fractB;

assign sA = A[31];
assign expA = A[30:23] - 127;
assign fractA = A[22:0];

assign sB = B[31];
assign expB = B[30:23] - 127;
assign fractB = B[22:0];


wire [7:0] small_ula_out;

small_ULA exp_ULA(
     .sum_mult_selector(sum_mult_selector),
     .a(expA),
     .b(expB),
     .exp_difference(small_ula_out)
);

assign exp_difference = small_ula_out;


wire [22:0] lower_fract;
wire [22:0] higher_fract;


MUX2_23bits MUX_ULAIN_LOWER( //seleciona quem precisa shiftar pra entrar na ULA
     .a(fractA),
     .b(fractB),       
     .select(~exp_fract_selector),
     .result(lower_fract)
);

MUX2_23bits MUX_ULAIN_HIGHER( //seleciona quem nao precisa shiftar pra entrar na ULA
     .a(fractA),
     .b(fractB),       
     .select(exp_fract_selector),
     .result(higher_fract)
);


wire [28:0] lower_ULAIN;  //entrada menor da ULA
wire [28:0] higher_ULAIN;
wire[7:0] shift_A_modulo;
assign shift_A_modulo = shift_A[7] ? (~shift_A) + 1 : shift_A;
shift_right shift_right(
    .A({3'b001,lower_fract,3'b000}),
    .shift_num(shift_A_modulo),
    .A_shifted(lower_ULAIN),
    .sum_mult_selector(sum_mult_selector)
);

assign higher_ULAIN = {3'b001,higher_fract,3'b000};


wire [28:0] ULA_fract_OUT;
wire sign_c;

ULA fract_ULA(
    .reset(reset),
    .clk(clk),
    .a(lower_ULAIN),
    .b(higher_ULAIN),
    .fractA(fractA),
    .fractB(fractB),
    .sign_a(sA), 
    .sign_b(sB),
    .start(ULA_START),
    .op(sum_mult_selector),
    .c(ULA_fract_OUT),
    .done(done_ULA),
    .sign_c(sign_c) 
);

assign ula_out = ULA_fract_OUT;

wire [7:0] exp_higher;
MUX2_8bits MUX_EXP_HIGHER(  //seleciona o exp maior para ser corrigido
     .a(expA),
     .b(expB),       
     .select(~exp_fract_selector),
     .result(exp_higher)
);

wire [7:0] exp;
wire [7:0] exp_in_mux_increment_decrement;
assign exp_in_mux_increment_decrement = sum_mult_selector ? small_ula_out : exp_higher;
MUX2_8bits MUX_INCREMENT_DECREMENT( //seleciona se o exp ou a saída do arredonda entra no incremento_decremento
     .a(exp_in_mux_increment_decrement), // result do MUX_EXP_LOWER
     .b(exp_result), // exp que vem do arredonda     
     .select(continue_selector),
     .result(exp)
);

wire [7:0] exp_adjusted;
incremento_decremento incremento_decremento(
    .normalize_selector(normalize_selector),
    .exp_in(exp),
    .exp_out(exp_adjusted)
);

wire [28:0] left_right_in;
wire [28:0] fract_result;
wire [7:0]  exp_result;

MUX2_29bits MUX_LEFT_RIGHT( //seleciona se o fract que saiu da ULA ou a saída do arredonda entra no LEFT_RIGHT
     .a(ULA_fract_OUT),
     .b(fract_result),       
     .select(continue_selector),
     .result(left_right_in)
);


wire [28:0] fract_shifted;
left_right left_right(
    .A(left_right_in),
    .normalize_selector(normalize_selector),
    .A_shifted(fract_shifted)
);

arredonda arredonda(
  .clk(clk),
  .normalized(normalized),
  .exp_in(exp_adjusted),
  .exp_out(exp_result),
  .fract_in(fract_shifted),
  .fract_out(fract_result)
);

assign result[31] = sign_c;
assign result[22:0] = fract_result[25:3];
assign result[30:23] = exp_result + 127;
assign fract_UC = fract_result;

endmodule
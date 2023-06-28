module fpu(
    input clk,
    input reset,
    input start,
    input [1:0] op,
    input [31:0] A, B,
    output [31:0] R,
    output done
);
       
wire [1:0] normalize_selector;
wire[7:0] exp_difference;
wire [28:0] big_ULA_out;
wire[28:0] fract_UC;
wire done_ULA;
wire ULA_START;
wire continue_selector;
wire sum_mult_selector;
wire exp_fract_selector;
wire[7:0] shift_A;
wire normalized;
wire [31:0] result;
wire inicializa;


UC UC(
    .clk(clk), 
    .reset(reset),
    .start(start),
    .exp_difference(exp_difference),        
    .big_ULA_out(big_ULA_out),          
    .fract_UC(fract_UC), 
    .done_ULA(done_ULA),
    .op(op),      
    .inicializa(inicializa),                     
    .ULA_START(ULA_START),                   
    .continue_selector(continue_selector),           
    .sum_mult_selector(sum_mult_selector),           
    .normalize_selector(normalize_selector),          
    .exp_fract_selector(exp_fract_selector),         
    .shift_A(shift_A),               
    .normalized(normalized), 
    .done(done)                  
);

FD FD(
    .clk(clk),
    .reset(reset),        
    .op(sum_mult_selector), 
    .exp_fract_selector(exp_fract_selector), 
    .normalize_selector(normalize_selector),  
    .ULA_START(ULA_START),         
    .shift_A(shift_A),     
    .A_in(A),          
    .B_in(B), 
    .inicializa(inicializa),
    .normalized(normalized),       
    .continue_selector(continue_selector),           
    .exp_difference(exp_difference), 
    .ula_out(big_ULA_out),  
    .result(R),
    .done_ULA(done_ULA),
    .fract_UC(fract_UC)
);

//.\float_addition_tb.v .\float_addition.v .\FD.v .\UC.v .\MUX2_23bits.v .\MUX2_29bits.v .\MUX2_8bits.v .\ULA.v .\arredonda.v .\incremento_decremento.v .\left_right.v .\shift_right.v .\small_ULA.v

endmodule





module FD(
    input clk, reset,        
    input op,  //seleciona se vai ser uma operacao de soma ou de multiplicacao entre A e B
    input exp_fract_selector, //baseado no valor de (a-b) seleciona quais vao ser as entradas da ULA e qual é o menor expoente     //baseado no valor de ULA_OUT, a UC decide se haverá shift de 1 pra direita ou pra esquerda.
    input [1:0]normalize_selector,  //baseado no resultado da ULA, sabe se será necessário shiftar praa direita ou esquerda e se vai incrementar ou decrementar
    input ULA_START,         
    input [7:0] shift_A,      //baseado no resultado de A-B, indica quantos shifts serão feitos para A entrar na ULA.
    input [31:0] A_in,          
    input [31:0] B_in,  
    input inicializa,
    input normalized,       //encerra a normalização assim que o fract estiver no formato correto. Exemplo: 0.001 (normalized = 0) -> 1.000 (normalized = 1)
    input continue_selector,            //será 0 para selecionar a passagem do exp e do fract, mas será 1 após isso, para ficar fazendo looping até a normalização ocorrer.
    output [7:0] exp_difference, //valor da diferença entre os expoentes de A e B, que vão para ULA para saber se A ou se B é maior
    output [28:0] ula_out,  //resultado da ULA que é usado para saber se é necessário shifitar o resultado para corrígi-lo
    output [31:0] result,
    output done_ULA,
    output [28:0] fract_UC
    );

    wire [31:0] A,B;
    wire sum_mult_selector;

    Reg32 regA(.x(A_in),
                .clk(clk), .load(inicializa), 
                .x_out(A), .reset(reset)
    );

    Reg32 regB(.x(B_in),
                .clk(clk), .load(inicializa), 
                .x_out(B), .reset(reset)
    );

    Reg1 regOP(.x(op),
                .clk(clk), .load(inicializa), 
                .x_out(sum_mult_selector), .reset(reset)
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

module UC (
    input clk, 
    input reset,
    input start,
    input [7:0] exp_difference,         //valor da diferença entre os expoentes de A e B, que vão para ULA para saber se A ou se B é maior
    input [28:0] big_ULA_out,           //resultado da ULA que é usado para saber se é necessário shifitar o resultado para corrígi-lo
    input [28:0] fract_UC, 
    input done_ULA,
    input [1:0] op,                         //vem da testbench (00 -> soma e 10 -> mult)
    output reg inicializa,                        //load para A,B e OP   
    output reg ULA_START,                   //indica quando a ULA deve inicar as contas
    output reg continue_selector,           //será 0 para selecionar a passagem do exp e do fract, mas será 1 após isso, para ficar fazendo looping até a normalização ocorrer.
    output reg sum_mult_selector,           //seleciona se vai ser uma operacao de soma ou de multiplicacao entre A e B
    output reg [1:0]normalize_selector,          //baseado no resultado da ULA, sabe se será necessário shiftar praa direita ou esquerda e se vai incrementar ou decrementar
    output reg exp_fract_selector,          //baseado no valor de (a-b) seleciona quais vao ser as entradas da ULA e qual vai ser shiftado é o menor expoente
    output reg [7:0] shift_A,               //baseado no resultado de A-B, indica quantos shifts serão feitos para A entrar na ULA.
    output reg normalized,                   //encerra a normalização assim que o fract estiver no formato correto. Exemplo: 0.001 (normalized = 0) -> 1.000 (normalized = 1)   
    output reg done
    );

    reg [3:0] state;

    parameter init = 0,
            smallULA = 1, // SOMA OU SUBTRAI 
            selectULAIN = 2, 
            shiftaULAIN = 3,
            bigULA = 4, //SOMA OU MULT e salvar o resultado
            selectRepeatedMux = 5, // na primiera é 0 e depois sempre 1
            normalizing = 6, 
            arredonda = 7, // finish or not?
            DONE = 8,
            normalizado = 9,
            IDLE = 10;

    always @(posedge clk or reset) begin
        if (reset == 1)
            state <= IDLE;

        else begin
            case(state)

                IDLE: begin
                    if (start == 1)
                        state <= init;
                    else
                        state <= IDLE;

                end
                init: begin   
                        state <= smallULA;
                end
                smallULA: begin
                    state <= selectULAIN;
                end
                selectULAIN: begin
                    state <= shiftaULAIN;
                end
                shiftaULAIN: begin
                    state <= bigULA;
                end
                bigULA: begin
                    if(done_ULA == 1) 
                        state <= selectRepeatedMux;
                    else
                        state <= bigULA;
                end
                selectRepeatedMux: begin
                    state <= normalizing;
                end
                normalizing: begin
                    state <= arredonda;
                end
                arredonda: begin
                    if(fract_UC[28:26] == 3'b001 | fract_UC == 0) 
                        state <= DONE;
                    else begin
                        state <= selectRepeatedMux;
                    end
                end
                normalizado: begin
                    state <= done;
                end
                done: begin
                    if (start == 0) 
                        state <= IDLE;
                    else
                        state <= done;
                
                
                end
            endcase
        end
    end

    always@(posedge clk) begin

        case(state)

        IDLE: begin
            if (reset == 1) begin
                inicializa <= 1'b0;
                ULA_START <= 1'b0;
                continue_selector <= 1'b0;
                sum_mult_selector <= op[1];           
                normalize_selector <= 1'b0;          
                exp_fract_selector <= 1'b0;                      
                normalized <= 1'b0;   
                done <= 1'b0;
            end
        end
        init: begin
            inicializa <= 1'b1;
            ULA_START <= 1'b0;
            continue_selector <= 1'b0;
            sum_mult_selector <= op[1];           
            normalize_selector <= 1'b0;          
            exp_fract_selector <= 1'b0;                      
            normalized <= 1'b0;   
            done <= 1'b0;           
        end
        smallULA: begin
            sum_mult_selector <= op[1];
            inicializa <= 1'b0;     
        end
        selectULAIN: begin
            if(exp_difference[7] == 1) begin // b > a
                exp_fract_selector <= 1; // a será shiftado
            end
            else if (exp_difference != 0) begin // a > b
                exp_fract_selector <= 0;
            end
            /*else begin
                exp_fract_selector <= 2;
            end
            */
        end
        shiftaULAIN: begin
            if(op == 2'b10) // multiplicaçao
                shift_A <= 0;
            else
                shift_A <= $unsigned(exp_difference);
        end
        bigULA: begin
            sum_mult_selector <= op[1];
            ULA_START <= 1;
        end

        selectRepeatedMux: begin
            if(big_ULA_out[28:27] != 2'b00) begin
                normalize_selector <= 1;
            end
            
            else if (big_ULA_out[26] != 1'b1) begin
                normalize_selector <= 2;
            end

            else begin
                normalize_selector <= 0;
            end
        end

        normalizing: begin
            normalize_selector <= 1'b0;
            continue_selector <= 1'b1;         
        end

        arredonda: begin
            // não faz nada   
        end

        normalizado: begin
            normalized <= 1'b1;
        end

        DONE: begin
            done <= 1'b1;
        end
        endcase
    end

endmodule

module Reg32(x,
                clk, load, 
                x_out,reset
);

parameter N = 32; //tamanho do registrador parametrizável

input[N-1:0] x;   //entrada
input clk, load,reset;  
output reg[N-1:0] x_out; //saída


always @(posedge clk | reset) begin
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

module Reg1(x,
                clk, load, 
                x_out,reset
);

parameter N = 1; //tamanho do registrador parametrizável

input[N-1:0] x;   //entrada
input clk, load,reset;  
output reg[N-1:0] x_out; //saída


always @(negedge clk | reset) begin
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

module MUX2_8bits(
                input[7:0] a, 
                input[7:0] b,       //0 1
                input  select,
                output[7:0] result);   // output 

    assign result = select == 1 ? b[7:0] : a[7:0];

endmodule

module MUX2_23bits(
                input[22:0] a, 
                input[22:0] b,       //0 1
                input select,
                output[22:0] result
    );

    assign result = (select == 1) ? b : a;

endmodule

module MUX2_29bits(
            input[28:0] a, 
            input[28:0] b,       //0 1
            input select,
            output[28:0] result
    );


    assign result = (select == 1) ? b[28:0] : a[28:0];

endmodule

module shift_right(
        input [28:0] A,
        input [7:0] shift_num,
        output [28:0] A_shifted,
        input sum_mult_selector
    );

    assign A_shifted = (sum_mult_selector == 0) ? A >> shift_num : A;
    
endmodule

module small_ULA(
        input sum_mult_selector,
        input [7:0] a,
        input [7:0] b,
        output [7:0] exp_difference
    );

    assign exp_difference = (sum_mult_selector == 0) ? (a-b) : (a+b); // sum_mult_selector = 0 -> soma || sum_mult_selector = 1 -> multiplicacao

endmodule

module arredonda(
    input clk,
    input normalized,
    input [7:0] exp_in,
    output reg [7:0] exp_out,
    input [28:0] fract_in,
    output reg [28:0] fract_out
    );

    wire [2:0] seguranca;
    assign seguranca = fract_in[2:0];


    always @(posedge clk) begin
        
        exp_out <= exp_in;

        if (normalized == 0) begin
            
            fract_out <= fract_in;
        end

        else begin
            if (seguranca > 5) begin
            fract_out[2:0] <= 3'b000;
            fract_out[28:3] <= fract_in[28:3] + 1;
            end

            else  if (seguranca < 5) begin
            fract_out[2:0] <= 3'b000;
            fract_out[28:3] <= fract_in[28:3];
            end

            else begin
                if(fract_in[3] == 1'b0) begin
                    fract_out[2:0] <= 3'b000;
                    fract_out[28:3] <= fract_in[28:3];
                end
                else begin
                    fract_out[2:0] <= 3'b000;
                    fract_out[28:3] <= fract_in[28:3] + 1; 
                end
            end
        end

    end

endmodule

module ULA(
        input reset,
        input clk,
        input[28:0] a,
        input[28:0] b,
        input [22:0] fractA, fractB,
        input sign_a, sign_b,
        input start,
        input op,
        output  [28:0] c,
        output reg done,
        output  reg sign_c 
    );

    parameter IDLE = 0, START = 1, SOMA = 2, MULT = 3, DONE = 4, TRATAR_MULT = 6;
    wire [23:0]  multiplicador;
    reg[23:0] multiplicador_efetivo;
    wire [47:0] multiplicando; 
    reg [4:0] counter;
    reg [47:0] mult_result;
    reg [28:0] soma_result;
    reg [2:0] states;

    assign multiplicando = (a > b) ? {24'b0, a[26:3]} : {24'b0, b[26:3]};
    assign multiplicador = (a < b) ? {a[26:3]} : {b[26:3]};
    assign c = !op ? soma_result : {1'b0,mult_result[47:21],1'b0};

    always @* begin
        if(reset)
            states <= IDLE;
    end

    always @(posedge clk ) begin
        case (states)
            IDLE: begin
                if(start == 1)
                    states <= START;
                else
                    states <= IDLE;
            end

            START: begin
                if(op == 0)
                    states <= SOMA;
                else
                    states <= MULT;
            end

            SOMA: 
                states <= DONE;
            

            MULT: begin
                if(counter == 24)
                    states <= DONE;
                else
                    states <= MULT;
            end

            DONE:
                states <= DONE;

        endcase
    end


    always @(posedge clk) begin
        if(reset)
            states <= IDLE;

        case(states)
            IDLE:
                done <= 0;

            START: begin
                counter <= 0;
                mult_result <= 0;
            end

            SOMA: begin
                if(sign_a == sign_b) begin //sign_a and sign_b == 1 ou sign_a and sign_b == 0 
                    soma_result <= a + b;
                    sign_c <= sign_a;
                end
                

                
                else begin
                    if (sign_a == 1) begin //sign_a == 1 e sign_b == 0
                        if(fractA > fractB) begin  //fractA > fractB -> resultado negativo
                            soma_result <= b - a;
                            sign_c <= sign_a;
                        end
                        else begin                 //fractA < fractB -> resultado positivo
                            soma_result <= b - a;
                            sign_c <= sign_b;    
                        end
                    end
                    else begin      //sign_a == 0 e sign_b == 1,
                        if(fractA > fractB) begin  //fractA > fractB -> resultado positivo
                            soma_result <= b - a;
                            sign_c <= sign_a;
                        end
                        else begin                 //fractA < fractB -> resultado negativo
                            soma_result <= b - a;
                            sign_c <= sign_b;    
                        end
                    end
                end
            end

            MULT: begin
                sign_c <= sign_a ^ sign_b;
                if (multiplicador[counter] == 1) begin
                    mult_result <= mult_result + (multiplicando << counter);
                end
                counter <= counter + 1;
            end

            DONE:
                done <= 1;

        endcase
        
    end

endmodule

module incremento_decremento(
        input [1:0] normalize_selector,
        input [7:0] exp_in,
        output [7:0] exp_out
    );

    assign exp_out = (normalize_selector == 1) ? (exp_in + 1) : ((normalize_selector == 2) ? (exp_in - 1) : (exp_in)); 

    //se normalize_selector == 0, quer dizer q o numero é maior que 10 e precisa corrigir o expoente, somando.   ex: 800 x 10E0 -> 8,00 x 10E2
    //se normalize_selector == 1, quer dizer q o numero é menor que 1 e precisa corrigir o expoente, subtraindo. ex: 0,08 x 10E0 -> 8,00 x 10E-2

endmodule

module left_right(
        input [28:0]A,
        input [1:0] normalize_selector,
        output [28:0]A_shifted
    );

    //selector == 0 : faz nada
    //selector == 1 : shift direita
    //selector -- 2 : shift esquerda

    assign A_shifted = (normalize_selector == 1) ? (A >> 1) : ((normalize_selector == 2) ? (A << 1) : (A)); 
    //se shift_selector == 0, quer dizer q o numero é maior que 10 e precisa shiftar pra direita ex: 800 -> 8,00 x 10E2
    //se shift_selector == 1, quer dizer q o numero é menor que 1 e precisa shiftar pra esquerda ex: 0,08 -> 8,00 x 10E-2

endmodule


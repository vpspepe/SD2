module UC (
    input clk, 
    input reset,
    input start,
    input [7:0] exp_difference,         //valor da diferença entre os expoentes de A e B, que vão para ULA para saber se A ou se B é maior
    input [28:0] big_ULA_out,           //resultado da ULA que é usado para saber se é necessário shifitar o resultado para corrígi-lo
    input [28:0] fract_UC, 
    input done_ULA,
    input [1:0] op,                           //vem da testbench (00 -> soma e 10 -> mult)
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
          done = 8;

always @(posedge clk or posedge reset) begin
    if (reset == 1)
        state <= init;

    else begin
        case(state)
            init: begin    
                if(start == 1'b1)     
                    state <= smallULA;
                else 
                    state <= init;  
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
                    state <= done;
                else begin
                    state <= selectRepeatedMux;
                end
            end
            done: begin
                state <= done;
            end
        endcase
    end
end

always@(posedge clk) begin

    case(state)
    init: begin
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
        if(op == 2`b10) // multiplicaçao
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
    done: begin
        normalized <= 1'b1;
        done <= 1'b1;
    end
    endcase
end
endmodule
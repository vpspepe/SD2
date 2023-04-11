module FD_Adder2comp(
    input [N-1:0] a, b,
    input wire clk, RESET,
          loadAB, loadmagAB, comp_mag, comp_sinais, soma_sub, loadRES,
    output reg [N:0] result
);
    parameter N = 4;
    reg [1:0] operacao;
    reg sinal_a, sinal_b, sinal_soma;
    reg [N-1:0] A, B;
    reg [N-2:0] mag_soma, maior, menor, mag_a, mag_b;

    always @(posedge clk) begin

        if (loadAB) begin
                sinal_a <= a[N-1];
                sinal_b <= b[N-1];
                A <= a;
                B <= b;
        end

        else if (loadmagAB) begin
            //Para A:
                if (sinal_a == 0) begin
                    mag_a <= A;
                end
                else begin
                    mag_a <={1'b0,~A}+1'b1;
                end

            //Para B:
                if (sinal_b == 0) begin
                    mag_b <= B;
                end
                else begin
                    mag_b <= {1'b0,~B} + 1'b1;
                end
        end

        else if (comp_mag) begin
                if(mag_a > mag_b)begin
                    maior <= mag_a;
                    menor <= mag_b;
                end 
                else begin
                    maior <= mag_b;
                    menor <= mag_a;
                end
        end

        else if(comp_sinais) begin
            if ( (sinal_a == 0) & (sinal_a == sinal_b) ) begin // sinais a e b iguais a 0 
                operacao <= 0; 
                sinal_soma <= 0;
            end

            else if ( (sinal_a == 1) & (sinal_a == sinal_b) ) begin // sinais a e b iguais a 1
                operacao <= 1;
                sinal_soma <= 1;
            end
            
            else if( ((sinal_a == 0) & (mag_a > mag_b)) | ((sinal_b == 0) & (mag_b > mag_a)) ) begin //módulo do valor positivo é maior (resultado será positivo)
                operacao <= 2;
                sinal_soma <= 0;
            end
            
            else begin  //módulo do valor negativo é maior (resultado será negativo)                            
                operacao <= 3;
                if(maior == 0)
                    sinal_soma <= 0;
                else
                    sinal_soma <= 1;
            end
    end

        else if(soma_sub)   //colocar o que é feito em cada operação (caso) possível, de acordo com o estado anterior
            case(operacao)

                0: begin
                    mag_soma <= maior + menor;
                end

                1: begin
                    mag_soma <=  maior + menor;
                end

                2: begin
                    mag_soma <= maior - menor;
                end

                3: begin
                    mag_soma <= maior - menor;
                end

            endcase

        else if (loadRES) begin
            result <= {sinal_soma, mag_soma};
        end
    end

endmodule
    

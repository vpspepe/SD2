
module FD_Adder2comp(a, b, 
                    clk, RESET,
                    loadAB, loadmagAB, comp_mag, comp_sinais, soma_sub, loadRES,
                    result
); 
    parameter N = 4;

    input [N-1:0] a, b;
    input wire clk, RESET,
               loadAB, loadmagAB, comp_mag, comp_sinais, soma_sub, loadRES;
    output reg [N:0] result;

    reg [1:0] operacao;
    reg sinal_a, sinal_b, sinal_soma;
    reg [N-1:0] A, B, mag_soma;
    reg [N-2:0] maior, menor, mag_a, mag_b;


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
                    mag_a <= A[N-2:0];
                end
                else begin
                    mag_a <= (~a[N-2:0]) + 1; // -x -> x
                end

            //Para B:
                if (sinal_b == 0) begin
                    mag_b <= B[N-2:0];
                end
                else begin
                    mag_b <= (~b[N-2:0]) + 1;
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
                sinal_soma <= 1;
            end
    end

        else if(soma_sub)  
            case(operacao)

                0: begin
                    mag_soma <= maior + menor; // sinais a e b iguais a 0 
                end

                1: begin
                    mag_soma <= maior + menor; // sinais a e b iguais a 1
                end

                2: begin
                    mag_soma <= maior - menor; //módulo do valor positivo é maior (resultado será positivo)
                end

                3: begin
                    mag_soma <= menor - maior; //módulo do valor negativo é maior (resultado será negativo)
                end

            endcase

        else if (loadRES) begin
            result <= {sinal_soma,mag_soma};  // Problema: esperado xxxxx = 5bits, mas temos, x (sign_soma) + xxx (mag) = 4bits. 
                                              // Assim, o primeiro bit vira auto 0 e o resto é a concatenação -> 0xxxx
        end
    end

endmodule
    

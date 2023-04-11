module FD_Adder2comp(
    input [N-1:0] a, b;
    input wire clk, RESET,
          loadAB, loadmagAB, comp_mag, comp_sinais, soma_sub, loadRES;
    output [N:0] result;
);
    parameter N = 4;
    reg [1:0] operacao;
    reg sinal_a, sinal_b;
    reg [N-1:0] A, B;
    reg [N-2:0] mag_soma, maior, menor, mag_a, mag_b;

    always @posedge(clk) begin

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
                    mag_a <= ~A[N-1:0];
                    mag_a <= mag_a + 1; 
                end

            //Para B:
                if (sinal_b == 0) begin
                    mag_b <= B[N-2:0];
                end
                else begin
                    mag_b <= ~B[N-2:0];
                    mag_b <= mag_b + 1; 
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
            if ( (sinal_a == 0) & (sinal_a == sinal_b) ) // sinais a e b iguais a 0 
                operacao <= 1; 

            else if ( (sinal_a == 1) & (sinal_a == sinal_b) ) // sinais a e b iguais a 1
                operacao <= 2;
            
            else if( ((sinal_a == 0) & (mag_a > mag_b)) | ((sinal_b == 0) & (mag_b > mag_a)) ) //módulo do valor positivo é maior (resultado será positivo)
                operacao <= 3;
            
            else   //módulo do valor negativo é maior (resultado será negativo)                            
                operacao <= 4;
        end
    end

        else if(soma_sub)   //colocar o que é feito em cada operação (caso) possível, de acordo com o estado anterior
            if (operacao == 1) 
            ...





endmodule
    

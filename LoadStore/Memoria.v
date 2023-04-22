module Memoria( 
    input [4:0] final_address,  //guarda endereço que é a soma de doutB + OFFSET
    input WE_mem,
    input clk,
    input [63:0]dIN,            //Valor que entra na memória
    output [63:0] dout          //Valor que sai da memória
);

    /*!!*/reg [63:0] mem [31:0];

    // atribuindo valores para memoria e load/store

    assign dout = mem[final_address];       //Leitura de dados no Memória (Load) 
   


    always @(posedge clk) begin
                                    
        if (WE_mem) begin                    
            mem[final_address]  <= dIN;      //Escrita de dados na memória (Store)
        end
    end

    
initial begin    // INICIALIZACAO DE UM VALOR ALEATORIO EM UMA POSICAO ALEATORIA PARA FACILITAR NA TESTBENCH
    mem[15] = 100;
end



endmodule

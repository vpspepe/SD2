module data_memory( 
    input [5:0] d_mem_addr,  //guarda endereço que é a soma de doutA + OFFSET
    input d_mem_we,
    input clk,
    input [63:0]d_mem_data_in,            //Valor que entra na memória
    output [63:0] d_mem_data_out          //Valor que sai da memória
);

    /*!!*/reg [63:0] mem [63:0];

    // atribuindo valores para memoria e load/store

    assign d_mem_data_out = mem[d_mem_addr];       //Leitura de dados no Memória (Load) 
   


    always @(posedge clk) begin
                                    
        if (d_mem_we) begin                    
            mem[d_mem_addr]  <= d_mem_data_in;      //Escrita de dados na memória (Store)
        end

    end

    
initial begin    // INICIALIZACAO DOS VALORES NA MEMÓRIA PARA FACILITAR NA TESTBENCH

/*
    mem[0] = 0;
    mem[1] = 10;
    mem[2] = 20;
    mem[3] = 35;
    mem[4] = 40;
    mem[5] = -10;
*/

//Euclides
    mem[0] = 0;
    mem[1] = 10;
    mem[2] = 30;
    mem[5] = 64'b1000000000000000000000000000000000000000000000000000000000000000;


end



endmodule

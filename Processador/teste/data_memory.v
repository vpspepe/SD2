module data_memory( 
    input [63:0] address,  //guarda endereço que é a soma de doutB + OFFSET
    input WE_mem,
    input clk,
    input [63:0]dIN,            //Valor que entra na memória
    output [63:0] dout          //Valor que sai da memória
);

    /*!!*/reg [63:0] mem [31:0];

    // atribuindo valores para memoria e load/store

    assign dout = mem[address];       //Leitura de dados no Memória (Load) 
   


    always @(posedge clk) begin
                                    
        if (WE_mem) begin                    
            mem[address]  <= dIN;      //Escrita de dados na memória (Store)
        end

    end

    
initial begin    // INICIALIZACAO DOS VALORES NA MEMÓRIA PARA FACILITAR NA TESTBENCH
    mem[0] = 0;
    mem[1] = 10;
    mem[2] = 20;
    mem[3] = 30;
    mem[4] = 40;
    mem[5] = -10;
end



endmodule

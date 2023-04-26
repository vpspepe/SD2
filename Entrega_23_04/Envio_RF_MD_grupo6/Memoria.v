module Memoria( 
    input [4:0] final_address,  //guarda endereço que será alterado tanto 
    input WE_mem,
    input clk,
    input[63:0]dIN,
    output reg[63:0] dout //valor de leitura do Registrador Ra
);

//gera a memória

    /*!!*/reg [63:0] mem[31:0];
    /*!!*/wire [63:0] mem_wire[31:0];

    reg [4:0] loads;

        
    RegNbits Reg(
        .x(64'b0), 
        .clk(clk), 
        .load(loads[0]), 
        .x_out(mem_wire[0])
        ); //x0 sempre tem valor 0

    genvar i;
    generate

        for (i = 1; i < 32 ; i = i+1 ) begin

            RegNbits Regs(
                        .x(dIN),
                        .clk(clk), 
                        .load(loads[i]), 
                        .x_out(mem_wire[i])
                        );
        end
endgenerate

// atribuindo valores para memoria e load/store
integer j,k;

    always @* begin
        for (k = 0; k < 32; k = k + 1) begin
            mem[k] <= mem_wire[k];
        end
    end
initial begin //inicializa todos os registradores da memoria com 0
        for (j = 1; j< 32; j = j + 1) 
            mem[j] <= 0;
end

    always @(posedge clk) begin
        dout <= mem_wire[final_address]; //Leitura de dados no Memória (Load)

        if (WE_mem) begin                //Escrita de dados na memória (Store)
            loads[final_address] <= 1;
        end
    end

initial begin    // INICIALIZACAO DE UM VALOR ALEATORIO EM UMA POSICAO ALEATORIA PARA FACILITAR NA TESTBENCH
    mem[15] = 100;
end



endmodule

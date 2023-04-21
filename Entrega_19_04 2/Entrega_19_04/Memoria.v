module Memoria( 
    input[4:0] final_address,  //guarda endereço que será alterado tanto 
    input WE_mem,
    input[63:0]dIN,
    output [63:0] dout, //valor de leitura do Registrador Ra
    input clk
);

//gera a memória

/*!!*/wire [63:0] mem[31:0];

RegNbits Reg(
    .x(64'b0), 
    .clk(clk), 
    .load(loads[0]), 
    .x_out(mem[0])
    ); //x0 sempre tem valor 0

genvar i;
generate

    for (i = 1; i < 32 ; i = i+1 ) begin

        RegNbits Regs(
                    .x(Din),
                    .clk(clk), 
                    .load(loads[i]), 
                    .x_out(mem[i])
                    );
    end
endgenerate

initial begin //inicializa todos os registradores do banco com 0
        for (j = 1; j< 32; j = j + 1) 
            mem[j] <= 0;
    end

//Leitura de dados no Memória (Load)

    always @posedge(final_address) begin  //se endereço final receber algum valor, Dout é a leitura desse endereço na memória
        dout <= mem[final_address];
    end

//Escrita de dados na memória (Store)

    always @posedge(clk) begin
        if (WE_mem) begin
            loads[final_address] <= 1;
        end
    end

endmodule

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

reg[4:0] loads;
wire[4:0] loads_wire;

      
RegNbits Reg(
    .x(64'b0), 
    .clk(clk), 
    .load(loads_wire[0]), 
    .x_out(mem_wire[0])
    ); //x0 sempre tem valor 0

genvar i;
generate

    for (i = 1; i < 32 ; i = i+1 ) begin

        RegNbits Regs(
                     .x(dIN),
                     .clk(clk), 
                     .load(loads_wire[i]), 
                     .x_out(mem_wire[i])
                     );
    end
endgenerate

integer j,k;

always @* begin
    for (k = 0; k < 32; k = k + 1) begin
        mem[k] <= mem_wire[k];
    end
end

always @* begin
    for (k = 0; k < 32; k = k + 1) begin
        loads[k] <= loads_wire[k];
    end
end

initial begin //inicializa todos os registradores do banco com 0
        for (j = 1; j< 32; j = j + 1) 
            mem[j] <= 0;
end

//Leitura de dados no Memória (Load)

    always @(posedge final_address) begin  //se endereço final receber algum valor, Dout é a leitura desse endereço na memória
        dout <= mem[final_address];
    end

//Escrita de dados na memória (Store)

    always @(posedge clk) begin
        if (WE_mem) begin
            loads[final_address] <= 1;
        end
    end



endmodule

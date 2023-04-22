module Reg_Banco(
    input[4:0] Ra,   //guarda endereço que será alterado tanto na mem quanto no banco_de_registradore
    input[4:0] Rb,   //guarda endereço que será usado SÓ PARA LER valores
    input[4:0] Rw,  
    input WE_Reg,       
    input[63:0]dIN, 
    output reg [63:0] doutA, //valor de leitura do Registrador R
    output reg [63:0] doutB, //valor de leitura do Rb
    input clk
);

//gera os 32 registadores

/*!!*/reg [63:0] banco_registradores[31:0];
/*!!*/wire [63:0] banco_registradores_wire[31:0];
reg[4:0] loads;
wire[4:0] loads_wire;
genvar i;
generate 

for (i = 0; i < 32 ; i = i+1 ) begin

    RegNbits Regs(
                .x(dIN),
                .clk(clk), 
                .load(loads_wire[i]), 
                .x_out(banco_registradores_wire[i])
                );
end
endgenerate

integer j,k;

always @* begin
    for (k = 0; k < 32; k = k + 1) begin
        banco_registradores[k] <= banco_registradores_wire[k];
    end
end

always @* begin
    for (k = 0; k < 32; k = k + 1) begin
        loads[k] <= loads_wire[k];
    end
end

initial begin //inicializa todos os registradores do banco com 0
        for (j = 0; j< 32; j = j + 1) 
            banco_registradores[j] <= 0;
            loads[j] <= 0;
    end

//Leitura de dados no banco de registradores (Store)

    always @(Ra,Rb) begin  //se Ra ou Rb recebem algum valor, Dout's são as leituras do banco de registradores
        doutA <= banco_registradores[Ra];
        doutB <= banco_registradores[Rb];
    end

//Escrita de dados no banco de registradores (load)
    always @(posedge clk) begin
        if (WE_Reg) begin
            loads[Rw] <= 1;
        end
    end

endmodule

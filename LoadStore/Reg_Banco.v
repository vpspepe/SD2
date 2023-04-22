module Reg_Banco(
    input[4:0] Ra,   //guarda endereço que só mexe no Banco de Registradores 
    input[4:0] Rb,   //guarda endereço que só mexe na Memória
    input[4:0] Rw,   //endereço do reg que vair receber o load
    input WE_Reg,    //write enable     
    input[63:0]dIN,  //data que vem da memória
    output reg [63:0] doutA, //valor de leitura do endereço Ra do Banco de Regs
    output reg [63:0] doutB, //valor padronizado por 0
    input clk
);

//gera os 32 registadores

    reg [63:0] banco_registradores[31:0]; 
    wire [63:0] banco_registradores_wire[31:0];

    reg [31:0] loads;

 RegNbits Regs( //registrador x0 sempre tem o valor 0
                .x(64'b0),
                .clk(clk), 
                .load(1'b1), 
                .x_out(banco_registradores_wire[0]) //saida precisava ser fio, e nao reg
                );

    genvar i;
    generate 

for (i = 1; i < 32 ; i = i+1 ) begin

    RegNbits Regs(
                .x(dIN),  //todos os fios recebem dIN, o que vai diferenciar em qual reg vai salvar dIN é o LOAD
                .clk(clk), 
                .load(loads[i]), 
                .x_out(banco_registradores_wire[i]) //saida precisava ser fio, e nao reg
                );
end
endgenerate
integer j,k;

initial begin //inicializa todos os registradores do banco com 0
        for (j = 0; j< 32; j = j + 1) 
            banco_registradores[j] <= 0;
end


always @* begin                             //faz com que os registradores sempre sejam definidos como os fios que saem dos modulos regNbits
    for (k=0; k<32; k = k+1)
    banco_registradores[k] <= banco_registradores_wire[k];
end




//Load e store

    always @(posedge clk) begin
        doutA <= banco_registradores_wire[Ra];
        doutB <= banco_registradores_wire[Rb];

        if (WE_Reg) begin  
            loads[Rw] <= 1;
        end
    end

endmodule

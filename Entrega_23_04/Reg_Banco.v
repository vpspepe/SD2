module Reg_Banco(
    input[4:0] Ra,   //guarda endereço que será alterado tanto na mem quanto no banco_de_registradore
    input[4:0] Rb,   //guarda endereço que será usado SÓ PARA LER valores
    input[4:0] Rw,  //endereço do reg que vair receber o load
    input WE_Reg,  //write enable     
    input[63:0]dIN,  //data in
    output reg [63:0] doutA, //valor de leitura do Registrador R
    output reg [63:0] doutB, //valor de leitura do Rb
    input clk
);

//gera os 32 registadores

/*!!*/reg [63:0] banco_registradores[31:0]; //ACHO QUE NAO PRECISA DESSES REGS
/*!!*/wire [63:0] banco_registradores_wire[31:0];

reg[31:0] loads;

 RegNbits Regs( //registrador x0 sempre tem o valor 0
                .x(64'b0),
                .clk(clk), 
                .load(loads[0]), 
                .x_out(banco_registradores_wire[0]) //saida precisava ser fio, e nao reg
                );

genvar i;
generate 

for (i = 1; i < 32 ; i = i+1 ) begin

    RegNbits Regs(
                .x(dIN),
                .clk(clk), 
                .load(loads[i]), 
                .x_out(banco_registradores_wire[i]) //saida precisava ser fio, e nao reg
                );
end
endgenerate

// acho que esse trecho nao faz sentido, ja que a saida do modulo de regNbits é um fio
initial begin //inicializa todos os registradores do banco com 0
        for (j = 0; j< 32; j = j + 1) 
            banco_registradores[j] <= 0;
end

integer j,k;

//ACHO QUE ESSE BLOCO ABAIXO EH DESNCECESSÁRIO
always @* begin //faz com que os registradores sempre sejam definidos como os fios que saem dos modulos regNbits
    for (k=0; k<32; k= k+1)
    banco_registradores[k] <= banco_registradores_wire[k];
end




//Load e store
    always @(posedge clk) begin
        doutA <= banco_registradores_wire[Ra];
        doutB <= banco_registradores_wire[Rb];
        if (WE_Reg) begin
            loads[Rw] <= 1;
        end
        else
            loads[Rw] <=0;
    end

endmodule

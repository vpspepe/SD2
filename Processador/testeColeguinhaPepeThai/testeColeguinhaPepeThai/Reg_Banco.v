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

    wire [31:0] loads;

 Reg64 Regs( //registrador x0 sempre tem o valor 0
                .x(64'b0),
                .clk(clk), 
                .load(1'b1), 
                .x_out(banco_registradores_wire[0]) //saida precisava ser fio, e nao reg
                );

genvar i;
generate 

for (i = 1; i < 32 ; i = i+1 ) begin

    Reg64 Regs(
                .x(dIN),  //todos os fios recebem dIN, o que vai diferenciar em qual reg vai salvar dIN é o LOAD
                .clk(clk), 
                .load(loads[i]), 
                .x_out(banco_registradores_wire[i]) //saida precisava ser fio, e nao reg
                );
end

endgenerate

integer j,k;
genvar l;

initial begin //inicializa todos os registradores do banco com 0
        for (j = 0; j< 32; j = j + 1) 
            banco_registradores[j] <= 0;
end


always @(posedge clk) begin                             //faz com que os registradores sempre sejam definidos como os fios que saem dos modulos regNbits
    for (k=0; k<32; k = k+1) begin
        banco_registradores[k] <= banco_registradores_wire[k];
        // if(WE_Reg == 1) begin
           
        //     if(k == Rw)
        //         loads[Rw] <= 1;
        //     else 
        //         loads <= 0;
        // end

        // else
        //     loads[k] <= 0;
        end
    end

    assign loads[1] = WE_Reg ? (1 == Rw ? 1 : 0) : 0;
    assign loads[2] = WE_Reg ? (2 == Rw ? 1 : 0) : 0;
    assign loads[3] = WE_Reg ? (3 == Rw ? 1 : 0) : 0;
    assign loads[4] = WE_Reg ? (4 == Rw ? 1 : 0) : 0;
    assign loads[5] = WE_Reg ? (5 == Rw ? 1 : 0) : 0;
    assign loads[6] = WE_Reg ? (6 == Rw ? 1 : 0) : 0;
    assign loads[7] = WE_Reg ? (7 == Rw ? 1 : 0) : 0;
    assign loads[8] = WE_Reg ? (8 == Rw ? 1 : 0) : 0;
    assign loads[9] = WE_Reg ? (9 == Rw ? 1 : 0) : 0;
    assign loads[10] = WE_Reg ? (10 == Rw ? 1 : 0) : 0;
    assign loads[11] = WE_Reg ? (11 == Rw ? 1 : 0) : 0;
    assign loads[12] = WE_Reg ? (12== Rw ? 1 : 0) : 0;
    assign loads[13] = WE_Reg ? (13 == Rw ? 1 : 0) : 0;
    assign loads[14] = WE_Reg ? (14 == Rw ? 1 : 0) : 0;
    assign loads[15] = WE_Reg ? (15 == Rw ? 1 : 0) : 0;
    assign loads[16] = WE_Reg ? (16 == Rw ? 1 : 0) : 0;
    assign loads[17] = WE_Reg ? (17 == Rw ? 1 : 0) : 0;
    assign loads[18] = WE_Reg ? (18 == Rw ? 1 : 0) : 0;
    assign loads[19] = WE_Reg ? (19 == Rw ? 1 : 0) : 0;
    assign loads[20] = WE_Reg ? (20 == Rw ? 1 : 0) : 0;
    assign loads[21] = WE_Reg ? (21 == Rw ? 1 : 0) : 0;
    assign loads[22] = WE_Reg ? (22 == Rw ? 1 : 0) : 0;
    assign loads[23] = WE_Reg ? (23 == Rw ? 1 : 0) : 0;
    assign loads[24] = WE_Reg ? (24 == Rw ? 1 : 0) : 0;
    assign loads[25] = WE_Reg ? (25 == Rw ? 1 : 0) : 0;
    assign loads[26] = WE_Reg ? (26 == Rw ? 1 : 0) : 0;
    assign loads[27] = WE_Reg ? (27 == Rw ? 1 : 0) : 0;
    assign loads[28] = WE_Reg ? (28 == Rw ? 1 : 0) : 0;
    assign loads[29] = WE_Reg ? (29 == Rw ? 1 : 0) : 0;
    assign loads[30] = WE_Reg ? (30 == Rw ? 1 : 0) : 0;
    assign loads[31] = WE_Reg ? (31 == Rw ? 1 : 0) : 0;


    
    
    // if (WE_Reg) begin  
    //     loads[Rw] <= 1;
    // end
    // else begin
    //         loads <= 0;
    // end
    //end




//Load e store

always @(*) begin
    doutA <= banco_registradores_wire[Ra];
    doutB <= banco_registradores_wire[Rb];

    //if (WE_Reg) begin  
    //    loads[Rw] <= 1;
    //end
    
end

endmodule

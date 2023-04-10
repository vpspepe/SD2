module FD_multiplier8bits(
    input[7:0] x, y,                                                            // Multiplicador e Multiplicando
    input LD_XY, LD_DE0, LD_A, LD_B, LD_DE1, LD_AB, LD_DE_ABshift, LD_RES,      // LOADs, responsáveis por organizra as condições de cada operação
    input [1:0] SELROM, SELSOMA,                                                // Mesma função dos LOADs, mas selecionando cada operação da multiplicação
    input wire  CLK, RESET,                                                     // Clock e Reset, comuns em qualquer registrador
    output [15:0] result
);  
    // Ao invés de usar duas variáveis de entrada para a ROM, optamos por usar uma, que é a concatenação das duas variáveis de entrada da ROM
    reg [9:0] rom1;                                                             // Sempre Armazena o valor que irá entrar na ROM, como uma concatenação de dois binários.
    wire [9:0] rom_result;                                                      // Armazena Resultado da ROM
    

    reg [7:0] X, Y;                                                             // REGISTRADORES que guardam valores do multiplicador e do multiplicando
    
    reg [9:0] A, B, DE;                                                         // REGISTRADORES que guardam valores de operações intermediárias do 
    reg [4:0] D,E;                                                              // cálculo da multiplicação
    reg[15:0] ABshiftsum,DE_AB;
    reg [8:0] ABsum;

    reg [15:0] result_reg;                                                      // REGISTRADOR que guarda o valor final da multiplicação

assign result = result_reg;
multiplier_ROM ROM(.a(rom1), .z(rom_result));


always @(posedge CLK) begin

    if (RESET == 1) begin
        X <= 0;
        Y <= 0;
        A <= 0;
        B <= 0;
        DE <= 0;
        ABshiftsum <= 0;
        ABsum <= 0;
        result_reg <= 0;
    end


    if(LD_XY) begin
        X <= x;
        Y <= y; 
    end


    else if(LD_DE0) begin
        D <= X[7:4] + X[3:0];
        E <= Y[7:4] + Y[3:0];
    end


    else if(SELROM == 1) begin
        rom1 <= {1'b0,X[3:0],1'b0, Y[3:0]};
        result_reg <= X;
    end


    else if(LD_A) begin
        A <= rom_result;
    end


    else if(SELROM == 2) begin
        rom1 <= {1'b0,x[7:4],1'b0, y[7:4]};
    end


    else if(LD_B) begin
        B <= rom_result;
    end


    else if(SELROM == 3) begin
        rom1 <= {D, E};
    end


    else if(LD_DE1) begin
        DE <= rom_result;
    end


    else if(SELSOMA == 1) begin
        result_reg <= DE;
    end

    else if(LD_AB == 1) begin
        ABsum <= A+B;
        ABshiftsum <= {B,A};
    end

    else if(SELSOMA == 2) begin
        result_reg <= ABsum;
        
    end
    else if(LD_DE_ABshift)
        DE_AB <= (DE - ABsum)<<4;

    else if(SELSOMA == 3) begin
        result_reg <=  DE_AB + ABshiftsum;
    end
end

endmodule
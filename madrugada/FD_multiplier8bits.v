module FD_multiplier8bits(
    input[7:0] x, y,
    input LD_XY, LD_DE0, LD_A, LD_B, LD_DE1, LD_AB, LD_DE_ABshift, LD_RES,
    input [1:0] SELROM, SELSOMA,
    input wire  CLK, RESET,
    output [15:0] result,
    output reg PRONTO
);  

    reg [9:0] rom1; 
    wire [9:0] rom_result;
    

    reg [7:0] X, Y;
    reg [9:0] A, B, DE;
    reg [4:0] D,E;

    reg[15:0] ABshiftsum,DE_AB;
    reg [8:0] ABsum;

    reg [15:0] result_reg;

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
        PRONTO <= 0;
        result_reg <= 0;
    end


    if(LD_XY) begin
        X <= x;
        Y <= y; 
    end


    else if(LD_DE0) begin
        result_reg <= X;
        D <= X[7:4] + X[3:0];
        E <= Y[7:4] + Y[3:0];
    end


    else if(SELROM == 1) begin
        rom1 <= {1'b0,X[3:0],1'b0, Y[3:0]};
        result_reg <= X;
    end


    else if(LD_A) begin
    result_reg <= rom1;
        A <= rom_result;
    end


    else if(SELROM == 2) begin
        result_reg <= A;
        rom1 <= {1'b0,x[7:4],1'b0, y[7:4]};
    end


    else if(LD_B) begin
    result_reg <= rom1;
        B <= rom_result;
    end


    else if(SELROM == 3) begin
    result_reg <= B;
        rom1 <= {D, E};
    end


    else if(LD_DE1) begin
        result_reg <= rom1;
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
        PRONTO <= 1;
    end
end

endmodule
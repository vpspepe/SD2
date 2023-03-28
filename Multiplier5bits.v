module Multiplier5bits(
    input [7:0] x,
    input [7:0] y,
    input [7:0] z,
    input start,
    input reset,
    input clk,
    output [15:0] result,
    output ready
)

reg[3:0] states;
parameter IDLE = 0, inicio = 1, somaxy = 2, multA = 3, multB = 4, multDE = 5,
        somaABshift = 6, somaAB = 7, subDE_AB = 8, somaFinal = 9, FIM = 10;
reg [7:0] A, B;
reg [9:0] = DE;

always @(posedge clk or posedge start ) begin
    if reset == 1 
        states = IDLE;
    else begin
        case (states)
            IDLE: begin
                if start == 1
                    states <= inicio
            end
            inicio: begin
                states <= somaxy;
            end 
            somaxy: begin
                states <= multA;
            end
            multA: begin
                states <= multB;
            end
            multDE: begin
                states <= somaABshift;
            end
            somaABshift: begin
                states <=somaAB;
            end
            somaAB: begin
                states <= subDE_AB;
            end
            subDE_AB: begin
                somaFinal;
            end
            somaFinal: begin
                states <= FIM
            end
             
        endcase
    end
end



    
endmodule
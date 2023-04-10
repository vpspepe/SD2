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
wire[4:0] rom1, rom2; //fios que entram na rom (multiplicando e multiplicador)
wire [9:0] rom_result; //fio que sai da ROM com o resultado da multiplicação
wire [15:0] ABshiftsum, DE_AB; //fios que recebem soma do A+Bshiftado e subtração de DE-AB
wire [8:0] ABsum; //Fio recebe soma de A+B
reg[3:0] states;
parameter IDLE = 0, inicio = 1, somaxy = 2, multA = 3, multB = 4, multDE = 5,
        somaABshift = 6, somaAB = 7, subDE_AB = 8, somaFinal = 9, FIM = 10;
reg [4:0] X, Y;
reg [4:0] D, E;
reg [7:0] A, B;
reg [9:0] = DE;
reg [15:0] = result_reg;
assign result = result_reg;
mux5to1_5bits mux1(Xl,Xh,D,Yl,Yh,select_soma1,clk,rom1);
mux5to1_5bits mux2(Yl,Yh,E,Xl,Xh,select_soma1,clk,rom2);
demux1to4_10bits demux1 (rom_result, A, B, DE, select_rom, clk);



always @(posedge clk or posedge start or posedge reset) begin
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
                states <= somaAB;
            end
            somaAB: begin
                states <= subDE_AB;
            end
            subDE_AB: begin
                states <= somaFinal;
            end
            somaFinal: begin
                states <= FIM;
            end    
        endcase
    end
end
always @(posedge clk) begin
    case (states)
        
        inicio: begin
            X <= x;
            Y <= y;
        end 
        somaxy: begin
            D <= X[7:4] + X[3:0];
            E <= Y[7:4] + Y[3:0];            
        end
        multA: begin  //FALTA AJEITAR
            states <= multB;
        end
        multDE: begin //FALTA AJEITAR
            states <= somaABshift;
        end
        somaABshift: begin
            ABshiftsum <= A + (B<<8);
        end
        somaAB: begin
            ABsum <= A + B;
        end
        subDE_AB: begin
            DE_AB <= (DE - ABsum)<<4;
        end
        somaFinal: begin
            result_reg <= ABshiftsum + DE_AB;
        end    
    endcase
end






    
endmodule
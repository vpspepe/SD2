// Grupo 06
// Integrantes
// Marcelo Takayama Russo - 13680164
// Victor Pedreira Santos de Pepe - 
// Thainara de Assis Goulart - 13874413


module multiplier8bits_ROMnovo (
    input [7:0] w,  //multiplicando
    input [7:0] y,  //multiplicador
    input wire S,   //start
    input wire loadD,
    input wire loadE,
    input wire loadrom1,
    input wire loadABshiftsum,
    input wire loadABsum,
    input wire loadDE_AB,
    input wire loadW,
    input wire loadY,
    input wire loadA,
    input wire loadB,
    input wire loadresultreg,
    input wire loadA,
    
    input wire RESET,
    input wire CLK,
    output [15:0] result, //produto
    output reg PRONTO //done
);

reg [4:0] D,E;                //D = Whigh + Wlow, E = Yhigh + Ylow
reg selectmux[2:0];
reg [9:0] rom1;               //fios que entram na rom (multiplicando e multiplicador)
wire [9:0] rom_result;        //fio que sai da ROM com o resultado da multiplicação
reg [15:0] ABshiftsum, DE_AB; //fios que recebem soma do A+Bshiftado e subtração de DE-AB
reg [8:0] ABsum;               //Fio recebe soma de A+B
reg [3:0] states;              //registrador que guardas os estados

reg [7:0] W, Y;
reg [9:0] A, B, DE;
reg [15:0] result_reg;
wire [15:0] soma1,soma2;
assign result = result_reg;

multiplier_ROM ROM(.a(rom1), .z(rom_result));
mux5to1 mux1(.A(W[7:4]),.B(W[3:0]),.C(D),.D(Y[7:4]),.E(Y[3:0],.select(selectmux),.clk(CLK),.result(rom1)));
mux5to1 mux2(.A(Y[7:4]),.B(Y[3:0]),.C(D),.D(Y[7:4]),.E(Y[3:0],.select(selectmux),.clk(CLK),.result(rom1)));
mux8to1_16bits mux3(.A(A),.B(B),.C(B<<8),.D(DE),.E(ABsum),.F(ABshiftsum),.G(DE_AB),.H(DE_AB),.select(select_mux3),.clk(clk),.result(soma1));
mux8to1_16bits mux4(.A(A),.B(B),.C(B<<8),.D(DE),.E(ABsum),.F(ABshiftsum),.G(DE_AB),.H(DE_AB),.select(select_mux3),.clk(clk),.result(soma2));

demux1to3_10bits demux1(.X(rom_result),.A(A),.B(B),.C(DE),.select(select_demux1));
demux1to4_16bits demux2(.X(soma1 + soma2),.A(ABsum),.B(ABshiftsum),.C(DE_AB),.D(result_reg),.select(select_demux2),.clk(clk));

parameter IDLE = 4'b0000, START = 4'b0001, SOMA_WY = 4'b0010, MULT_A = 4'b0011, MULT_B = 4'b0100, MULT_DE = 4'b0101, 
          SOMA_AB = 4'b0110, SOMA_DE_ABshift = 4'b0111, SOMA_FINAL = 4'b1000, DONE = 4'b1001, ATRIB_A = 4'b1010, ATRIB_B = 4'b1011,
          ATRIB_DE = 4'b1100;

always @(posedge CLK or posedge S or posedge RESET) begin
    if (RESET == 1)
        states <= IDLE;
    else begin
        case (states)
            IDLE: begin
                if (S == 1)
                    states <= START;
            end

            START: begin
                states <= SOMA_WY;
            end

            SOMA_WY: begin
                states <= MULT_A;
            end

            MULT_A: begin
                states <= ATRIB_A;
            end

            ATRIB_A: begin
                states <= MULT_B;
            end

            MULT_B: begin
                states <= ATRIB_B;
            end

            ATRIB_B: begin
                states <= MULT_DE;
            end

            MULT_DE: begin
                states <= ATRIB_DE;
            end

            ATRIB_DE: begin
                states <= SOMA_AB;
            end

            SOMA_AB: begin
                states <= SOMA_DE_ABshift;
            end

            SOMA_DE_ABshift: begin
                states <= SOMA_FINAL;
            end

            SOMA_FINAL: begin
                states <= DONE;
            end    

            DONE: begin
                states <= IDLE;
            end
            
        endcase
    end
end

always @(posedge CLK) begin
    case (states)
        
        IDLE: begin
            PRONTO <= 0;
        end

        START: begin
            result_reg <= 0;
            W <= w;
            Y <= y;
        end 

        SOMA_WY: begin
            D <= w[7:4] + w[3:0];
            E <= y[7:4] + y[3:0];
        end
    
        MULT_A: begin
            rom1 <= {1'b0,w[3:0],1'b0, y[3:0]};
        end

        ATRIB_A: begin
            A <= rom_result;
        end

        MULT_B: begin
            rom1 <= {1'b0,w[7:4],1'b0, y[7:4]};
        end

        ATRIB_B: begin
            B <= rom_result;
        end
        
        MULT_DE: begin 
            rom1 <= {D, E};
        end

        ATRIB_DE: begin
            DE <= rom_result;
        end
        
        SOMA_AB: begin
            ABsum <= A + B;
            ABshiftsum <= A + (B<<8);
        end

        SOMA_DE_ABshift: begin
            DE_AB <= (DE - ABsum)<<4;
        end

        SOMA_FINAL: begin
            result_reg <= ABshiftsum + DE_AB;
        end 

        DONE: begin
            PRONTO <= 1;
        end  
        
    endcase
end

endmodule
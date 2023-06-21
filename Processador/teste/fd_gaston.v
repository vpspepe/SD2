// Grupo:
// Gabriel Silva Vilas
// Gastón Enrique C. Buela
// Pedro Henrique Zanato

module fd_gaston
    #(  // Tamanho em bits dos barramentos
        parameter i_addr_bits = 6,
        parameter d_addr_bits = 6
    )(
        input  clk, rst_n,                   // clock borda subida, reset assíncrono ativo baixo
        output [6:0] opcode,                    
        input  d_mem_we, rf_we,              // Habilita escrita na memória de dados e no banco de registradores
        input  [3:0] alu_cmd,                // ver abaixo
        output [3:0] alu_flags,
        input  alu_src,                      // 0: rf, 1: imm
               pc_src,                       // 0: +4, 1: +imm
               rf_src,                       // 0: alu, 1:d_mem
        output [i_addr_bits-1:0] i_mem_addr,
        input  [31:0]            i_mem_data,
        output [d_addr_bits-1:0] d_mem_addr,
        inout  [63:0]            d_mem_data
    );
    // AluCmd      AluFlags
    // 0000: and   0: zero
    // 0001: or    1: MSB 
    // 0010: add   2: overflow
    // 0110: sub    

wire [4:0] Ra, Rb, Rw;
wire [63:0] din, dm_out, doutA, doutB, S, out_alu_src, out_pc_src, out_rf_src, outPC, outSegundoAdder;
wire [4:0] somaPC;
wire c;
wire overflow;

assign i_mem_addr = outPC;

RF_try regf(
  .load(rf_we),
  .clk(clk),
  .din(out_mux2),
  .Ra(Ra),
  .Rb(Rb),
  .Rw(Rw),
  .doutA(doutA),
  .doutB(doutB)
);

assign opcode = i_mem_data[6:0];


//M: B ta recebendo i_mem_data, mas temq ser d_mem_data
mux rf_mux(.A(doutB), .B(d_mem_data[31:0]), .uc(rf_src), .out(out_rf_src));

ULA ula (.somaDiferenca(d_mem_addr), .C(c), .Overflow(overflow), .Flags(flags), .A(out_rf_src), .B(doutB), .Op(uc2));


//M: coloquei reset e pc_srcs(Enable) como parametro
pc programCounter(.reset_uc(rst_n),.enable(1'b1), .in(somaPC), .clk(clk), .out(outPC));

//M: o que é isso de outPC??
Somador somadorPC(.A(outPC), .B(4), .somaDiferenca(somaPC));

Somador segundoAdder (.somaDiferenca(outSegundoAdder), .A(outPC), .B(i_mem_data[31:12]));

mux pc_mux(.A(outPC), .B(outSegundoAdder), .uc(pc_src), .out(out_pc_src));

mux write_data_mux (.A(S), .B(d_mem_data), .uc(alu_src), .out(out_alu_src));
assign d_mem_data = doutB;

endmodule

//REGISTER FILE

module Reg64(x,
                clk, load, 
                x_out
  );

  parameter N = 64; //tamanho do registrador parametrizável

  input[N-1:0] x;   //entrada
  input clk, load,reset;  
  output reg[N-1:0] x_out; //saída


  always @(posedge clk) begin
          if (load) begin
              x_out <= x;
          end
  end


endmodule


module RF_try(
      input [4:0] Ra,
      input [4:0] Rb,
      input load,
      input [63:0] din,
      input [4:0] Rw,
      input clk,
      output  reg[63:0] doutA,
      output  reg[63:0] doutB
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
          end
      end

      assign loads[1] = load ? (1 == Rw ? 1 : 0) : 0;
      assign loads[2] = load ? (2 == Rw ? 1 : 0) : 0;
      assign loads[3] = load ? (3 == Rw ? 1 : 0) : 0;
      assign loads[4] = load ? (4 == Rw ? 1 : 0) : 0;
      assign loads[5] = load ? (5 == Rw ? 1 : 0) : 0;
      assign loads[6] = load ? (6 == Rw ? 1 : 0) : 0;
      assign loads[7] = load ? (7 == Rw ? 1 : 0) : 0;
      assign loads[8] = load ? (8 == Rw ? 1 : 0) : 0;
      assign loads[9] = load ? (9 == Rw ? 1 : 0) : 0;
      assign loads[10] = load ? (10 == Rw ? 1 : 0) : 0;
      assign loads[11] = load ? (11 == Rw ? 1 : 0) : 0;
      assign loads[12] = load ? (12== Rw ? 1 : 0) : 0;
      assign loads[13] = load ? (13 == Rw ? 1 : 0) : 0;
      assign loads[14] = load ? (14 == Rw ? 1 : 0) : 0;
      assign loads[15] = load ? (15 == Rw ? 1 : 0) : 0;
      assign loads[16] = load ? (16 == Rw ? 1 : 0) : 0;
      assign loads[17] = load ? (17 == Rw ? 1 : 0) : 0;
      assign loads[18] = load ? (18 == Rw ? 1 : 0) : 0;
      assign loads[19] = load ? (19 == Rw ? 1 : 0) : 0;
      assign loads[20] = load ? (20 == Rw ? 1 : 0) : 0;
      assign loads[21] = load ? (21 == Rw ? 1 : 0) : 0;
      assign loads[22] = load ? (22 == Rw ? 1 : 0) : 0;
      assign loads[23] = load ? (23 == Rw ? 1 : 0) : 0;
      assign loads[24] = load ? (24 == Rw ? 1 : 0) : 0;
      assign loads[25] = load ? (25 == Rw ? 1 : 0) : 0;
      assign loads[26] = load ? (26 == Rw ? 1 : 0) : 0;
      assign loads[27] = load ? (27 == Rw ? 1 : 0) : 0;
      assign loads[28] = load ? (28 == Rw ? 1 : 0) : 0;
      assign loads[29] = load ? (29 == Rw ? 1 : 0) : 0;
      assign loads[30] = load ? (30 == Rw ? 1 : 0) : 0;
      assign loads[31] = load ? (31 == Rw ? 1 : 0) : 0;


  always @(*) begin
      doutA <= banco_registradores_wire[Ra];
      doutB <= banco_registradores_wire[Rb];

  end

endmodule

//MULTIPLEXADOR
module mux(input [63:0] A, input [63:0] B, input uc, output [63:0] out);

assign out = uc ? B : A ;

endmodule

/* 
Rw= input que determina o registrador que será carregado.
Ra= determina a saida do banco de registradores
Rb= determina o offset, portanto em que endereço de memoria o registrador que sera carregado pegará o valor
din= determina no load, qual sera o valor 
 */

 //UNIDADE LOGICA ARITMETICA
 module ULA(somaDiferenca, C, Overflow,Flags, A, B, Op);
   output [63:0] somaDiferenca;   
   output C;   
   output Overflow;
   output [2:0]Flags;   
   input [63:0] 	A;   
   input [63:0] 	B;   
   input Op;  
   //M: Substitui todos os fios das linhas referentes a uma soma com assign 

   assign somaDiferenca = Op ? (A-B) : (A+B); 

   assign Flags[2] = (A == B) ? 1'b1: 1'b0;

   assign Flags[1] = (A > B) ? 1'b1 : 1'b0; 
   
   assign Flags[0] = (Overflow) ? 1'b1 : 1'b0;

endmodule 


//SOMADOR COMPLETO


// PROGRAM COUNTER
module pc (input reset_uc, input enable, input [4:0] in, input clk, output reg [4:0] out);

//M: Troquei a sintaxe do pc pq n dá pra usar assign com initial begin (incompatibilidade)
always @(posedge reset_uc) begin
     out <= 0;
end

always @(posedge clk) begin
    if (enable == 1 & reset_uc == 0)
     out <= in;
end


endmodule


//REGISTRADOR PARAMETRIZAVEL USAOD NO REGISTER FILE
module registrador_parametrizavel #(parameter WIDTH = 64) (
  input  clk,
  input  enable,
  input  [WIDTH-1:0] data_in,
  input  reset,
  output  [WIDTH-1:0] data_out
);

  reg [WIDTH-1:0] reg_data;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      reg_data <= 0;
    end else if (enable) begin
      reg_data <= data_in;
    end
  end

  assign data_out = reg_data;

endmodule

//SOMADOR - SIMPLIFICADO DA ULA
module Somador (somaDiferenca, C, Overflow, A, B);
   output [63:0] somaDiferenca;   
   output C;   
   output Overflow;
   input [63:0] 	A;   
   input [63:0] 	B;  
     
   assign somaDiferenca = (A+B); 


endmodule 
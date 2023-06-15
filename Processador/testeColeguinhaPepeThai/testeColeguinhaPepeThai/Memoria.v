module Memoria(
    input [5:0] i_mem_addr,
    input [5:0] d_mem_addr,
    input d_mem_we,
    input clk,
    output [31:0] i_mem_data,
    inout  [63:0] d_mem_data
);

wire [31:0] i_mem_data_interno;
wire [63:0] d_mem_data_in, d_mem_data_out; //entrada e saida da memoria ram
wire clk_atrasado;
assign d_mem_data = d_mem_we ? 64'bz : d_mem_data_out ;
assign d_mem_data_in = d_mem_data;
assign i_mem_data = i_mem_data_interno;

atrasa_clk_3x1 atrasa_clk(.clk(clk),.clk_out(clk_atrasado));

data_memory MemD( 
    .d_mem_addr(d_mem_addr),  
    .d_mem_we(d_mem_we),
    .clk(clk_atrasado),
    .d_mem_data_in(d_mem_data_in),               //Valor que entra na memória
    .d_mem_data_out(d_mem_data_out)          //Valor que sai da memória
);

instruction_memory MemI( 
    .i_mem_addr(i_mem_addr),                           //Valor que entra na memória
    .i_mem_data(i_mem_data_interno)          //Valor que sai da memória (referente ao i_mem_addr)
);


endmodule
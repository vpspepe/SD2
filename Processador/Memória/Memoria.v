module Memoria(
    input [63:0] dIn,
    input [31:0] PC,
    input [4:0] address,
    input WE,
    input clk,
    output [31:0] instruction,
    output [63:0] data_out
);

wire [31:0] instruction_interno;

assign instruction = instruction_interno;

data_memory data_memory( 
    .address(address),  
    .WE_mem(WE),
    .clk(clk),
    .dIN(dIn),               //Valor que entra na memória
    .dout(data_out)          //Valor que sai da memória
);

instruction_memory instruction_memory( 
    .PC(PC),                           //Valor que entra na memória
    .instruction(instruction_interno)          //Valor que sai da memória (referente ao PC)
);


/* 
memory_controller memory_controller( // controla qual será a saída, de acordo com o valor
    .data(dout),
    .instruction(instruction),
    .state,
    .memory_out
);
*/

endmodule
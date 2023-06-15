module memory_controller(
    input [63:0] data,
    input [31:0] instruction,
    input [4:0] state,
    output [63:0] memory_out
);
/*parameter init = 0, fetch = 1, decode = 2, executeRtypeADD = 3, executeItypeLOAD = 4, executeItypeADDI = 5, executeStypeSTORE = 6, 
          executeBtypeBRANCH = 7, executeItypeJALR = 8, executeJtypeJAL = 9, executeUtypeAUIPC = 10, write_back = 11;

parameter Rtype = 7'b0110011, load = 7'b0000011, addi = 7'b0010011, store = 7'b0100011, branch = 7'b1100011, jalr = 7'b1100111, 
          jal = 7'b1101111, auipc = 7'b0010111;
*/

assign memory_out = (state == 1 | state == 2) ? {32'b0, instruction} : data;


endmodule
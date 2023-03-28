module memoria_ram(

input [7:0] data, //dados
input [5:0] path, //endereço
input we, //write enable
input clk, //clk
output [7:0] q //output data
)

reg [7:0] ram [63:0]; //
reg [5:0] path_reg;//path register

always @ (posedge clk)
begin
if (we)
ram[addr] <= data;
else
addr_reg <= addr;
end

assign q = ram[addr_reg];

endmodule

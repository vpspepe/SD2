module ULA_control (
    input [6:0] funct7, 
    input [2:0] funct3,
    input [3:0] alu_cmd,
    output reg [3:0] op
);

parameter Rtype = 4'b0000, Itype = 4'b0001, Stype = 4'b0010, Btype = 4'b0011 ;
parameter add = 4'b0010, sub = 4'b0110;

always @(*) begin
    
    if(Rtype == alu_cmd) begin
        if(funct7 == 7'b0000000 & funct3 == 3'b000) begin
            op <= add;
        end
        if(funct7 == 7'b0100000 & funct3 == 3'b000) begin
            op <= sub;
        end
    end

    if(Itype == alu_cmd || Stype == alu_cmd || Btype == alu_cmd) begin
            op <= add;
    end

end
endmodule
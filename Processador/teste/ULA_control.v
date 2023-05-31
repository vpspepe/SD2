module ULA_control (
    input [6:0] funct7, 
    input [2:0] funct3,
    input [1:0] ULAop,
    //input [5:0] flags,
    //output branch,
    output reg [3:0] op
);

parameter Rtype = 2'b10, Itype = 2'b00;
parameter add = 4'b0010, sub = 4'b0110;

always @(*) begin
    
    if(Rtype == ULAop) begin
        if(funct7 == 7'b0000000 & funct3 == 3'b000) begin
            op <= add;
        end
        if(funct7 == 7'b0100000 & funct3 == 3'b000) begin
            op <= sub;
        end
    end

    if(Itype == ULAop) begin
            op <= add;
    end

end
endmodule
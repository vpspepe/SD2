module mux5to1(
    input [4:0] A,
    input [4:0] B,
    input [4:0] C,
    input [4:0] D,
    input [4:0] E;
    input [2:0] select;
    input clk,
    output [4:0] result
);
 
always @ (posedge clk)
begin : 
    case(select) 
        0:
        result <= A;
        1:
        result <= B;
        2:
        result <= C;
        3:
        result <= D;
        4:
        result <= E;
    endcase 
end
endmodule
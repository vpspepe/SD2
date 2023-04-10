module mux8to1_16bits(
    input [15:0] A,
    input [15:0] B,
    input [15:0] C,
    input [15:0] D,
    input [15:0] E;
    input [15:0] F,
    input [15:0] G,
    input [15:0] H,
    input [2:0] select,
    input clk,
    output [15:0] result
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
        5:
        result <= F;
        6:
        result <= G;
        7:
        result <= H;
    endcase 
end
endmodule
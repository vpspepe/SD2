module demux1to4_10bits(
    input [9:0] X,
    output [9:0] A,
    output [9:0] B,
    output [9:0] C,
    output [9:0] D,
    input [1:0] select,
    input clk,
);
    
always @(posedge clk) begin
    case (select)
        0: begin 
        A <= X;     
        B <= 0;
        C <= 0;
        D <= 0;
        end
        1: 
        A <= 0;     
        B <= X;
        C <= 0;
        D <= 0;
        2: 
        A <= 0;     
        B <= 0;
        C <= X;
        D <= 0;
        3:
        A <= 0;     
        B <= 0;
        C <= 0;
        D <= X;
    endcase 
end
endmodule
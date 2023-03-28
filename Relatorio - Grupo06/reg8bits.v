module reg8bits(CLK,reset,regin,regout);

    parameter N = 8;
    input [N-1:0]regin;
    input reset,CLK;
    output reg [N-1:0]regout;

    always@(posedge CLK, posedge reset) begin
        if(reset == 1) 
            regout <= 8'b0;
        
        else begin
            regout <= regin;
        end
    end
endmodule
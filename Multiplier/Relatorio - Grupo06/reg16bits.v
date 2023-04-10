module reg16bits(CLK,reset,regin,regout);

    parameter N = 16;
    input [N-1:0]regin;
    input reset,CLK;
    output reg [N-1:0]regout;

    always@(posedge CLK, posedge reset) begin
        if(reset == 1) 
            regout <= 16'b0;
        
        else begin
            regout <= regin;
        end
    end
endmodule
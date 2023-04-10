`timescale 10ns/100ps
module multiplier8bits_ROM_tb;

    reg [7:0] w_tb, y_tb;
    reg S_tb, RESET_tb, CLK_tb;
    wire [15:0] result_tb;
    wire PRONTO_tb; 


    multiplier8bits_ROM uut(.w(w_tb), .y(y_tb),.S(S_tb),
                            .RESET(RESET_tb), .CLK(CLK_tb),
                            .result(result_tb),.PRONTO(PRONTO_tb));

    initial begin

        $monitor("W = %d || Y = %d || resultado = %d || PRONTO = %d || S = %d",w_tb,y_tb,result_tb,PRONTO_tb,S_tb);
        CLK_tb = 1;
        RESET_tb = 1;
        S_tb = 1;
        #10
        RESET_tb = 0;

        #10
        w_tb = 8'd17; 
        y_tb = 8'd23; 
        
    end
    always #10 CLK_tb = ~CLK_tb;

endmodule
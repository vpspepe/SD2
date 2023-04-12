`timescale 1ns/10ps

module FD_multiplier8bitsc2_tb;

    reg [7:0] x_tb, y_tb;
    reg CLK_tb, RESET_tb;
    reg LD_XY_tb, LD_A_tb, LD_B_tb, LD_DE0_tb,LD_DE1_tb, LD_AB_tb, LD_DE_ABshift_tb, LD_RES_tb;
    reg [1:0] SELROM_tb;
    reg [1:0] SELSOMA_tb;
    wire [15:0] result_tb;
    wire PRONTO_tb; 

    FD_multiplier8bitsc2 uut(.x(x_tb), .y(y_tb),
    .LD_XY(LD_XY_tb), .LD_DE0(LD_DE0_tb), .LD_A(LD_A_tb), .LD_B(LD_B_tb), 
    .LD_DE1(LD_DE1_tb),.LD_AB(LD_AB_tb), .LD_DE_ABshift(LD_DE_ABshift_tb), .LD_RES(LD_RES_tb),   .SELROM(SELROM_tb), .SELSOMA(SELSOMA_tb),
    .CLK(CLK_tb), .RESET(RESET_tb), 
    .result(result_tb));

    initial begin

        $monitor("RESET = %d || x = %d || y = %d || XY = %d ||DE0 = %d ||A = %d ||B = %d ||DE1 = %d ||SELROM = %d ||SELSOMA = %d ||LoadRES = %d || resultado = %d || PRONTO = %d",
                 RESET_tb,      x_tb,      y_tb,   LD_XY_tb,  LD_DE0_tb, LD_A_tb, LD_B_tb, LD_DE1_tb, SELROM_tb,   SELSOMA_tb,    LD_RES_tb,      result_tb,       PRONTO_tb);                                               
        
        LD_XY_tb = 0;
        LD_A_tb = 0;
        LD_B_tb = 0;
        LD_DE0_tb = 0;
        LD_DE1_tb = 0;
        LD_AB_tb = 0;
        LD_DE_ABshift_tb =0;
        LD_RES_tb = 0;
        CLK_tb = 1;
        RESET_tb = 1;
        SELSOMA_tb = 0;
        SELROM_tb = 0;

        #20
        RESET_tb = 0;

        #30
        x_tb = 8'd14; 
        y_tb = 8'd8; 
        #20
        LD_XY_tb = 1;
        
        
        #60
        LD_XY_tb = 0;
        LD_DE0_tb = 1;

        #60
        LD_DE0_tb = 0;
        SELROM_tb  = 1;

        #70
        LD_A_tb = 1;

        #80
        LD_A_tb = 0;
        SELROM_tb  = 2;
        
        #90
        LD_B_tb = 1;
        

        #100
        LD_B_tb = 0;
        SELROM_tb  = 3;

        #110
        LD_DE1_tb = 1;
        #10
        SELROM_tb = 0;

        #120
        LD_DE1_tb = 0;
        SELSOMA_tb = 1;

        #10 
        LD_AB_tb = 1;

        #130
        LD_AB_tb = 0;
        SELSOMA_tb = 2;

        #10
        LD_DE_ABshift_tb = 1;

        #10 
        LD_DE_ABshift_tb = 0;
        SELSOMA_tb = 3;

        #10
        LD_RES_tb = 1;
        #10
        LD_RES_tb = 0;


        #190
        RESET_tb = 1;
        #10
        RESET_tb = 0;


        
    end
    always #10 CLK_tb = ~CLK_tb;

endmodule

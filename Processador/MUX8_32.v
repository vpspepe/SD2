module MUX8_32(
    input [5:0] flags,
    input [2:0] select,
    output reg flag);

/*
BEQ = 0
BNE = 1
BLT = 2
BGE = 3
BLTU = 4
BGEU = 5 
default = 8
*/
parameter BEQ = 0, BNE = 1, BLT = 2, BGE = 3, BLTU = 4, BGEU = 5 ;

always @(*)begin
    case (select)
        BEQ:  
            flag <= flags[BEQ];
        BNE:  
            flag <= flags[BNE];
        BLT:  
            flag <= flags[BLT];
        BGE:  
            flag <= flags[BGE];
        BLTU:  
            flag <= flags[BLTU];
        BGEU:  
            flag <= flags[BGEU];
        
        default: flag <= 8;
    endcase
end


endmodule
module MemInstruction( 
    input [31:0] instruction,  //guarda endereço que é a soma de doutB + OFFSET            //Valor que entra na memória
    output [31:0] dout          //Valor que sai da memória
);

    /*!!*/reg [31:0] mem [127:0];

    // atribuindo valores para memoria e load/store

    assign dout = mem[instruction];       //Leitura de dados no Memória (Load) 



initial begin
    //       imm[12]       | Rb[5] |funct3[3] |       Rw[5]      | opcode[7] -> I-Type
    //funct7[7] | Rb[5]    | Ra[5] |funct3[3] |       Rw[5]      | opcode[7] -> R-Type
    //imm [bit12 + 10:5]   | Rb[5] | Rb[5] |funct3[3] | imm[4:1 + bit11] | opcode[7] -> B-type
    
    mem[0] = 32'b0;
    mem[4] = {12'b000000000001,5'b00000,3'b001,5'b00001,7'b0000011};     //load x1, #1(x0) x1 = 10
    mem[8] = {12'b000000000010,5'b00000,3'b001,5'b00010,7'b0000011};     //load x2, #2(x0) x2 = 20
    mem[12] = {7'b0000000,5'b00010,5'b00001,3'b000,5'b00011,7'b0110011};  //add x3,x1,x2    x3 = 30
    mem[16] = {7'b0000000,5'b00001,5'b00011,3'b000,5'b00100,7'b0110011};  //sub x4,x3,x1    x4 = 20
    //mem[5] = {12'b000000000011,5'b00011,3'b010,5'b00000,7'b0100011};     //store x3,#3(x0) 
    mem[20] = {7'b0000000,5'b00000,5'b00011,3'b010,5'b00011,7'b0100011};     //store x3,#3(x0) 
    mem[24] = {7'b0000000,5'b00000,5'b00100,3'b010,5'b00100,7'b0100011};     //store x4,#4(x0)
    //mem[6] = {12'b000000000100,5'b00100,3'b010,5'b00000,7'b0100011};     //store x4,#4(x0)
    mem[28] = {12'b000000001010,5'b00100,3'b010,5'b01001,7'b0010011};     //addi  x9,#10(x4) x9 = 30
    mem[32] = {7'b0000000,5'b00000,5'b01001,3'b010,5'b01001,7'b0100011};    //store x9,#9(x0)
    //mem[8] = {12'b000000001001,5'b01001,3'b010,5'b00000,7'b0100011};     //store x9,#9(x0)
    mem[36] = {1'b0,6'b000000,5'b00011,5'b00011,3'b000,4'b0100,1'b0,7'b1100011};   //BEQ x3,x3 #8
    mem[40] = 32'b0; //jumped
    mem[44] = {7'b0000000,5'b00010,5'b00001,3'b000,5'b00101,7'b0110011};  //add x5,x1,x2    x3 = 30 
    mem[48] = {20'b00000000100000000000, 5'b01011, 7'b1101111};  // J type jal x11, #8   x11 = 11
    mem[56] = {12'b000000001000, 5'b01011, 3'b000, 5'b01110, 7'b1100111};  // I type jalr x14,#8(x11)   x11 = 11
    mem[60] = {12'b000000000101,5'b00000,3'b001,5'b00110,7'b0000011}; //load x6, #5(x0) x6 = -10 
    mem[64] = {7'b0000000,5'b00110,5'b00001,3'b000,5'b00111,7'b0110011};  //add x7,x1,x6    x7 = 0
    mem[68] = {7'b0000000,5'b00001,5'b00010,3'b000,5'b01000,7'b0110011};  //sub x8,x2,x1    x8 = 10
    mem[72] = {20'b00000000000000000001, 5'b01010, 7'b0010111};  // U type auipc x10, #123  x10 = 10



end

endmodule
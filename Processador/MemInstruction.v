module MemInstruction( 
    input [31:0] instruction,  //guarda endereço que é a soma de doutB + OFFSET            //Valor que entra na memória
    output [31:0] dout          //Valor que sai da memória
);

    /*!!*/reg [63:0] mem [31:0];

    // atribuindo valores para memoria e load/store

    assign dout = mem[instruction];       //Leitura de dados no Memória (Load) 



initial begin
    //       imm[12]       | Rb[5] |funct3[3] |       Rw[5]      | opcode[7] -> I-Type
    //funct7[7] | Rb[5]    | Ra[5] |funct3[3] |       Rw[5]      | opcode[7] -> R-Type
    //imm [bit12 + 10:5]   | Rb[5] | Rb[5] |funct3[3] | imm[4:1 + bit11] | opcode[7] -> B-type
    
    mem[0] = 32'b0;
    mem[1] = {12'b000000000001,5'b00000,3'b001,5'b00001,7'b0000011};     //load x1, #1(x0) x1 = 10
    mem[2] = {12'b000000000010,5'b00000,3'b001,5'b00010,7'b0000011};     //load x2, #2(x0) x2 = 20
    mem[3] = {7'b0000000,5'b00010,5'b00001,3'b000,5'b00011,7'b0110011};  //add x3,x1,x2    x3 = 30
    mem[4] = {7'b0000000,5'b00001,5'b00011,3'b000,5'b00100,7'b0110011};  //sub x4,x3,x1    x4 = 20
    mem[5] = {12'b000000000011,5'b00011,3'b010,5'b00000,7'b0100011};     //store x3,#3(x0) 
    mem[6] = {12'b000000000100,5'b00100,3'b010,5'b00000,7'b0100011};     //store x4,#4(x0)
    mem[7] = {12'b000000001010,5'b00100,3'b010,5'b01001,7'b0010011};     //addi  x9,#10(x4) x9 = 30
    mem[8] = {12'b000000001001,5'b01001,3'b010,5'b00000,7'b0100011};     //store x9,#9(x0)
    mem[9] = {7'b0000010,5'b00011,5'b00011,3'b000,5'b00000,7'b1100011};   //BEQ x3,x3 #-4
    mem[10] = 32'b0; //jumped
    mem[11] = {7'b0000000,5'b00010,5'b00001,3'b000,5'b00101,7'b0110011};  //add x5,x1,x2    x3 = 30 
    

end

endmodule
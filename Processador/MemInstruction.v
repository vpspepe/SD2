module MemInstruction( 
    input [31:0] instruction,  //guarda endereço que é a soma de doutB + OFFSET            //Valor que entra na memória
    output [63:0] dout          //Valor que sai da memória
);

    /*!!*/reg [63:0] mem [31:0];

    // atribuindo valores para memoria e load/store

    assign dout = mem[instruction];       //Leitura de dados no Memória (Load) 

endmodule

initial begin
    // offset[12] | Ra[5] | funct3 [3] | Rw[5] | opcode[7]
    //funct7[7] | Rb[5] | Ra[5] |funct3[3] | Rw[5] | opcode[7]
    mem[0] = 0;
    mem[1] = {12'b000000000001,5'b00000,3'b001,5'b00010,7'b0000011}; //load 
    mem[4] = {12'b000000000000,5'b00000,3'b010,5'b00100,7'b0100011}; //store'b
    mem[3] = {7'b0000000,5'b00010,5'b00010,3'b000,5'b00011,7'b0110011}; //add - sub
    mem[2] = {12'b000000001001,5'b00011,3'b000,5'b00001,7'b0010011}; //addi - subi

end

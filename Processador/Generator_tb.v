module Generator_tb ();
    reg[31:0] instruction_tb;
    wire[31:0] immediate_tb;
    wire[5:0] Ra_tb, Rb_tb, Rw_tb;

    Generator uut(             //baseado no opcode, o bloco 'Generator' vai associar cada parte da instrucao a um endereço
    .opcode(instruction_tb[6:0]),
    .instruction(instruction_tb),
    .immediate(immediate_tb),
    .Ra(Ra_tb), .Rb(Rb_tb), .Rw(Rw_tb)
);

initial begin

        $dumpfile("testbenches/vvp/waveforms1.vcd");
        $dumpvars(0, Generator_tb);

        #10
        instruction_tb <= {12'b000000000001,5'b00000,3'b001,5'b00001,7'b0000011}; // I-TYPE
        #20
        instruction_tb <= {7'b0000000,5'b00010,5'b00001,3'b000,5'b00011,7'b0110011}; //R-TYPE
        #10
        instruction_tb <= {7'b0000000,5'b00010,5'b00001,3'b000,5'b00101,7'b0110011};
        #10
        instruction_tb <= {1'b0,6'b000000,5'b00011,5'b00011,3'b000,4'b0100,1'b0,7'b1100011}; //B-TYPE
        #10
        instruction_tb <= {20'b00000000010000000000, 5'b01011, 7'b1101111}; //J-TYPE
        #10
        instruction_tb <= {7'b0000000,5'b00000,5'b00100,3'b010,5'b00100,7'b0100011}; //S-TYPE store x4,#4(x0)
        #10
        instruction_tb = {20'b00000000000000000001, 5'b01010, 7'b0010111}; //U-TYPE auipc x10, #4096  x10 = 10
        #10
        instruction_tb <= 32'b0;
end

endmodule
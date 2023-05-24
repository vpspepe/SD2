module Generator(              //baseado no opcode, o bloco 'Generator' vai associar cada parte da instrucao a um endereço
    input [6:0] opcode,
    input [31:0] instruction,
    output reg[31:0] immediate,
    output reg[4:0] Ra, 
    output reg[4:0] Rb,
    output reg[4:0] Rw
);
    
    always @(*) begin
    case(opcode)

        7'b0110011: begin //R-TYPE
            //immediate <= 21'b0;
            Rb <= instruction[24:20];
            Ra <= instruction[19:15];
            Rw <= instruction[11:7];
            immediate <= 32'bx;
        end

        7'b0000011: begin   //I-TYPE LOAD 
            immediate <= {20'b00000000000000000000,instruction[31:20]};
            Rb <= instruction[19:15];
            Ra <= 5'bx;
            Rw <= instruction[11:7];
        end
        
        7'b0010011: begin   //I-TYPE ADDI 
            immediate <= {20'b00000000000000000000,instruction[31:20]};
            Rb <= 5'bx;
            Ra <= instruction[19:15];
            Rw <= instruction[11:7];
        end
        
        7'b1100111: begin    //I-type JALR
           immediate <= {20'b00000000000000000000,instruction[31:20]};
            Rb <= 5'bx;
            Ra <= instruction[19:15];
            Rw <= instruction[11:7];
        end

        7'b1100011: begin //B-type 
            immediate <= {20'b00000000000000000000,instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0};
            Rb <= instruction[24:20];
            Ra <= instruction[19:15];
            Rw <= 5'bx;
        end

        7'b0100011: begin //S-type STORE
            immediate <= {20'b00000000000000000000,instruction[31:25],instruction[11:7]};
            Rb <= instruction[24:20];
            Ra <= instruction[19:15];
            //funct3 -> instruction[14:12];
            Rw <= 5'bx;
        end

        7'b1101111: begin //J-TYPE Jal
            immediate <= {11'b00000000000,instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0};
            Rb <= 5'bx;
            Ra <= 5'bx;
            Rw <= instruction[11:7];
        end

        7'b0010111: begin //U-TYPE auipc
            immediate <= {instruction[31:12],12'b000000000000};
            Rb <= 5'bx;
            Ra <= 5'bx;
            Rw <=  instruction[11:7]; 
        end

        default: begin

        end

        endcase
    end


endmodule
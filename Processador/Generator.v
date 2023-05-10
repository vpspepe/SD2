module Generator (              //baseado no opcode, o bloco 'Generator' vai associar cada parte da instrucao a um endereço
    input [6:0] opcode,
    input [31:0] instruction,
    output reg[11:0] immediate,
    output reg[5:0] Ra, Rb, Rw
);
    
    always @(*) begin
        if(opcode == 7'b0110011) begin //R-TYPE
            immediate <= 0;
            Rb <= instruction[24:20];
            Ra <= instruction [19:15];
            Rw <= instruction [11:7];
        end 
        else begin
                if(opcode == 7'b0010011 | opcode == 7'b0000011) begin //I-type LOAD or I-type ADDI
                immediate <= instruction[31:20];
                Rb <= 0;
                Ra <= instruction[19:15];
                Rw <= instruction[11:7];
                end

                else begin
                    if(opcode == 7'b1100011) begin //B-type 
                    immediate <= {instruction[31],instruction[7],instruction[30:25],instruction[11:8]};
                    Rb <= instruction[24:20];
                    Ra <= instruction[19:15];
                    Rw <= 0;

                    end
                    else begin
                        if(opcode == 7'b0100011) begin //S-type ADDI
                        immediate <= {instruction[31:25],instruction[11:7]};
                        Rb <= immediate[24:20];
                        Ra <= immediate[19:15];
                        Rw <= 0;
                        end

                    end
                end
        end
    end

endmodule
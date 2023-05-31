module UC (
    input [6:0] opcode,
    input clk, reset,
    output reg PC_load,
    output reg WEMem, //writeEnable
    output reg RF_load, 
    output reg [1:0] ULAop,
    output reg IR_load,
    // selects
    output reg [1:0] OP_MEM_I,
    output reg select_JAL,
    output reg select_JALR
); 

reg [4:0] state; 

parameter init = 0, fetch = 1, decode = 2, executeRtype = 3, executeItypeLOAD = 4, executeItypeADDI = 5, executeStypeSTORE = 6, 
          executeBtypeBRANCH = 7, executeItypeJALR = 8, executeJtypeJAL = 9, executeUtypeAUIPC = 10, write_backREG = 11, write_backMEM = 12;

          // escrever na memória -> store
          // escrever no regfile -> add, sub, addi, jalr, jal, load, auipc
          // branch não escreve

parameter Rtype = 7'b0110011, load = 7'b0000011, addi = 7'b0010011, store = 7'b0100011, branch = 7'b1100011, jalr = 7'b1100111, 
          jal = 7'b1101111, auipc = 7'b0010111;

always @(posedge clk or posedge reset) begin
    if (reset == 1)
        state <= init;

    else begin
        case(state)
            init: begin
                state <= fetch;
            end
            fetch : begin
                state <= decode;
            end
            decode: begin
                case(opcode) 
                    Rtype: begin
                        state <= executeRtype;
                    end
                    load: begin
                        state <= executeItypeLOAD;
                    end
                    addi: begin
                        state <= executeItypeADDI;
                    end
                    store: begin
                        state <= executeStypeSTORE;
                    end
                    branch: begin
                        state <= executeBtypeBRANCH;
                    end
                    jalr: begin
                        state <= executeItypeJALR;
                    end
                    jal: begin
                        state <= executeJtypeJAL;
                    end
                    auipc: begin
                        state <= executeUtypeAUIPC;
                    end
                endcase
            end
            executeRtype: begin
                state <= write_backREG;
            end
            executeItypeLOAD: begin
                state <= write_backREG;
            end
            executeItypeADDI: begin
                state <= write_backREG;
            end
            executeStypeSTORE: begin
                state <= write_backMEM;
            end
            executeBtypeBRANCH: begin
                state <= fetch;
            end
            executeItypeJALR: begin
                state <= write_backREG;
            end
            executeJtypeJAL: begin
                state <= write_backREG;
            end
            executeUtypeAUIPC: begin
                state <= write_backREG;
            end
            write_backMEM: begin
                state <= fetch;
            end
            write_backREG: begin
                state <= fetch;
            end
        endcase
    end
end

always @(state) begin

    case(state)
    init: begin
        OP_MEM_I <= 0;
        select_JAL <= 0;
        select_JALR <= 0;
        // selects
        WEMem <= 0;
        RF_load <= 0;
        IR_load <= 0;
        ULAop <= 2'b00;
        PC_load <= 0;
    end
    fetch: begin
        // selects
        PC_load <= 1;
        IR_load <= 1;
    end
    decode: begin
        OP_MEM_I <= 0;
        select_JAL <= 0;
        select_JALR <= 0;
        // selects
        PC_load <= 0;
        IR_load <= 0;
    end
    executeRtype: begin
        OP_MEM_I <= 0;
        select_JAL <= 0;
        select_JALR <= 0;
        // selects
        ULAop <= 2'b10; // add ou sub
    end
    executeItypeLOAD: begin
        OP_MEM_I <= 1;
        select_JAL <= 0;
        select_JALR <= 0;
        // selects
        ULAop <= 2'b00;
    end
    executeItypeADDI: begin
        OP_MEM_I <= 2;
        select_JAL <= 0;
        select_JALR <= 0;
        // selects
        // ULAop <= 2'b01
    end
    executeStypeSTORE: begin
        OP_MEM_I <= 1;
        select_JAL <= 0;
        select_JALR <= 0;
        // selects
        ULAop <= 2'b00;
    end
    executeBtypeBRANCH: begin 
        OP_MEM_I <= 0;
        select_JAL <= 0;
        select_JALR <= 0;
        // selects
        // ULAop <= 2'b01;
        PC_load <= 1;
    end
    executeItypeJALR: begin
        OP_MEM_I <= 3;
        select_JAL <= 0;
        select_JALR <= 1;
        // selects
        PC_load <= 1;
    end
    executeJtypeJAL: begin
        OP_MEM_I <= 3;
        select_JAL <= 1;
        select_JALR <= 0;
        // selects
        PC_load <= 1;
    end
    executeUtypeAUIPC: begin
        OP_MEM_I <= 3;
        select_JAL <= 0;
        select_JALR <= 0;
        // selects
        PC_load <= 0;
    end
    write_backREG: begin
        OP_MEM_I <= 0;
        select_JAL <= 0;
        select_JALR <= 0;
        // selects 
        RF_load <= 1;
    end
    write_backMEM: begin
        OP_MEM_I <= 0;
        select_JAL <= 0;
        select_JALR <= 0;
        // selects
        WEMem <= 1;
        
    end
    endcase
end
endmodule
module uc (
    input [6:0] opcode,
    input clk, rst_n,
    input  [3:0] alu_flags,  
    output reg d_mem_we, //writeEnable
    output reg rf_we, 
    //output reg [1:0] ULAop,
    output [3:0] alu_cmd,  
    // selects
    output reg alu_src, pc_src, rf_src
); 

// AluCmd     AluFlags
    // 0000: R    0: zero
    // 0001: I    1: MSB 
    // 0010: S    2: overflow
    // 0011: SB
    // 0100: U
    // 0101: UJ 

reg [4:0] state; 

parameter fetch = 1, decode = 2, executeRtype = 3, executeItypeLOAD = 4, executeItypeADDI = 5, executeStypeSTORE = 6, 
          executeBtypeBRANCH = 7, executeItypeJALR = 8, executeJtypeJAL = 9, executeUtypeAUIPC = 10, write_backREG = 11, write_backMEM = 12;

          // escrever na memória -> store
          // escrever no regfile -> add, sub, addi, jalr, jal, load, auipc
          // branch não escreve

parameter Rtype = 7'b0110011, load = 7'b0000011, addi = 7'b0010011, store = 7'b0100011, branch = 7'b1100011, jalr = 7'b1100111, 
          jal = 7'b1101111, auipc = 7'b0010111;

always @(posedge clk or posedge rst_n) begin
    if (rst_n == 1)
    begin
        alu_src <= 0;
        // select_JAL <= 0;
        // select_JALR <= 0;
        // selects
        d_mem_we <= 0;
        rf_we <= 0;
        ULAop <= 2'b00;
        state <= fetch;
    end

    else begin
        case(state)
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
            // write_backMEM: begin
            //     state <= fetch;
            // end
            // write_backREG: begin
            //     state <= fetch;
            // end
        endcase
    end
end

always @(state) begin

    case(state)
    fetch: begin
        // selects
        rf_we <= 0;
    end
    decode: begin
        // selects

    end
    executeRtype: begin
        alu_src <= 0;
        pc_src <= 0;
        rf_src <= 0;
        // selects
        alu_cmd = 4'b0000;
    end
    executeItypeLOAD: begin
        alu_src <= 1;
        rf_src <= 1;
        pc_src <= 0;

        // selects
        alu_cmd = 4'b0001;  
    end
    // executeItypeADDI: begin
    //     alu_src <= 2;
    //     select_JAL <= 0;
    //     select_JALR <= 0;
    //     // selects
    //     // ULAop <= 2'b01
    // end
    executeStypeSTORE: begin
        alu_src <= 1;
        pc_src <= 0;
        rf_src <= 0;
        // selects
        alu_cmd = 4'b0010;  
    end
    executeBtypeBRANCH: begin 
        alu_src <= 0;
        pc_src <= 1;
        rf_src <= 0;

        // selects
        // ULAop <= 2'b01;
        alu_cmd <= 4'b0011;
    end
    // executeItypeJALR: begin
    //     alu_src <= 3;
    //     select_JAL <= 0;
    //     select_JALR <= 1;
    //     // selects
    //     PC_load <= 1;
    // end
    executeJtypeJAL: begin
        alu_src <= 1;
        select_JAL <= 1;
        select_JALR <= 0;
        // selects
        PC_load <= 1;
        alu_cmd <= 4'b0101;
    end
    // executeUtypeAUIPC: begin
    //     alu_src <= 3;
    //     select_JAL <= 0;
    //     select_JALR <= 0;
    //     // selects
    //     PC_load <= 0;
    // end
    write_backREG: begin
        // selects 
        rf_we <= 1;
    end
    write_backMEM: begin
        // selects
        d_mem_we <= 1;
        
    end
    endcase
end
endmodule
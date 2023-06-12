module Generator(              //baseado no opcode, o bloco 'Generator' vai associar cada parte da instrucao a um endereço
    input [6:0] opcode,
    input [31:0] instruction,
    output reg [31:0] immediate,
    output reg [4:0] Ra, 
    output reg [4:0] Rb,
    output reg [4:0] Rw,
    output reg [2:0] funct3,
    output reg [6:0] funct7
    );
    //imm[12]       | Ra[5] |funct3[3] |       Rw[5]      | opcode[7] -> I-Type
    //funct7[7] | Rb[5]    | Ra[5] |funct3[3] |       Rw[5]      | opcode[7] -> R-Type
    //imm [bit12 + 10:5]   | Rb[5] | Ra[5] |funct3[3] | imm[4:1 + bit11] | opcode[7] -> B-type
    //imm [11:5]   | Rb[5] | Ra[5] |funct3[3] | imm[4:0] | opcode[7] -> S-type

    always @(*) begin
    case(opcode)

        7'b0110011: begin //R-TYPE
            //immediate <= 21'b0;
            Rb <= instruction[24:20];
            Ra <= instruction[19:15];
            Rw <= instruction[11:7];
            immediate <= 32'bx;
            funct3 <= instruction[14:12];
            funct7 <= instruction[31:25];
        end

        7'b0000011: begin   //I-TYPE LOAD 
            immediate <= {20'b00000000000000000000,instruction[31:20]};
            Ra <= instruction[19:15];
            Rb <= 5'bx;
            Rw <= instruction[11:7];
            funct3 <= instruction[14:12];
        end
        
        7'b0010011: begin   //I-TYPE ADDI 
            immediate <= {20'b00000000000000000000,instruction[31:20]};
            Rb <= 5'bx;
            Ra <= instruction[19:15];
            Rw <= instruction[11:7];
            funct3 <= instruction[14:12];
        end
        
        7'b1100111: begin    //I-type JALR
           immediate <= {20'b00000000000000000000,instruction[31:20]};
            Rb <= 5'bx;
            Ra <= instruction[19:15];
            Rw <= instruction[11:7];
            funct3 <= instruction[14:12];
        end

        7'b1100011: begin //B-type 
            immediate <= {20'b00000000000000000000,instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0};
            Rb <= instruction[24:20];
            Ra <= instruction[19:15];
            Rw <= 5'bx;
            funct3 <= instruction[14:12];
        end

        7'b0100011: begin //S-type STORE
            immediate <= {20'b00000000000000000000,instruction[31:25],instruction[11:7]};
            Rb <= instruction[24:20];
            Ra <= instruction[19:15];
            funct3 <= instruction[14:12];
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

module adder(
    input [31:0] a,
    input [31:0] b,
    output [31:0] result
    );

    assign result = a + b;
endmodule

module atrasa_clk_3x1( //redutor de clock, ja que a datapath roda
    input clk,
    output clk_out
    );

    reg[1:0] counter;
    reg out;
    assign clk_out = (counter == 0) ? 1 : 0;

    initial begin
        counter <= 2;
    end

    always @(posedge clk ) begin
        if(counter == 2'b10)
            counter <= 2'b0;
        else
            counter <= counter + 1;
            
    end
endmodule

module DEMUX(
    input[63:0] a,
    input select,
    output[63:0] result0, result1
    );

    assign result0 = select == 1'b1 ? a: 64'b0 ;
    assign result1 = select == 1'b1 ? 64'b0: a;
endmodule

module MUX_64(
            input[63:0] a, b,
            input select,
            output[63:0] result); // output 

    assign result = select == 1'b1 ? b: a;
endmodule

module MUX2_32(
            input[31:0] a, b,       //0 1
            input select,
            output[31:0] result);   // output 

    assign result = select == 1'b1 ? b[31:0]: a[31:0];
endmodule

module MUX2_64(
             a, b,       //0 1
             select,
             result);   // output 
    parameter N = 64;
    input select;
    input [N-1:0] a, b;
    output [N-1:0] result;
    assign result = select == 1'b1 ? b[N-1:0]: a[N-1:0];
endmodule

module MUX4_64(
            input[63:0] a, b, c, d,    //00 01 10 11
            input[1:0] select,
            output[63:0] result);      // output 

    assign result = select[1] ? (select[0] ? d : c) : (select[0] ? b : a); 
endmodule

module MUX8_1(
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
            
            default: flag <= 8;  //mudar para 0
        endcase
    end
endmodule

module Reg_Banco(
    input[4:0] Ra,   //guarda endereço que só mexe no Banco de Registradores 
    input[4:0] Rb,   //guarda endereço que só mexe na Memória
    input[4:0] Rw,   //endereço do reg que vair receber o load
    input WE_Reg,    //write enable     
    input[63:0]dIN,  //data que vem da memória
    output reg [63:0] doutA, //valor de leitura do endereço Ra do Banco de Regs
    output reg [63:0] doutB, //valor padronizado por 0
    input clk
    );

    //gera os 32 registadores

        reg [63:0] banco_registradores[31:0]; 
        wire [63:0] banco_registradores_wire[31:0];

        wire [31:0] loads;

    Reg64 Regs( //registrador x0 sempre tem o valor 0
                    .x(64'b0),
                    .clk(clk), 
                    .load(1'b1), 
                    .x_out(banco_registradores_wire[0]) //saida precisava ser fio, e nao reg
                    );

    genvar i;
    generate 

    for (i = 1; i < 32 ; i = i+1 ) begin

        Reg64 Regs(
                    .x(dIN),  //todos os fios recebem dIN, o que vai diferenciar em qual reg vai salvar dIN é o LOAD
                    .clk(clk), 
                    .load(loads[i]), 
                    .x_out(banco_registradores_wire[i]) //saida precisava ser fio, e nao reg
                    );
    end

    endgenerate

    integer j,k;
    genvar l;

    initial begin //inicializa todos os registradores do banco com 0
            for (j = 0; j< 32; j = j + 1) 
                banco_registradores[j] <= 0;
    end


    always @(posedge clk) begin                             //faz com que os registradores sempre sejam definidos como os fios que saem dos modulos regNbits
        for (k=0; k<32; k = k+1) begin
            banco_registradores[k] <= banco_registradores_wire[k];
            // if(WE_Reg == 1) begin
            
            //     if(k == Rw)
            //         loads[Rw] <= 1;
            //     else 
            //         loads <= 0;
            // end

            // else
            //     loads[k] <= 0;
            end
        end

        assign loads[1] = WE_Reg ? (1 == Rw ? 1 : 0) : 0;
        assign loads[2] = WE_Reg ? (2 == Rw ? 1 : 0) : 0;
        assign loads[3] = WE_Reg ? (3 == Rw ? 1 : 0) : 0;
        assign loads[4] = WE_Reg ? (4 == Rw ? 1 : 0) : 0;
        assign loads[5] = WE_Reg ? (5 == Rw ? 1 : 0) : 0;
        assign loads[6] = WE_Reg ? (6 == Rw ? 1 : 0) : 0;
        assign loads[7] = WE_Reg ? (7 == Rw ? 1 : 0) : 0;
        assign loads[8] = WE_Reg ? (8 == Rw ? 1 : 0) : 0;
        assign loads[9] = WE_Reg ? (9 == Rw ? 1 : 0) : 0;
        assign loads[10] = WE_Reg ? (10 == Rw ? 1 : 0) : 0;
        assign loads[11] = WE_Reg ? (11 == Rw ? 1 : 0) : 0;
        assign loads[12] = WE_Reg ? (12== Rw ? 1 : 0) : 0;
        assign loads[13] = WE_Reg ? (13 == Rw ? 1 : 0) : 0;
        assign loads[14] = WE_Reg ? (14 == Rw ? 1 : 0) : 0;
        assign loads[15] = WE_Reg ? (15 == Rw ? 1 : 0) : 0;
        assign loads[16] = WE_Reg ? (16 == Rw ? 1 : 0) : 0;
        assign loads[17] = WE_Reg ? (17 == Rw ? 1 : 0) : 0;
        assign loads[18] = WE_Reg ? (18 == Rw ? 1 : 0) : 0;
        assign loads[19] = WE_Reg ? (19 == Rw ? 1 : 0) : 0;
        assign loads[20] = WE_Reg ? (20 == Rw ? 1 : 0) : 0;
        assign loads[21] = WE_Reg ? (21 == Rw ? 1 : 0) : 0;
        assign loads[22] = WE_Reg ? (22 == Rw ? 1 : 0) : 0;
        assign loads[23] = WE_Reg ? (23 == Rw ? 1 : 0) : 0;
        assign loads[24] = WE_Reg ? (24 == Rw ? 1 : 0) : 0;
        assign loads[25] = WE_Reg ? (25 == Rw ? 1 : 0) : 0;
        assign loads[26] = WE_Reg ? (26 == Rw ? 1 : 0) : 0;
        assign loads[27] = WE_Reg ? (27 == Rw ? 1 : 0) : 0;
        assign loads[28] = WE_Reg ? (28 == Rw ? 1 : 0) : 0;
        assign loads[29] = WE_Reg ? (29 == Rw ? 1 : 0) : 0;
        assign loads[30] = WE_Reg ? (30 == Rw ? 1 : 0) : 0;
        assign loads[31] = WE_Reg ? (31 == Rw ? 1 : 0) : 0;


        
        
        // if (WE_Reg) begin  
        //     loads[Rw] <= 1;
        // end
        // else begin
        //         loads <= 0;
        // end
        //end




    //Load e store

    always @(*) begin
        doutA <= banco_registradores_wire[Ra];
        doutB <= banco_registradores_wire[Rb];

        //if (WE_Reg) begin  
        //    loads[Rw] <= 1;
        //end
        
    end
endmodule

module Reg32(x,
                clk, load, 
                x_out,reset
            );

    parameter N = 32; //tamanho do registrador parametrizável

    input[N-1:0] x;   //entrada
    input clk, load,reset;  
    output reg[N-1:0] x_out; //saída

    always @(posedge reset) begin
        x_out <= 0;
    end

    always @(posedge clk) begin
            if (load == 1 & reset == 0) begin
                x_out <= x;
            end
    end

endmodule

module Reg64(x,
                clk, load, 
                x_out
    );

    parameter N = 64; //tamanho do registrador parametrizável

    input[N-1:0] x;   //entrada
    input clk, load;  
    output reg[N-1:0] x_out; //saída


    always @(posedge clk) begin

        if (load) begin
            x_out <= x;
        end

    end
endmodule

module ULA_control (
    input [6:0] funct7, 
    input [2:0] funct3,
    input [3:0] alu_cmd,
    output reg [3:0] op
    );

    parameter Rtype = 4'b0000, Itype = 4'b0001, Stype = 4'b0010, Btype = 4'b0011 ;
    parameter add = 4'b0010, sub = 4'b0110, _and = 4'b0000, _or = 4'b0001;

    always @(*) begin
        
        if(Rtype == alu_cmd) begin
            if(funct7 == 7'b0000000 ) begin
                if(funct3 == 3'b000)
                    op <= add;
                else if(funct3 == 3'b111)
                    op <= _and;
                else if(funct3 == 3'b110)
                    op <= _or;
            end
            if(funct7 == 7'b0100000 & funct3 == 3'b000) begin
                op <= sub;
            end
        end

        if(Itype == alu_cmd || Stype == alu_cmd || Btype == alu_cmd) begin
                op <= add;
        end

    end
endmodule

module ULA_selector(
    input [63:0] dinA,
    input [63:0] dinB,
    input [63:0] OFFSET,
    input alu_src,
    input [3:0] op, // vem da ULA_control
    output [63:0] dout,
    output [3:0] flags
    );

    wire [63:0] ULA_IN0,ULA_IN1; //saida da ULA para OPERAÇÃO e MEMORIA, respectivamente
    wire [63:0] ULA_OUT;



    assign dout = ULA_OUT;

    //MUX4_64 mux0(.a(dinA),.b(dinB),.c(dinA),.d(64'b0),.select(OP_MEM_I),.result(ULA_IN0));
    MUX4_64 mux1(.a(dinB),.b(OFFSET),.c(OFFSET),.d(64'b0),.select({1'b0,alu_src}),.result(ULA_IN1));


    ULA ULA(.a(dinA),.b(ULA_IN1),.op(op),.result(ULA_OUT), .flags(flags));
endmodule

module ULA(
            input[63:0] a , b,
            input [3:0] op, // input vem da ULA_control
            output[63:0] result,
            output[3:0] flags
    );
    wire[63:0] ula_out;
    parameter BEQ = 0, MSB = 1, Overflow = 2;
    parameter SOMA = 4'b0010, SUB = 4'b0110, AND = 4'b0000, OR = 4'b0001;
    //parameter BNE = 1, BLT = 2, BGE = 3, BLTU = 4, BGEU = 5 ;
    assign ula_out = op == SUB ? (a-b):
            (op == SOMA ? (a+b) :
            (op == AND ? (a&b) : (a|b)));
    assign result = ula_out;

    assign flags[3] = 0;
    assign flags[BEQ] = a == b ? 1 : 0;
    assign flags[MSB] = ula_out[63];
    assign flags[Overflow] = (op == 4'b0110) ? 
                    ( (a[63] != b[63] & ula_out[63] != a[63]) ? 1 : 0) : // se for uma sub, o msb de a e b forem diferentes e o msb do resultado for diferente do msb de a, deu overflow
                    ((a[63] == b[63] & ula_out[63] != a[63]) ? 1 : 0);  // se for uma add, o msb de a e b forem iguais e o msb do resultado for diferente do msb de a, deu overflow
    // assign flags[BNE] = a == b ? 0 : 1;
    // assign flags[BLT] = a < b ? 1 : 0;
    // assign flags[BGE] = a >= b ? 1 : 0;
    // assign flags[BLTU] = $unsigned(a) < $unsigned(b) ? 1 : 0;
    // assign flags[BGEU] = $unsigned(a) >= $unsigned(b) ? 1 : 0;
endmodule

module fd_entrega(
    input  clk,
    input  rf_we, d_mem_we, pc_src, rf_src, alu_src,
    input  rst_n, //rst_na o PC pra 0, como se fosse um boot
    input  [3:0] alu_cmd,
    output [6:0] opcode, //opcode enviado para UC
    output [5:0] d_mem_addr, //endereco enviado para a memoria RAM
    inout [63:0] d_mem_data, //dados enviados a memoria RAM
    output [5:0] i_mem_addr, //endereco enviado para a memoria de instrucoes
    input  [31:0] i_mem_data, //intrucao que chegar da memoria de instrucoes
    output [3:0] alu_flags

    );
    wire clk_atrasado;
    wire [63:0] d_mem_data_in, d_mem_data_out; //entrada e saida da memoria ram
    wire [31:0] addr_instruction; //endereco da memoria que chega ate o memoria de instruoes
    wire [31:0] PC_addr; //endereco que entra no PC
    wire [31:0] instruction_IR_out; //entrada e saida do IR ( a instrucao)
    wire [6:0] funct7;
    wire [2:0] funct3;
    wire [4:0] Ra,Rb,Rw; //entradas do reg file e da ula
    wire [31:0] imm; //imediato
    wire [63:0] doutA; //saida do regfile (reg[Ra])
    wire [63:0] doutB; //saida do regfile (reg[Ra])s
    wire [63:0] RF_input; //entrada do Regfile   
    wire [63:0] OFFSET; //imediado com sinal ajsutado
    wire [3:0] op; //saida do ula control e indica o que deve ser feito na ula
    wire [63:0] ULA_OUT;
    wire [3:0] flags;
    wire [2:0] select_flags; //ISSO N EXISTE ASSIM EH SO PRA TESTE

    assign OFFSET = imm[31] ? {32'b1,imm} : {32'b0,imm} ; // completa os demais bits com 1 ou 0 (- ou +)
    assign opcode = instruction_IR_out[6:0];
    assign i_mem_addr = addr_instruction[7:2];
    assign d_mem_addr = ULA_OUT[5:0];
    assign d_mem_data_out = doutB;

    atrasa_clk_3x1 redutor_de_clk(
        .clk(clk),
        .clk_out(clk_atrasado)
    );


    Generator instruction_organizor ( //organiza os valores com base na instrucao de 32 bits
        .opcode(instruction_IR_out[6:0]),
        .instruction(instruction_IR_out),
        .immediate(imm),
        .Ra(Ra), 
        .Rb(Rb),
        .Rw(Rw),
        .funct3(funct3),
        .funct7(funct7)
    );

    Reg32 PCreg( //PROGRAM COUNTER
        .clk(clk_atrasado),
        .x(PC_addr), 
        .load(1'b1),
        .x_out(addr_instruction),
        .reset(rst_n)
    );
    // se o sinal da ula (pc_src) for 1 E a flag BEQ for 1, faz PC+IMM na entrada do PC. Se nao faz PC + 4
    assign PC_addr = pc_src ? 
            (flags[0] ? (addr_instruction + OFFSET) : (addr_instruction + 4) ) 
            :   (addr_instruction + 4);

    Reg32 IR( //INSTRUCTION_REGISTER
        .clk(~clk_atrasado),
        .x(i_mem_data), 
        .load(1'b1),
        .x_out(instruction_IR_out),
        .reset(rst_n)
    );

    Reg_Banco RegFile( //REGISTER fILE QUE CONTEM O BANCO DE REGISTRADORES
        .Ra(Ra),
        .Rb(Rb),
        .Rw(Rw),
        .WE_Reg(rf_we),
        .dIN(RF_input),
        .doutA(doutA),
        .doutB(doutB),
        .clk(clk_atrasado)
    );

    assign RF_input = rf_src ? d_mem_data_in : ULA_OUT;
    assign d_mem_data = d_mem_we ? d_mem_data_out : 64'bz;
    assign d_mem_data_in = d_mem_data;

    ULA_control ULAcontrol(
        .funct7(funct7), 
        .funct3(funct3),
        .alu_cmd(alu_cmd),
        .op(op)
    );

    ULA_selector ULA_seletor( //seleciona o que entra na ULA principal
        .dinA(doutA),
        .dinB(doutB),
        .OFFSET(OFFSET),
        .alu_src(alu_src),
        .op(op),
        .dout(ULA_OUT),
        .flags(flags)
    );

    assign alu_flags = flags;

    // RF_e_PC_Input Inputs_rf_pc_controller(
    //     .flags(flags),
    //     .select_flags(select_flags),
    //     .doutA(doutA), //imediato e doutA
    //     .addr_instruction32(addr_instruction), 
    //     .imm32(imm), //endereco de 32bits que SAI do PC
    //     .ULA_OUT(ULA_OUT), 
    //     .Data(Data), //saida da ULA pricnipal, 
    //     .select_RF(OP_MEM_I),
    //     .JAL(JAL), 
    //     .JALR(JALR),
    //     .PC_addr32(PC_addr),
    //     .RF_input(RF_input)
    // );
endmodule
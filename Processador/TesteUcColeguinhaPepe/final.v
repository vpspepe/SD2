module fd_param
    #(  // Tamanho em bits dos barramentos
        parameter i_addr_bits = 6,
        parameter d_addr_bits = 6
    )(
        input  clk, rst_n,                   // clock borda subida, reset assíncrono ativo baixo
        output [6:0] opcode,                    
        input  d_mem_we, rf_we,              // Habilita escrita na memória de dados e no banco de registradores
        input  [3:0] alu_cmd,                // ver abaixo
        output [3:0] alu_flags,
        input  alu_src,                      // 0: rf, 1: imm
               pc_src,                       // 0: +4, 1: +imm
               rf_src,                       // 0: alu, 1:d_mem
        output [i_addr_bits-1:0] i_mem_addr,
        input  [31:0]            i_mem_data,
        output [d_addr_bits-1:0] d_mem_addr,
        inout   [63:0]        d_mem_data

    );
    //instanciações:
    reg_pc pc_inst(pc_in, clk_fd,pc_out,load_pc,rst_n); // mudulo do program_counter
    rf register_file(rs1, rs2, rf_we, rf_din, rd, clk_fd, rs1_out, rs2_out);// modulo register file (RF)
    alu ula(rs1_out, alu_b, alu_out,alu_op, alu_flags); // modulo da ULA

    //load_pc:
    reg load_pc;
    initial load_pc=1;

    //wires:
    wire [31:0] pc_in, pc_out;
    wire [31:0] soma_4, soma_imm;
    wire [31:0]imm,imm_i,imm_r,imm_b,imm_s,imm_u,imm_j;
    wire [6:0] opcode;
    wire [4:0] rs1,rs2,rd;
    wire [63:0] rf_din,rs1_out, rs2_out;
    wire [63:0] alu_b,alu_out; 
    wire [1:0] alu_op;
    wire [3:0] funct;


    //opcode:
    parameter op_i = 7'b0010011;
    parameter op_r = 7'b0110011;
    parameter op_b = 7'b1100011;
    parameter op_sb = 7'b0100011;
    parameter op_u = 7'b0010111;
    parameter op_j = 7'b1101111;
    parameter op_I = 7'b1100111;
    parameter op_iLD = 7'b0000111;
    
    //alu_cmd:
    parameter R = 4'b0000, I = 4'b0001, S = 4'b0010, SB = 4'b0011, U = 4'b0100, UJ = 4'b0101;

    //enredeços das memórias
    assign i_mem_addr = pc_out[6:2];
    assign d_mem_addr = alu_out[5:0];

    //dados da memoria de dados
    assign d_mem_data = d_mem_we ? rs2_out: 64'bz;


    //rs1 rs2 , rd e opcode:
    assign rs1 = i_mem_data[19:15];
    assign rs2 = i_mem_data[24:20];
    assign rd = i_mem_data[11:7];
    assign opcode = i_mem_data[6:0];

    // format i
    assign imm_i = i_mem_data[31]?{{20{1'b1}},i_mem_data[31:20]}:{20'd0,i_mem_data[31:20]};
    //format b
    assign imm_b = i_mem_data[31]?{{19{1'b1}},i_mem_data[31],i_mem_data[7],i_mem_data[30:25],i_mem_data[11:8],1'b0}:{19'b0,i_mem_data[31],i_mem_data[7],i_mem_data[30:25],i_mem_data[11:8],1'b0};
    //format s
    assign imm_s = i_mem_data[31]?{{20{1'b1}},i_mem_data[31:25], i_mem_data[11:7]}:{20'b0,i_mem_data[31:25], i_mem_data[11:7]};
    //format u
    assign imm_u = i_mem_data[31]?{{12{1'b1}},i_mem_data[31:12]}:{12'b0,i_mem_data[31:12]};
    //format j
    assign imm_j = i_mem_data[31]?{{12{1'b1}},i_mem_data[31],i_mem_data[19:12],i_mem_data[20],i_mem_data[30:21]}:{12'b0,i_mem_data[31],i_mem_data[19:12],i_mem_data[20],i_mem_data[30:21]};
    //imm
    assign imm =    (opcode == op_i)? imm_i:
                    (opcode == op_I)? imm_i:
                    (opcode == op_b)? imm_b:
                    (opcode == op_sb)? imm_s:
                    (opcode == op_u)? imm_u:
                    (opcode == op_j)? imm_j:
                    (opcode == op_iLD)? imm_i:

                    {32{1'bx}};              


    //somadores:
    assign soma_4 = pc_out + 4;
    assign soma_imm = pc_out + (imm);

    //muxs:
    assign pc_in = pc_src? soma_imm : soma_4;
    assign alu_b = alu_src? imm:rs2_out; 
    assign rf_din = rf_src? d_mem_data:alu_out;


    //alu control:
    assign funct = {i_mem_data[30], i_mem_data[14:12]};
    assign alu_op = (alu_cmd == R)? ((funct == 4'b0000)? 0: (funct == 4'b1000)? 1: (funct == 4'b0111)? 2: (funct == 4'b0110)? 3: 2'bxx):
                    (alu_cmd == I)? 0:
                    (alu_cmd == SB)? 1:
                    (alu_cmd == S)? 0:
                    1'bx;


    //redutor de clock
    reg[1:0] conta_3;
    wire clk_fd;

    initial conta_3 = 0;

    always@(posedge clk)begin
        if (conta_3 == 2'b11) conta_3 = 0;
        conta_3 = conta_3 + 1;
    end

    assign clk_fd = conta_3[0] & conta_3[1];



      
endmodule

    



module reg_pc (reg_pi, clk, reg_po, load, reset);
parameter WIDTH = 32;
input [(WIDTH-1):0] reg_pi;
input clk, load, reset;
output [(WIDTH-1):0] reg_po;
reg [(WIDTH-1):0] internal_data;

initial internal_data=0;

always @(posedge clk) begin
    if (load == 1)internal_data = reg_pi;
end

always@(reset) begin
    if (reset == 0) internal_data = 0;
end

assign reg_po = internal_data;

endmodule


module register (reg_pi, clk, reg_po, load);
parameter WIDTH = 64;
input [(WIDTH-1):0] reg_pi;
input clk, load;
output [(WIDTH-1):0] reg_po;
reg [(WIDTH-1):0] internal_data;

always @(posedge clk) begin
    if(load == 1) internal_data = reg_pi;
end
assign reg_po = internal_data;
endmodule

module rf(rs1, rs2, we, din, rd, clk, rs1_out, rs2_out);
input [63:0] din;
input [4:0] rs1, rs2, rd;
input clk, we;
output [63:0] rs1_out, rs2_out;

reg [31:0] load_reg;
wire [31:0]load;
wire [63:0]reg_out[31:0];


genvar i;

generate 
    for(i=3;i<32;i=i+1) begin : GEN_BLOCK
    register xN(din,clk,reg_out[i],load_reg[i]);
    end
endgenerate 

assign rs1_out = reg_out[rs1];
assign rs2_out = reg_out[rs2];


//para testes:
assign reg_out[0] = 5;
assign reg_out[1] = 4;
assign reg_out[2] = 30;



always@(rd,we)begin
    if (we == 1'b1)begin
        load_reg = 0;
        case(rd)
            5'b00000: load_reg[0] = 1;
            5'b00001: load_reg[1] = 1;
            5'b00010: load_reg[2] = 1;
            5'b00011: load_reg[3] = 1;
            5'b00100: load_reg[4] = 1;
            5'b00101: load_reg[5] = 1;
            5'b00110: load_reg[6] = 1;
            5'b00111: load_reg[7] = 1;
            5'b01000: load_reg[8] = 1;
            5'b01001: load_reg[9] = 1;
            5'b01010: load_reg[10] = 1;
            5'b01011: load_reg[11] = 1;
            5'b01100: load_reg[12] = 1;
            5'b01101: load_reg[13] = 1;
            5'b01110: load_reg[14] = 1;
            5'b01111: load_reg[15] = 1;
            5'b10000: load_reg[16] = 1;
            5'b10001: load_reg[17] = 1;
            5'b10010: load_reg[18] = 1;
            5'b10011: load_reg[19] = 1;
            5'b10100: load_reg[20] = 1;
            5'b10101: load_reg[21] = 1;
            5'b10110: load_reg[22] = 1;
            5'b10111: load_reg[23] = 1;
            5'b11000: load_reg[24] = 1;
            5'b11001: load_reg[25] = 1;
            5'b11010: load_reg[26] = 1;
            5'b11011: load_reg[27] = 1;
            5'b11100: load_reg[28] = 1;
            5'b11101: load_reg[29] = 1;
            5'b11110: load_reg[30] = 1;
            5'b11111: load_reg[31] = 1;
        endcase
    end
    else load_reg = 0;
end

assign load = load_reg;



initial begin 
    $monitor("reg3=%d , reg4=%d, reg7=%d, reg8=%d, reg11=%d",reg_out[3],reg_out[4],reg_out[7],reg_out[8],reg_out[11]);
end

endmodule

module somador (
    input wire [63:0]A,
    input wire [63:0]B,
    output wire [63:0]Z,
    output wire Cout);
    wire [64:0]soma_provisoria;

    assign soma_provisoria = A + B;
    assign Cout = soma_provisoria[64];
    assign Z = soma_provisoria[63:0];


endmodule

module alu(input [63:0] A,
   input [63:0] B,
   output  [63:0] Z,
   input  [1:0]operacao,
   output [3:0]alu_flags);
   wire [63:0] A_final, B_final, adder,AND,OR;
   wire Cout;

somador adder_64bits(A,B_final,adder,Cout);

//fio de soma e subtracao:
assign B_final =  operacao[0]? (~B)+1 : B;
assign Z = operacao[1]? (operacao[0]? OR : AND) : adder;

assign AND = A & B;
assign OR = A || B;
 
//flags:
assign alu_flags[0] = ~| Z;
assign alu_flags[1] = Z[63];
assign alu_flags[2] = ~Cout ;
assign alu_flags[3] = 0;



endmodule
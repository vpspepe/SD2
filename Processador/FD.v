module FD(
    input[4:0] Ra,   //guarda endereço de acesso ao banco de registradores
    input[4:0] Rb,   //guarda endereço de acesso da memória (constante e igual a 0)
    input[4:0] Rw,  
    input WE_reg, WE_mem,     
    output [63:0] doutA, //valor de leitura do Registrador Ra
    output [63:0] doutB, //valor de leitura do Rb
    output [63:0] doutMem,
    input clk,
    input [63:0] OFFSET,
    input [1:0] OP_MEM_I,  //=0 -> add/sub ; = 1 -> LOAD/STORE;  = 2 -> ADDI/SUBI
    input ADD_SUB
);



wire [63:0] final_address;              // endereco que entra na memoria
wire [63:0] ULA_OUT;                    // fio que sai da ULA
wire [63:0] regIN_memOUT;               // fio que sai da memoria
wire [63:0] Dw;                         // valor que entra para ser escrito no banco de registradores

assign doutMem = regIN_memOUT;
assign final_address = ULA_OUT;

Reg_Banco u1(
            .Ra(Ra),
            .Rb(Rb),
            .Rw(Rw),
            .WE_Reg(WE_reg),
            .dIN(Dw),
            .doutA(doutA),
            .doutB(doutB),
            .clk(clk)
);

operacao_memoria u2(
     .dinA(doutA),
     .dinB(doutB),
     .OFFSET(OFFSET),
     .OP_MEM_I(OP_MEM_I),
     .clk(clk),
     .ADD_SUB(ADD_SUB),
     .dout(ULA_OUT)
);

Memoria u3( 
     .final_address(final_address[4:0]),
     .WE_mem(WE_mem),
     .dIN(doutA),
     .dout(regIN_memOUT), 
     .clk(clk)
);


MUX4_64 u4(.a(ULA_OUT),.b(regIN_memOUT),.c(ULA_OUT),.d(x),.select(OP_MEM_I),.result(Dw));





endmodule
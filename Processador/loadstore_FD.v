module loadstore_FD(
    input[4:0] Ra,   //guarda endereço de acesso ao banco de registradores
    input[4:0] Rb,   //guarda endereço de acesso da memória (constante e igual a 0)
    input[4:0] Rw,  
    input WE_reg, WE_mem,       
    output [63:0] doutA, //valor de leitura do Registrador Ra
    output [63:0] doutB, //valor de leitura do Rb
    output [63:0] doutMem,
    input clk,
    input [4:0] OFFSET
);


wire [4:0] final_address;
wire [63:0] regIN_memOUT;


assign  final_address = doutB[4:0] + OFFSET;  //5 bits menos significativos do doutB
assign doutMem = regIN_memOUT;


Reg_Banco u1(
            .Ra(Ra),
            .Rb(Rb),
            .Rw(Rw),
            .WE_Reg(WE_reg),
            .dIN(regIN_memOUT),
            .doutA(doutA),
            .doutB(doutB),
            .clk(clk)
);

Memoria u2( 
     .final_address(final_address),
     .WE_mem(WE_mem),
     .dIN(doutA),
     .dout(regIN_memOUT), 
     .clk(clk)
);



endmodule

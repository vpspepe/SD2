module polirv 
    #(
        parameter i_addr_bits = 6,
        parameter d_addr_bits = 6
    ) (
        input clk, rst_n,                       // clock borda subida, reset assíncrono ativo baixo
        output [i_addr_bits-1:0] i_mem_addr,
        input  [31:0]            i_mem_data,
        output                   d_mem_we,
        output [d_addr_bits-1:0] d_mem_addr,
        inout  [63:0]            d_mem_data
    );


wire clk_atrasado;

atrasa_clk_3x1 atrasa_clk(.clk(clk),.clk_out(clk_atrasado));


//UC:
    // UC -> FD
    wire [3:0] alu_cmd;
    wire pc_src,alu_src,rf_src;
    wire d_mem_we, rf_we;
    //UC -> Memoria

//FD: 
    // FD -> UC
        wire [6:0] opcode;
        wire [3:0] alu_flags;

 fd_entrega FD(
        .clk(clk_atrasado), .rst_n(rst_n),                  
        .opcode(opcode),                    
        .d_mem_we(d_mem_we), .rf_we(rf_we),             
        .alu_cmd(alu_cmd),                
        .alu_flags(alu_flags),
        .alu_src(alu_src),                     
        .pc_src(pc_src),                       
        .rf_src(rf_src),                       
        .i_mem_addr(i_mem_addr),
        .i_mem_data(i_mem_data),
        .d_mem_addr(d_mem_addr),
        .d_mem_data(d_mem_data)
    );
           
uc UC(
     .clk(clk),
     .rst_n(rst_n),                       // clock borda subida, reset assíncrono ativo baixo
     .opcode(opcode),                     // OpCode direto do IR no FD
     .d_mem_we(d_mem_we),
     .rf_we(rf_we),                 // Habilita escrita na memória de dados e no banco de registradores
     .alu_flags(alu_flags),                 // Flags da ULA
     .alu_cmd(alu_cmd),                   // Operação da ULA
     .alu_src(alu_src), 
     .pc_src(pc_src), 
     .rf_src(rf_src)          // Seletor dos MUXes
);  

endmodule


module Memoria_tb();

reg[4:0] final_address_tb;  //endereço do reg que vair receber o load
reg WE_mem_tb;  //write enable     
reg[63:0]dIN_tb;  //data in
wire [63:0] dout_tb; //valor de leitura do Registrador R
reg clk_tb;


Memoria u1( 
    .final_address(final_address_tb),  //guarda endereço que será alterado tanto 
    .WE_mem(WE_mem_tb),
    .clk(clk_tb),
    .dIN(dIN_tb),
    .dout(dout_tb) //valor de leitura do Registrador Ra
);

initial begin
    $monitor("final_address: %d || WE_mem: %d || dIn: %d || dout: %d",final_address_tb,WE_mem_tb,dIN_tb,dout_tb);
    //STORE -> salvar na memoria 3, o registrador N (qualquer) (contém 120) -> sw xN,0(x3) ou sw xN,0(final_Address)

    final_address_tb = 0;  
    dIN_tb = 0;
    WE_mem_tb = 0;
    clk_tb = 0;

    #50

    final_address_tb = 3;  
    dIN_tb = 120;
    WE_mem_tb = 0;

    #50

    WE_mem_tb = 1;

    

//LOAD -> o que está na memória 3 será guardado no registrador N sw xN,0(final_address)

    #50
    final_address_tb = 0;

    #50
    final_address_tb = 3;  
    dIN_tb = 0;
    WE_mem_tb = 0;
end

always #10
clk_tb = ~clk_tb;

endmodule
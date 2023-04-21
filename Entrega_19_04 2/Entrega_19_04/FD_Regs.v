module FD_Regs(
    input[63:0] din,  //valor que vai ser armazenado
    input clk,
    input[63:0] OFFSET,
    input[4:0] Ra, // base da memoria
    input[4:0] Rb, //offset da memoria
    input [63:0] Din,
    input WE // write enable
);

wire [63:0] regs_outs[0:31]; // fios com as saidas dos registradores( 32 conjuntos de 64 fios)

reg [4:0] Rw,Ra,Rb; //endereco de x1
reg loads[31:0];

reg [63:0]dout_a, dout_b; // regs que guardam os valores que vao sair em dout_a e dou_b


reg x[4:0]; // endereco do registrador que sera usado

RegNbits Reg(
    .x(64'b0), 
    .clk(clk), 
    .load(loads[0]), 
    .x_out(regs_outs[0])
    ); //x0 sempre tem valor 0

genvar i;
generate //gera os 32 registadores

    for (i = 1; i < 32 ; i = i+1 ) begin

        RegNbits Regs(
                    .x(din),
                    .clk(clk), 
                    .load(loads[i]), 
                    .x_out(regs_outs[i])
                    );
    end
endgenerate

integer j;
always @(posedge clk) begin

    /*atribuição do valor ao 
    registrador rd quando WE == 1*/

    if(WE == 0) begin
        Ra <= x1;
        Rb <= x2;
        Rw <= x2;
    end


    else begin
        loads[Rw] <= 1; // apenas o registrador com o endereço rw é carregado
        for ( j = 1; j < 32 ; j = j+1 ) begin
            if (j!=Rw) begin
                loads[j] <= 0;
            end
        end 
    end

    for (j = 0; j<32 ; j = j+1 ) begin
        if(j == Ra)begin    //se o endereço de Ra for igual a "i", a saida dout_a sera o valor dentro do registrador cujo endereço é Ra
            dout_a <= regs_outs[j];
            dout <= regs_outs[j];
        end
        if(j == Rb)     //se o endereço de Rb for igual a "i", a saida dout_b sera o valor dentro do registrador cujo endereço é Rb
            dout_b <= regs_outs[j];
    end

end

endmodule



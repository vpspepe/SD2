module FD_Regs(
    input din[63:0]  //valor que vai ser armazenado
    input clk,
    input Ra[4:0], // base da memoria
    input Rb[4:0], //offset da memoria
    input Rw[4:0], //endereco de x1
    input WE, // write enable
    output dout_a[63:0], dout_b[63:0]
);
wire regs_outs[31:0][63:0]; // fios com as saidas dos registradores( 32 conjuntos de 64 fios)
reg out_a[63:0], out_b[63:0]; // regs que guardam os valores que vao sair em dout_a e dou_b
assign dout_a = out_a;
assign dout_b = out_b;
reg x[4:0] // endereco do registrador que sera usado
RegNbits Reg(.x(0), clk, .load(load[0]), .x_out(x_out[0])); //x0 sempre tem valor 0
genvar i;
generate //gera os 32 registadores

    for (i = 1; i < 32 ; i = i+1 ) begin
        RegNbits Reg(.x(din),
                .clk(clk), .load(load[i]), 
                x_out.(regs_outs[i]));
    end
endgenerate



always @(posedge clk) begin 
    /*atribuição do valor ao 
    registrador rd quando WE == 1*/
    if (WE == 1) begin
        load[Rw] <= 1; // apenas o registrador com o endereço rw é carregado
        for (i = 1; i < 32 ; i = i+1 ) begin
            if (i!=Rw) begin
                load[i] <= 0;
            end
        end 
    end

    for (i = 0; i<32 ; i = i+1 ) begin
        if(i == Ra)     //se o endereço de Ra for igual a "i", a saida dout_a sera o valor dentro do registrador cujo endereço é Ra
            out_a <= regs_outs[i][63:0];
        if(i == Rb)     //se o endereço de Rb for igual a "i", a saida dout_b sera o valor dentro do registrador cujo endereço é Rb
            out_b <= regs_outs[i][63:0];
    end
end
endmodule


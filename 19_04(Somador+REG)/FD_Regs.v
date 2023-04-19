module FD_Regs(
    input clk,
    input Ra[4:0], // o que seria o 0
    input Rb[4:0], //o que seria o 2
    input Rw[4:0], //endereco de x1
);

input din[63:0]  //valor que vai ser armazenado
reg [4:0]  address_A,address_B;
reg [63:0] doutA,doutB;
input clk;

RegNbits Reg[0](.x(0), clk, load, x_out);

genvar i;
generate //gera os 32 registadores

    for (i = 1; i < 32 ; i = i+1 ) begin
        RegNbits Reg[i](.x(x[i]),
                .clk(clk), load, 
                x_out);
    
    end
endgenerate

//ta incompleto huh?


always @(posedge clk ) begin


    
end


endmodule
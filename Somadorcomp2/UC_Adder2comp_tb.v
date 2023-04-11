`timescale 10ns/100ps
module UC_Adder2comp_tb();
reg clk_tb, S_tb, RESET_tb;
wire loadAB_tb, // load nos registradores A, B e os sinais de A e de B
    loadmagAB_tb,  //faz o laod dos valores de A e de B convertidos de complemento de 2
    compmag_tb, //compara as magnitudes de A e de B
    compsigns_tb, //Compara os sinais de A e de B
    add_sub_tb, //reliza a soma ou a subtrada
    loadres_tb, //faz o load do resultado
    done_tb; //indica que esta pronto

UC_Adder2comp UUT( .clk(clk_tb), .S(S_tb), .RESET(RESET_tb), .loadAB(loadAB_tb), .loadmagAB(loadmagAB_tb), .compmag(compmag_tb), .compsigns(compsigns_tb), .add_sub(add_sub_tb),  .loadres(loadres_tb), .done(done_tb));

initial begin
     $monitor("loadAB_tb = %d || loadmag_tb = %d || compmag_tb = %d || compsigns_tb = %d || add_sub_tb = %d || loadres_tb = %d || done_tb = %d ", loadAB_tb, loadmagAB_tb, compmag_tb,compsigns_tb,add_sub_tb, loadres_tb, done_tb);
        clk_tb = 0;
        RESET_tb = 1;
        S_tb = 1;
        #10
        RESET_tb = 0;
        #30 
        RESET_tb = 0;
        #1000
        RESET_tb = 1;
    end

always begin
    #10 clk_tb = ~clk_tb;
    
end
endmodule

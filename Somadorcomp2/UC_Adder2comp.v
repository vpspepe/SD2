module UC_Adder2comp(
    input clk, S, RESET,
    output reg loadAB, // load nos registradores A, B e os sinais de A e de B
    loadmagAB,  //faz o laod dos valores de A e de B convertidos de complemento de 2
    compmag, //compara as magnitudes de A e de B
    compsigns, //Compara os sinais de A e de B
    add_sub, //reliza a soma ou a subtrada
    loadres, //faz o load do resultado
    done //indica que esta pronto
);

reg[3:0] states;
parameter IDLE = 0, START = 1, _loadAB = 2, _loadmagAB = 3, _compmag = 4, _compsigns = 5, _add_sub = 6, _done = 7;

always @(posedge clk or posedge S or posedge RESET) begin
        if (RESET == 1)
            states <= IDLE;
        else begin
            case (states)

                IDLE: begin
                    if (S == 1)
                        states <= START;
                end

                START: begin
                    states <= _loadAB;
                end

                _loadAB: begin
                    states <= _loadmagAB;
                end

                _loadmagAB: begin
                    states <= _compmag;
                end

                _compmag: begin
                    states <= _compsigns;
                end

                _compsigns: begin
                    states <= _add_sub;
                end

                _add_sub: begin
                    states <= _done;
                end

            endcase
        end
end

always @(posedge clk) begin
    case(states)

        IDLE: begin
            loadAB <= 0;
            loadmagAB <= 0;  //faz o laod dos valores de A e de B convertidos de complemento de 2
            compmag<= 0; //compara as magnitudes de A e de B
            compsigns <= 0; //Compara os sinais de A e de B
            add_sub <= 0; //reliza a soma ou a subtrada
            loadres <= 0;
            done <= 0;
        end

        _loadAB: begin
            loadAB <= 1;
        end

        _loadmagAB: begin
            loadAB <= 0;
            loadmagAB <= 1;
        end

        _compmag: begin
            loadmagAB <= 0;
            compmag <= 1;
        end

        _compsigns: begin
            compmag <= 0;
            compsigns <= 1;
        end

        _add_sub: begin
            compsigns <= 0;
            add_sub <= 1;
        end
        
        _done: begin
            add_sub <= 0;
            done <= 1;
            loadres <=1;
        end

    endcase
    
end


endmodule
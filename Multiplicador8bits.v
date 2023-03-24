module Multiplicador8bits(
    input load_AR, load_BR, load_PR,
    input wire[7:0] mult1,
    input wire[7:0] mult2,
    input  CLK,
    input  RESET, // inicializar o estado, pois ele começa indefinido -> eles não usam no projeto deles, mas pode usar por esta implicito no registrador
    output wire[15:0] result
);

reg [7:0] AR, BR;
reg [15:0] PR;
reg [1:0] estado;

parameter IDLE = 2'b00, COMECA = 2'b01, MULT = 2'b10, VALOR = 2'b11; //valor é para demonstrar que foi para estado que mostra o resultado final
assign result = PR;
// declara a máquina de estado e transita entre seus estados, a ASM em si, seu comportamento
always @(posedge CLK or posedge RESET) 
begin
    if (RESET == 1)
        estado <= IDLE;
    else 
    begin
        case (estado)
            IDLE: 
                if (PR == 0)
                    estado <= COMECA; 
            COMECA: 
                if (AR == 0)
                    estado <= VALOR;
                else
                    estado <= MULT;
            MULT: 
                if (AR == 1)
                    estado <= VALOR;
                else
                    estado <= MULT;
            VALOR: 
                estado <= IDLE;

        endcase
    end
end

// o que ocorrerá em cada estado
always @(posedge CLK) 
begin
    case (estado)
        IDLE: 
            if (load_PR == 1) 
                PR <= 0;
        COMECA: begin
            if (load_AR == 1)
                AR <= mult1;
            if (load_BR == 1)
                BR <= mult2;
        end
        MULT: begin
            AR <= AR - 8'b1;
            PR <= PR + BR; 
        end
        
       
    endcase
end

endmodule
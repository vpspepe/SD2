module Multiplier8bit (
  input wire[7:0] IN1,
  input wire[7:0] IN2,
  input wire S,
  input wire CLK,
  input wire RESET,
  output reg F,
  output wire[15:0] M
);
  reg[15:0] PR;
  reg [7:0] AR, BR;
  reg[1:0] state;
  
  wire ZE;
  assign ZE = ~|AR;

  parameter IDLE = 2'b00,
            INICIO = 2'b01,
            SOMA = 2'b10,
            FIM = 2'b11; 

  assign M = PR;

  always @(posedge CLK or posedge RESET or ZE or S) begin
    if (RESET == 1)
      state <= IDLE;
    else begin
      case (state)
        IDLE: begin
          if (S == 1)
            state <= INICIO;
        end 
        INICIO, SOMA: begin
          if (ZE == 1)
            state <= FIM;
          else
            state <= SOMA;
        end
        FIM: begin
          state <= IDLE;
        end
     endcase
    end
  end


  always @(posedge CLK) begin
    case (state)
      IDLE: begin
        F <= 0;
      end
      INICIO: begin
        AR <= IN1;
        BR <= IN2;
        PR <= 0;
      end
      SOMA: begin
        PR <= PR + BR;
        AR <= AR - 8'b1;
      end
      FIM: begin
        F <= 1;
      end
    endcase

  end

endmodule
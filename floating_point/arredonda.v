module arredonda(
input clk,
 input normalized,
 input [7:0] exp_in,
 output reg [7:0] exp_out,
 input [28:0] fract_in,
 output reg [28:0] fract_out
);

wire [2:0] seguranca;
assign seguranca = fract_in[2:0];


always @(posedge clk) begin
    
    exp_out <= exp_in;

    if (normalized == 0) begin
        
        fract_out <= fract_in;
    end

    else begin
        if (seguranca > 5) begin
        fract_out[2:0] <= 3'b000;
        fract_out[28:3] <= fract_in[28:3] + 1;
        end

        else  if (seguranca < 5) begin
        fract_out[2:0] <= 3'b000;
        fract_out[28:3] <= fract_in[28:3];
        end

        else begin
            if(fract_in[3] == 1'b0) begin
                fract_out[2:0] <= 3'b000;
                fract_out[28:3] <= fract_in[28:3];
            end
            else begin
                fract_out[2:0] <= 3'b000;
                fract_out[28:3] <= fract_in[28:3] + 1; 
            end
        end
    end

end

endmodule

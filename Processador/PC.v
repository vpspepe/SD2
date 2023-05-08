module PC(
    input reset,
    input load,
    input [31:0] in,
    output [31:0] out
);

if reset == 1 begin
    out <= 0;
end

else begin
       if load == 1 begin
        out <= in;
       end
end

endmodule

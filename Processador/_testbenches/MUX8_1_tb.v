module MUX8_1_tb();
reg [5:0] flags_tb;
reg [2:0] select_tb;
wire flag_tb;

MUX8_1 uut(.flags(flags_tb),.select(select_tb),.flag(flag_tb));

initial begin
    $monitor("flags = %b | select = %d | flag = %d",flags_tb,select_tb,flag_tb);
    flags_tb = 010010;
    select_tb = 0;

    #20
    select_tb = 1;
    
    #20
    select_tb = 2;
    
    #20
    select_tb = 3;
    
    #20
    select_tb = 4;
    
    #20
    select_tb = 5;

    #20
    select_tb = 6;
end


endmodule
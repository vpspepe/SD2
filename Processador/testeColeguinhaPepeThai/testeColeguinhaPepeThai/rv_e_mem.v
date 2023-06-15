module rv_e_mem(
    input clk,
    input rst_n
);

// RV --> MEM
wire d_mem_we;
wire [5:0] i_mem_addr, d_mem_addr;

// RV<--> MEM
wire [63:0] d_mem_data;

// RV<-- MEM
wire[31:0] i_mem_data;


polirv RV(
    .clk(clk),
    .rst_n(rst_n),
    .i_mem_addr(i_mem_addr),
    .i_mem_data(i_mem_data),
    .d_mem_we(d_mem_we),
    .d_mem_addr(d_mem_addr),
    .d_mem_data(d_mem_data)
);

Memoria RAM_ROM(
    .i_mem_addr(i_mem_addr),
    .d_mem_addr(d_mem_addr),
    .d_mem_we(d_mem_we),
    .clk(clk),
    .i_mem_data(i_mem_data),
    .d_mem_data(d_mem_data)
);


endmodule
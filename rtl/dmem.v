module dmem (
    input clk, mem_write, mem_read,
    input [31:0] addr, wd,
    output [31:0] rd
);
    reg [31:0] mem [0:63];
    assign rd = mem[addr[7:2]];
    always @(posedge clk)
        if (mem_write) mem[addr[7:2]] <= wd;
endmodule
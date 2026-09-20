module imem (
    input [31:0] addr,
    output [31:0] instr
);
    reg [31:0] mem [0:63];
    initial $readmemh("sw/program.hex", mem);
    assign instr = mem[addr[7:2]];   // word-aligned
endmodule
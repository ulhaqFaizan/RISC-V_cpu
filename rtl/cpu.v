module cpu (input clk, reset);
    reg [31:0] pc;
    wire [31:0] instr, imm, rd1, rd2, alu_b, alu_result, mem_rd, wb_data;
    wire reg_write, alu_src, mem_write, mem_read, mem_to_reg, branch, zero;
    wire [1:0] alu_op;
    wire [3:0] alu_ctrl;

    imem IMEM(.addr(pc), .instr(instr));

    control CTRL(.opcode(instr[6:0]), .reg_write(reg_write), .alu_src(alu_src),
        .mem_write(mem_write), .mem_read(mem_read), .mem_to_reg(mem_to_reg),
        .branch(branch), .alu_op(alu_op));

    regfile RF(.clk(clk), .rs1(instr[19:15]), .rs2(instr[24:20]), .rd(instr[11:7]),
        .wd(wb_data), .we(reg_write), .rd1(rd1), .rd2(rd2));

    assign imm = {{20{instr[31]}}, instr[31:20]};      // sign-extend I-type
    assign alu_b = alu_src ? imm : rd2;

    // ALU control decode: combine alu_op with funct3/funct7 for R-type
    assign alu_ctrl = (alu_op == 2'b10) ?
        (instr[30] ? 4'b0001 : (instr[14:12]==3'b111 ? 4'b0010 :
         instr[14:12]==3'b110 ? 4'b0011 : 4'b0000)) :
        (alu_op == 2'b01) ? 4'b0001 : 4'b0000;          // BEQ subtracts

    alu ALU(.a(rd1), .b(alu_b), .alu_ctrl(alu_ctrl), .result(alu_result), .zero(zero));

    dmem DMEM(.clk(clk), .mem_write(mem_write), .mem_read(mem_read),
        .addr(alu_result), .wd(rd2), .rd(mem_rd));

    assign wb_data = mem_to_reg ? mem_rd : alu_result;

    always @(posedge clk or posedge reset) begin
        if (reset) pc <= 0;
        else if (branch && zero) pc <= pc + imm;
        else pc <= pc + 4;
    end
endmodule
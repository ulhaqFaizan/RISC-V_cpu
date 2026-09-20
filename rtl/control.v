module control (
    input  [6:0] opcode,
    output reg reg_write, alu_src, mem_write, mem_read, mem_to_reg, branch,
    output reg [1:0] alu_op
);
    always @(*) begin
        {reg_write, alu_src, mem_write, mem_read, mem_to_reg, branch, alu_op} = 0;
        case (opcode)
            7'b0110011: begin reg_write=1; alu_op=2'b10; end                     // R-type
            7'b0010011: begin reg_write=1; alu_src=1; alu_op=2'b00; end          // ADDI
            7'b0000011: begin reg_write=1; alu_src=1; mem_read=1; mem_to_reg=1; end // LW
            7'b0100011: begin alu_src=1; mem_write=1; end                        // SW
            7'b1100011: begin branch=1; alu_op=2'b01; end                       // BEQ
        endcase
    end
endmodule
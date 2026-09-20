module alu (
    input  [31:0] a, b,
    input  [3:0]  alu_ctrl,   // 0=ADD 1=SUB 2=AND 3=OR
    output reg [31:0] result,
    output zero               // used by BEQ
);
    always @(*) begin
        case (alu_ctrl)
            4'b0000: result = a + b;
            4'b0001: result = a - b;
            4'b0010: result = a & b;
            4'b0011: result = a | b;
            default: result = 32'b0;
        endcase
    end
    assign zero = (result == 32'b0);
endmodule
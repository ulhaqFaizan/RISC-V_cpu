module cpu_tb;
    reg clk = 0, reset = 1;
    cpu DUT(.clk(clk), .reset(reset));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, cpu_tb);

        #2 reset = 0;
        #200; // let the program run

        if (DUT.RF.regs[3] == 8)
            $display("PASS: x3 == 8");
        else
            $display("FAIL: x3 = %0d, expected 8", DUT.RF.regs[3]);

        if (DUT.DMEM.mem[0] == 8)
            $display("PASS: mem[0] == 8");
        else
            $display("FAIL: mem[0] = %0d, expected 8", DUT.DMEM.mem[0]);

        $finish;
    end
endmodule
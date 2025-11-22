`timescale 1ps/1ps

module Shift_Register_tb;

    reg  [7:0] i;
    reg  [1:0] s;
    reg        clk;
    reg        reset;
    reg        r;
    wire [7:0] o;

    Shift_Register UUT(
        .i(i),
        .s(s),
        .o(o),
        .clk(clk),
        .reset(reset),
        .r(r)
    );

    always #5 clk = ~clk;   // clock 10ns

    initial begin
        clk   = 0;
        reset = 1;
        s = 2'b00;
        i = 8'b00000000;
        r = 0;

        #12;
        reset = 0;

        // 1. parallel load
        i = 8'b10110011;
        s = 2'b11;
        #10; #10;

        // 2. shift right
        s = 2'b01;
        r = 1;
        #10; #10;
        r = 0;
        #10; #10;

        // 3. shift left
        s = 2'b10;
        r = 1;
        #10; #10; #10;

        // 4. hold
        s = 2'b00;
        #20;

        $finish;
    end

endmodule


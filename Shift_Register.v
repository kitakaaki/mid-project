// DFF with asynchronous active-high reset
module DFF(q, d, clk, reset);
    output q;
    input  d, clk, reset;
    reg    q;

    // asynchronous active-high reset, sample on rising clock edge
    always @(posedge clk or posedge reset)
    begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module MUX4_1(s0, s1, i0, i1, i2, i3, o);
    input  s0, s1;
    input  i0, i1, i2, i3;
    output o;

    assign o =
        (~s1 & ~s0 & i0) |
        (~s1 &  s0 & i1) |
        ( s1 & ~s0 & i2) |
        ( s1 &  s0 & i3);

endmodule


module Shift_Register(i, s, o, clk, reset, r);
    input  [7:0] i;      // parallel input
    input  [1:0] s;      // control (00 hold, 01 right, 10 left, 11 load)
    input        clk, reset;
    input        r;      // serial input
    output [7:0] o;

    // 每一個 bit 的輸出（DFF 的 q）
    wire q0, q1, q2, q3, q4, q5, q6, q7;
    // 每一個 bit 的下一狀態（DFF 的 d）
    wire d0, d1, d2, d3, d4, d5, d6, d7;

    assign o = {q7, q6, q5, q4, q3, q2, q1, q0};

    // ---------------- bit 0 ----------------
    // hold = q0
    // right shift 時，q0 ← q1
    // left  shift 時，q0 ← r   (LSB 從 r 進來)
    // load = i[0]
    MUX4_1 MUX0(
        .s0(s[0]), .s1(s[1]),
        .i0(q0),      // hold
        .i1(q1),      // shift right
        .i2(r),       // shift left
        .i3(i[0]),    // parallel load
        .o(d0)
    );

    DFF FF0(
        .q(q0),
        .d(d0),
        .clk(clk),
        .reset(reset)
    );

    // ---------------- bit 1 ----------------
    // hold = q1
    // right: q1 ← q2
    // left : q1 ← q0
    // load : i[1]
    MUX4_1 MUX1(
        .s0(s[0]), .s1(s[1]),
        .i0(q1),
        .i1(q2),
        .i2(q0),
        .i3(i[1]),
        .o(d1)
    );

    DFF FF1(
        .q(q1),
        .d(d1),
        .clk(clk),
        .reset(reset)
    );

    // ---------------- bit 2 ----------------
    MUX4_1 MUX2(
        .s0(s[0]), .s1(s[1]),
        .i0(q2),
        .i1(q3),
        .i2(q1),
        .i3(i[2]),
        .o(d2)
    );

    DFF FF2(
        .q(q2),
        .d(d2),
        .clk(clk),
        .reset(reset)
    );

    // ---------------- bit 3 ----------------
    MUX4_1 MUX3(
        .s0(s[0]), .s1(s[1]),
        .i0(q3),
        .i1(q4),
        .i2(q2),
        .i3(i[3]),
        .o(d3)
    );

    DFF FF3(
        .q(q3),
        .d(d3),
        .clk(clk),
        .reset(reset)
    );

    // ---------------- bit 4 ----------------
    MUX4_1 MUX4(
        .s0(s[0]), .s1(s[1]),
        .i0(q4),
        .i1(q5),
        .i2(q3),
        .i3(i[4]),
        .o(d4)
    );

    DFF FF4(
        .q(q4),
        .d(d4),
        .clk(clk),
        .reset(reset)
    );

    // ---------------- bit 5 ----------------
    MUX4_1 MUX5(
        .s0(s[0]), .s1(s[1]),
        .i0(q5),
        .i1(q6),
        .i2(q4),
        .i3(i[5]),
        .o(d5)
    );

    DFF FF5(
        .q(q5),
        .d(d5),
        .clk(clk),
        .reset(reset)
    );

    // ---------------- bit 6 ----------------
    MUX4_1 MUX6(
        .s0(s[0]), .s1(s[1]),
        .i0(q6),
        .i1(q7),
        .i2(q5),
        .i3(i[6]),
        .o(d6)
    );

    DFF FF6(
        .q(q6),
        .d(d6),
        .clk(clk),
        .reset(reset)
    );

    // ---------------- bit 7 ----------------
    // MSB：
    // right: q7 ← r   (右移時，MSB 從 r 進來)
    // left : q7 ← q6
    MUX4_1 MUX7(
        .s0(s[0]), .s1(s[1]),
        .i0(q7),
        .i1(r),
        .i2(q6),
        .i3(i[7]),
        .o(d7)
    );

    DFF FF7(
        .q(q7),
        .d(d7),
        .clk(clk),
        .reset(reset)
    );

endmodule

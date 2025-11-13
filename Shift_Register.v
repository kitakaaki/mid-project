// DFF with asynchronous active-high reset
module DFF(q, d, clk, reset);
    output q;
    input  d, clk, reset;
    reg    q;

    // asynchronous active-high reset, sample on rising clock edge
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

// 4-to-1 MUX implemented using assign (combinational)
module MUX4_1(s0, s1, i0, i1, i2, i3, o);
    input  s0, s1;
    input  i0, i1, i2, i3;
    output o;
    wire   o;

    // truth-table style assign (uses assign as required)
    assign o = (~s1 & ~s0 & i0) |
               (~s1 &  s0 & i1) |
               ( s1 & ~s0 & i2) |
               ( s1 &  s0 & i3);
endmodule

// 8-bit bidirectional shift register
// Port order must match the provided template: (i, s, o, clk, reset, r)
module Shift_Register(i, s, o, clk, reset, r);
    input  [7:0] i;      // parallel inputs
    input  [1:0] s;      // mode select
    input        clk;
    input        reset;  // async active-high reset
    input        r;      // serial input (used for both shifts as described)
    output [7:0] o;      // outputs
    wire   [7:0] o;      // driven by DFF outputs

    // wires for D inputs to each DFF
    wire d0, d1, d2, d3, d4, d5, d6, d7;

    // For each bit we create a 4:1 MUX selecting next D input:
    // select mapping:
    // s == 00 -> hold (current q)
    // s == 01 -> left shift  (q[j] <- q[j-1]; j=0 gets serial 'r')
    // s == 10 -> right shift (q[j] <- q[j+1]; j=7 gets serial 'r')
    // s == 11 -> parallel load i[j]
    //
    // We'll implement each MUX input ordering (i0..i3) as:
    //    i0 = hold
    //    i1 = left-shift-source
    //    i2 = right-shift-source
    //    i3 = parallel-load (i[j])
    //
    // Then MUX4_1(s0 = s[0], s1 = s[1], i0,i1,i2,i3,o) matches assign mapping.

    // bit 0
    wire hold0 = o[0];
    wire left_src0 = r;          // for j=0 left-source is serial input r
    wire right_src0 = o[1];
    MUX4_1 mux0(.s0(s[0]), .s1(s[1]), .i0(hold0), .i1(left_src0), .i2(right_src0), .i3(i[0]), .o(d0));
    DFF  dff0(.q(o[0]), .d(d0), .clk(clk), .reset(reset));

    // bit 1
    wire hold1 = o[1];
    wire left_src1 = o[0];
    wire right_src1 = o[2];
    MUX4_1 mux1(.s0(s[0]), .s1(s[1]), .i0(hold1), .i1(left_src1), .i2(right_src1), .i3(i[1]), .o(d1));
    DFF  dff1(.q(o[1]), .d(d1), .clk(clk), .reset(reset));

    // bit 2
    wire hold2 = o[2];
    wire left_src2 = o[1];
    wire right_src2 = o[3];
    MUX4_1 mux2(.s0(s[0]), .s1(s[1]), .i0(hold2), .i1(left_src2), .i2(right_src2), .i3(i[2]), .o(d2));
    DFF  dff2(.q(o[2]), .d(d2), .clk(clk), .reset(reset));

    // bit 3
    wire hold3 = o[3];
    wire left_src3 = o[2];
    wire right_src3 = o[4];
    MUX4_1 mux3(.s0(s[0]), .s1(s[1]), .i0(hold3), .i1(left_src3), .i2(right_src3), .i3(i[3]), .o(d3));
    DFF  dff3(.q(o[3]), .d(d3), .clk(clk), .reset(reset));

    // bit 4
    wire hold4 = o[4];
    wire left_src4 = o[3];
    wire right_src4 = o[5];
    MUX4_1 mux4(.s0(s[0]), .s1(s[1]), .i0(hold4), .i1(left_src4), .i2(right_src4), .i3(i[4]), .o(d4));
    DFF  dff4(.q(o[4]), .d(d4), .clk(clk), .reset(reset));

    // bit 5
    wire hold5 = o[5];
    wire left_src5 = o[4];
    wire right_src5 = o[6];
    MUX4_1 mux5(.s0(s[0]), .s1(s[1]), .i0(hold5), .i1(left_src5), .i2(right_src5), .i3(i[5]), .o(d5));
    DFF  dff5(.q(o[5]), .d(d5), .clk(clk), .reset(reset));

    // bit 6
    wire hold6 = o[6];
    wire left_src6 = o[5];
    wire right_src6 = o[7];
    MUX4_1 mux6(.s0(s[0]), .s1(s[1]), .i0(hold6), .i1(left_src6), .i2(right_src6), .i3(i[6]), .o(d6));
    DFF  dff6(.q(o[6]), .d(d6), .clk(clk), .reset(reset));

    // bit 7 (MSB)
    wire hold7 = o[7];
    wire left_src7 = o[6];
    wire right_src7 = r;         // for j=7 right-source is serial input r
    MUX4_1 mux7(.s0(s[0]), .s1(s[1]), .i0(hold7), .i1(left_src7), .i2(right_src7), .i3(i[7]), .o(d7));
    DFF  dff7(.q(o[7]), .d(d7), .clk(clk), .reset(reset));

endmodule

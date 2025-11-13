module DFF(q, d, clk, reset);
    output q;
    input d, clk, reset;
    reg q;

    always @(posedge reset or negedge clk) 
        if (reset)
            q = 1'b0;
        else
            q = d;
endmodule

module MUX4_1(s0, s1, i0, i1, i2, i3, 0);
//-----------------------------------------
//Declare input, output port
//Declare parameter type (wire or reg)

//-----------------------------------------
//Design your program by using assignment
//e.g. assign o = i & s; ......
endmodule

module Shift_Register(i, s, o, clk, reset, r);
//-----------------------------------------
//Declare input, output port
//Declare parameter type (wire or reg)
endmodule

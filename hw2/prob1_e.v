// prob1_e.v

`timescale 10ps/1ps
`celldefine
module prob1_e(
    a,
    b,
    c,
    d,
    e
);
    input [11:0]    a;
    input [11:0]    b;
    input [11:0]    c;
    output [11:0]   d;
    output [11:0]   e;
    assign d = a ^ b ^ c;
    assign e = (a & b) | (a & c) | (b & c);
endmodule
`endcelldefine

// prob1_b.v

`timescale 10ps/1ps
`celldefine
module prob1_b(
    a,
    b,
    c,
    d,
    e
);
    input   a;
    input   b;
    input   c;
    output  d;
    output  e;
    assign d = a ^ b ^ c;
    assign e = (a & b) | (a & c) | (b & c);
endmodule
`endcelldefine

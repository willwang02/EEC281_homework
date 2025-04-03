// prob1_a.v

`timescale 10ps/1ps
`celldefine
module prob1_a(
    a,
    b,
    c
);
    input [11:0]    a;
    input [11:0]    b;
    output [11:0]   c;
    assign c = ~(a | b);
endmodule
`endcelldefine
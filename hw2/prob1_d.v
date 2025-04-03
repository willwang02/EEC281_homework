// prob1_d.v

`timescale 10ps/1ps
`celldefine
module prob1_d(
    a,
    b,
    c
);
    input [11:0]    a;
    input [11:0]    b;
    output [12:0]   c;
    assign c = a + b;
endmodule
`endcelldefine

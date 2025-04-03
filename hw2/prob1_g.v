// prob1_g.v

`timescale 10ps/1ps
`celldefine
module prob1_g(
    a,
    b,
    c,
);
    input [15:0]    a;
    input [15:0]    b;
    output [31:0]   c;
    assign c = a * b;
endmodule
`endcelldefine

// prob1_f.v

`timescale 10ps/1ps
`celldefine
module prob1_f(
    a,
    b,
    c,
);
    input [7:0]    a;
    input [7:0]    b;
    output [15:0]   c;
    assign c = a * b;
endmodule
`endcelldefine

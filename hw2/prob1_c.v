// prob1_c.v

`timescale 10ps/1ps
`celldefine
module prob1_c(
    a,
    b,
    c,
    d,
    e
);
    input       a;
    input       b;
    input       c;
    output      d;
    output      e;
    wire [1:0]  sum;
    assign sum = a + b + c;
    assign d = sum[0];
    assign e = sum[1];
endmodule
`endcelldefine

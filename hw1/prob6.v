`timescale 10ps/1ps

module prob6(
    a,
    b,
    c,
    d,
    e,
    f,
    g
);
    input [3:0]     a;
    input [3:0]     b;
    input [3:0]     c;
    input [3:0]     d;
    input [3:0]     e;
    input [3:0]     f;

    output [5:0]    g;

    wire [4:0]      e1, f1, e2, f2;
    wire [5:0]      e3, f3;
    threetwo4_new _threetwo4_new_1(
        .a(a),
        .b(b),
        .c(c),
        .e(e1),
        .f(f1)
    );

    threetwo4_new _threetwo4_new_2(
        .a(d),
        .b(e),
        .c(f),
        .e(e2),
        .f(f2)
    );

    fourtwo4 _fourtwo4(
        .a(e1),
        .b(f1),
        .c(e2),
        .d(f2),
        .e(e3),
        .f(f3)
    );
    assign g = e3 + f3;
endmodule

module fourtwo4(
    a,
    b,
    c,
    d,
    e,
    f
);
    // input interface
    input  [4:0]        a;
    input  [4:0]        b;
    input  [4:0]        c;
    input  [4:0]        d;

    // output interface
    output [5:0]        e;
    output [5:0]        f;

    wire  [5:0]        co;      // intermediate "sideways" carry wires

    assign f[0] = 0;
    fourtwo num00 (.a(a[0]),  .b(b[0]),  .c(c[0]),  .d(d[0]),  .ci(0),   .co(co[0]),  .c1(f[1]),  .s(e[0]));
    fourtwo num01 (.a(a[1]),  .b(b[1]),  .c(c[1]),  .d(d[1]),  .ci(co[0]),  .co(co[1]),  .c1(f[2]),  .s(e[1]));
    fourtwo num02 (.a(a[2]),  .b(b[2]),  .c(c[2]),  .d(d[2]),  .ci(co[1]),  .co(co[2]),  .c1(f[3]),  .s(e[2]));
    fourtwo num03 (.a(a[3]),  .b(b[3]),  .c(c[3]),  .d(d[3]),  .ci(co[2]),  .co(co[3]),  .c1(f[4]),  .s(e[3]));
    fourtwo num04 (.a(a[4]),  .b(b[4]),  .c(c[4]),  .d(d[4]),  .ci(co[3]),  .co(co[4]),  .c1(f[5]),  .s(e[4]));
    fourtwo num05 (.a(a[4]==1),  .b(b[4]==1),  .c(c[4]==1),  .d(d[4]==1),  .ci(co[4]),  .co(co[5]),  .c1(),  .s(e[5]));
endmodule
module threetwo4_new(
    a, 
    b, 
    c, 
    e, 
    f 
);
    // input interface
    input  [3:0]        a;
    input  [3:0]        b;
    input  [3:0]        c;

    // output interface
    output [4:0]        e;
    output [4:0]        f;

    assign f[0] = 0;
    threetwo num00 (.a(a[0]),  .b(b[0]),  .c(c[0]),  .e(e[0]),  .f(f[1]));
    threetwo num01 (.a(a[1]),  .b(b[1]),  .c(c[1]),  .e(e[1]),  .f(f[2]));
    threetwo num02 (.a(a[2]),  .b(b[2]),  .c(c[2]),  .e(e[2]),  .f(f[3]));
    threetwo num03 (.a(a[3]),  .b(b[3]),  .c(c[3]),  .e(e[3]),  .f(f[4]));
    threetwo num04 (.a(a[3] == 1),  .b(b[3] == 1),  .c(c[3] == 1),  .e(e[4]),  .f());
endmodule
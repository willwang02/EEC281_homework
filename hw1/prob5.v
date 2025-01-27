`timescale 10ps/1ps

module fourtwo(
    a,
    b,
    c,
    d,
    ci,
    co,
    c1,
    s
    );

    input   a;
    input   b;
    input   c;
    input   d;
    input   ci;

    output  co;
    output  c1;
    output  s;

    wire    co1;
    wire    s1;
    FA fa1(
        .a(a),
        .b(b),
        .c(c),
        .co(co),
        .s(s1)
    );
    FA fa2(
        .a(s1),
        .b(d),
        .c(ci),
        .co(c1),
        .s(s)
    );
endmodule

module FA(
    a,
    b,
    c,
    co,
    s
);
    input   a;
    input   b;
    input   c;

    output  co;
    output  s;

    assign s = a ^ b ^ c;
    assign co = (a & b) | (a & c) | (b & c);
endmodule
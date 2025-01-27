`timescale 10ps/1ps

module threetwo (
    a,
    b,
    c,
    e,
    f
);
    input  a;
    input  b;
    input  c;
    output e;
    output f;
    assign e = a ^ b ^ c;
    assign f = (a & b) | (b & c) | (a & c);

endmodule

module threetwo4(
    a, 
    b, 
    c,
    e,
    f
    );

    // input interface
    input [3:0]     a;
    input [3:0]     b;
    input [3:0]     c;
    // output interface
    output [4:0]    e;
    output [4:0]    f;

    reg [3:0]      _b;

    //----- main

    threetwo num00 (.a(a[0]),  .b(0),  .c(0),  .e(e[0]),  .f(f[0]));
    threetwo num01 (.a(a[1]),  .b(_b[0]),  .c(c[0]),  .e(e[1]),  .f(f[1]));
    threetwo num02 (.a(a[2]),  .b(_b[1]),  .c(c[1]),  .e(e[2]),  .f(f[2]));
    threetwo num03 (.a(a[3]),  .b(_b[2]),  .c(c[2]),  .e(e[3]),  .f(f[3]));
    threetwo num04 (.a(0),  .b(_b[3]),  .c(c[3]),  .e(e[4]),  .f(f[4]));

    always @(*) begin
        if (b[3] == 1'b1) begin
            _b = ~{1'b0, b[2:0]} + 1'b1;
        end
        else begin
            _b = b;
        end
        // $write("b: %b ", b);
        // $write("_b: %b\n", _b);
    end
endmodule

module prob1(
    a, 
    b, 
    c,
    d
    );

    // input interface
    input [3:0]     a;
    input [3:0]     b;
    input [3:0]     c;
    // output interface
    output [5:0]    d;

    wire [4:0]       e;
    wire [4:0]       f;
    //----- main
    threetwo4 _threetwo4(
        .a(a),
        .b(b),
        .c(c),
        .e(e),
        .f(f)
    );
    assign d = e + {f, 1'b0}; 
endmodule

// prob3.v

`timescale 10ps/1ps
`celldefine
module prob3(
    clk,
    a,
    b,
    c
);
    input           clk;
    input [11:0]    a;
    input [11:0]    b;
    output reg [11:0]   c;
    reg [11:0]      a_reg;
    reg [11:0]      b_reg;
    wire [11:0]      sum;
    wire [5:0]       sum0, sum1;
    wire            cout;
    ripple_carry_adder_6 rca0(.a(a_reg[5:0]), .b(b_reg[5:0]), .c(sum[5:0]), .cin(1'b0), .cout(cout));
    
    ripple_carry_adder_6 rca1(.a(a_reg[11:6]), .b(b_reg[11:6]), .c(sum0), .cin(1'b0), .cout());
    ripple_carry_adder_6 rca2(.a(a_reg[11:6]), .b(b_reg[11:6]), .c(sum1), .cin(1'b1), .cout());

    assign sum[11:6] = (cout == 1'b0) ? sum0 : sum1;

    always @(posedge clk) begin
        a_reg <= #1 a;
        b_reg <= #1 b;
        c <= #1 sum;
        // $display("%d", sum0);
    end
endmodule
`endcelldefine

`celldefine
module ripple_carry_adder_6(
    a,
    b,
    c,
    cin,
    cout
);
    input [5:0]     a;
    input [5:0]     b;
    input           cin;
    output [5:0]    c;
    output          cout;
    wire [5:0]     carry;
    prob1_c u0(.a(a[0]), .b(b[0]), .c(cin), .d(c[0]), .e(carry[0]));
    prob1_c u1(.a(a[1]), .b(b[1]), .c(carry[0]), .d(c[1]), .e(carry[1]));
    prob1_c u2(.a(a[2]), .b(b[2]), .c(carry[1]), .d(c[2]), .e(carry[2]));
    prob1_c u3(.a(a[3]), .b(b[3]), .c(carry[2]), .d(c[3]), .e(carry[3]));
    prob1_c u4(.a(a[4]), .b(b[4]), .c(carry[3]), .d(c[4]), .e(carry[4]));
    prob1_c u5(.a(a[5]), .b(b[5]), .c(carry[4]), .d(c[5]), .e(cout));
endmodule
`endcelldefine
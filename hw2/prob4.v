// prob4.v

`timescale 10ps/1ps
`celldefine
module prob4(
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

    wire [3:0]      cout;
    ripple_carry_adder_4 rca0(.a(a_reg[3:0]), .b(b_reg[3:0]), .c(sum[3:0]), .cin(1'b0), .cout(cout[0]));
    genvar i;
    generate
        for(i = 1; i < 3; i = i + 1)begin
            wire [3:0]       sum0, sum1;
            wire            cout0, cout1;
            ripple_carry_adder_4 rca1(.a(a_reg[i * 4+:4]), .b(b_reg[i * 4+:4]), .c(sum0), .cin(1'b0), .cout(cout0));
            ripple_carry_adder_4 rca2(.a(a_reg[i * 4+:4]), .b(b_reg[i * 4+:4]), .c(sum1), .cin(1'b1), .cout(cout1));
            assign sum[i * 4+:4] = (cout[i-1] == 1'b0) ? sum0 : sum1;
            assign cout[i] = (cout[i-1] == 1'b0) ? cout0 : cout1;
        end
    endgenerate
    

    always @(posedge clk) begin
        a_reg <= #1 a;
        b_reg <= #1 b;
        c <= #1 sum;
    end
endmodule
`endcelldefine

`celldefine
module ripple_carry_adder_4(
    a,
    b,
    c,
    cin,
    cout
);
    input [3:0]     a;
    input [3:0]     b;
    input           cin;
    output [3:0]    c;
    output          cout;
    wire [3:0]     carry;
    prob1_c u0(.a(a[0]), .b(b[0]), .c(cin), .d(c[0]), .e(carry[0]));
    prob1_c u1(.a(a[1]), .b(b[1]), .c(carry[0]), .d(c[1]), .e(carry[1]));
    prob1_c u2(.a(a[2]), .b(b[2]), .c(carry[1]), .d(c[2]), .e(carry[2]));
    prob1_c u3(.a(a[3]), .b(b[3]), .c(carry[2]), .d(c[3]), .e(cout));
endmodule
`endcelldefine
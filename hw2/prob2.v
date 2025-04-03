// prob2.v

`timescale 10ps/1ps
`celldefine
module prob2(
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
    wire [11:0]     carry;
    wire [11:0]     sum;
    integer i;
    prob1_c u0(.a(a_reg[0]), .b(b_reg[0]), .c(1'b0), .d(sum[0]), .e(carry[0]));
    prob1_c u1(.a(a_reg[1]), .b(b_reg[1]), .c(carry[0]), .d(sum[1]), .e(carry[1]));
    prob1_c u2(.a(a_reg[2]), .b(b_reg[2]), .c(carry[1]), .d(sum[2]), .e(carry[2]));
    prob1_c u3(.a(a_reg[3]), .b(b_reg[3]), .c(carry[2]), .d(sum[3]), .e(carry[3]));
    prob1_c u4(.a(a_reg[4]), .b(b_reg[4]), .c(carry[3]), .d(sum[4]), .e(carry[4]));
    prob1_c u5(.a(a_reg[5]), .b(b_reg[5]), .c(carry[4]), .d(sum[5]), .e(carry[5]));
    prob1_c u6(.a(a_reg[6]), .b(b_reg[6]), .c(carry[5]), .d(sum[6]), .e(carry[6]));
    prob1_c u7(.a(a_reg[7]), .b(b_reg[7]), .c(carry[6]), .d(sum[7]), .e(carry[7]));
    prob1_c u8(.a(a_reg[8]), .b(b_reg[8]), .c(carry[7]), .d(sum[8]), .e(carry[8]));
    prob1_c u9(.a(a_reg[9]), .b(b_reg[9]), .c(carry[8]), .d(sum[9]), .e(carry[9]));
    prob1_c u10(.a(a_reg[10]), .b(b_reg[10]), .c(carry[9]), .d(sum[10]), .e(carry[10]));
    prob1_c u11(.a(a_reg[11]), .b(b_reg[11]), .c(carry[10]), .d(sum[11]), .e(carry[11]));

    always @(posedge clk) begin
        a_reg <= #1 a;
        b_reg <= #1 b;
        c <= #1 sum;
    end
endmodule
`endcelldefine

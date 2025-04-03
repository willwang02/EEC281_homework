// prob5.v

`timescale 10ps/1ps
`celldefine
module prob5(
    clk,
    a,
    b,
    c
);
    input           clk;
    input [11:0]    a;
    input [11:0]    b;
    output reg [11:0]   c;
    reg [11:0]      stage1_a_r;
    reg [7:0]       stage2_a_r;
    reg [3:0]       stage3_a_r;
    reg [11:0]      stage1_b_r;
    reg [7:0]       stage2_b_r;
    reg [3:0]       stage3_b_r;
    wire [3:0]      stage1_carry, stage2_carry, stage3_carry;
    reg             stage1_carry_r, stage2_carry_r;
    wire [3:0]      stage1_sum, stage2_sum, stage3_sum;
    reg [3:0]       stage1_sum_r;
    reg [7:0]       stage2_sum_r;

    prob1_c u0(.a(stage1_a_r[0]), .b(stage1_b_r[0]), .c(1'b0), .d(stage1_sum[0]), .e(stage1_carry[0]));
    prob1_c u1(.a(stage1_a_r[1]), .b(stage1_b_r[1]), .c(stage1_carry[0]), .d(stage1_sum[1]), .e(stage1_carry[1]));
    prob1_c u2(.a(stage1_a_r[2]), .b(stage1_b_r[2]), .c(stage1_carry[1]), .d(stage1_sum[2]), .e(stage1_carry[2]));
    prob1_c u3(.a(stage1_a_r[3]), .b(stage1_b_r[3]), .c(stage1_carry[2]), .d(stage1_sum[3]), .e(stage1_carry[3]));

    always @(posedge clk) begin
        stage1_a_r <= #1 a[11:0];
        stage1_b_r <= #1 b[11:0];

        stage1_carry_r <= #1 stage1_carry[3];
        stage1_sum_r <= #1 stage1_sum;
        stage2_a_r <= #1 stage1_a_r[11:4];
        stage2_b_r <= #1 stage1_b_r[11:4];
        // $display("%b, %d, sum_r: %b, stage2_b_r:%b", stage1_a_r, stage1_a_r, stage1_sum_r, stage2_b_r);
    end

    prob1_c u4(.a(stage2_a_r[0]), .b(stage2_b_r[0]), .c(stage1_carry_r), .d(stage2_sum[0]), .e(stage2_carry[0]));
    prob1_c u5(.a(stage2_a_r[1]), .b(stage2_b_r[1]), .c(stage2_carry[0]), .d(stage2_sum[1]), .e(stage2_carry[1]));
    prob1_c u6(.a(stage2_a_r[2]), .b(stage2_b_r[2]), .c(stage2_carry[1]), .d(stage2_sum[2]), .e(stage2_carry[2]));
    prob1_c u7(.a(stage2_a_r[3]), .b(stage2_b_r[3]), .c(stage2_carry[2]), .d(stage2_sum[3]), .e(stage2_carry[3]));

    always @(posedge clk) begin
        
        stage2_carry_r <= #1 stage2_carry[3];
        stage2_sum_r <= #1 {stage2_sum, stage1_sum_r};
        stage3_a_r <= #1 stage2_a_r[7:4];
        stage3_b_r <= #1 stage2_b_r[7:4];
        // $display("%b, sum_r: %b", stage2_a_r, stage2_sum_r);
    end

    prob1_c u8(.a(stage3_a_r[0]), .b(stage3_b_r[0]), .c(stage2_carry_r), .d(stage3_sum[0]), .e(stage3_carry[0]));
    prob1_c u9(.a(stage3_a_r[1]), .b(stage3_b_r[1]), .c(stage3_carry[0]), .d(stage3_sum[1]), .e(stage3_carry[1]));
    prob1_c u10(.a(stage3_a_r[2]), .b(stage3_b_r[2]), .c(stage3_carry[1]), .d(stage3_sum[2]), .e(stage3_carry[2]));
    prob1_c u11(.a(stage3_a_r[3]), .b(stage3_b_r[3]), .c(stage3_carry[2]), .d(stage3_sum[3]), .e(stage3_carry[3]));

    always @(posedge clk) begin
        
        c <= #1 {stage3_sum, stage2_sum_r};
        // $display("%b", stage3_a_r);
    end
endmodule
`endcelldefine

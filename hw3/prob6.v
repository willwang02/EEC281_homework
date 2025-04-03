// prob6.v

`timescale 10ps/1ps
`celldefine
module prob6(
    clk,
    a_r,
    a_i,
    b_r,
    b_i,
    p_r,
    p_i
);
    input               clk;
    input [3:0]         a_r, a_i;
    input [3:0]         b_r, b_i;
    output reg [8:0]    p_r, p_i;
    reg [3:0]           a_r_r, a_i_r, b_r_r, b_i_r;
    wire [8:0]          p_r_c, p_i_c;

    assign p_r_c = {{5{a_r_r[3]}}, a_r_r} * {{5{b_r_r[3]}}, b_r_r} - {{5{a_i_r[3]}}, a_i_r} * {{5{b_i_r[3]}}, b_i_r};
    assign p_i_c = {{5{a_r_r[3]}}, a_r_r} * {{5{b_i_r[3]}}, b_i_r} + {{5{a_i_r[3]}}, b_i_r} * {{5{b_r_r[3]}}, b_r_r};
    always @(posedge clk) begin
        a_r_r <= #1 a_r;
        a_i_r <= #1 a_i;
        b_r_r <= #1 b_r;
        b_i_r <= #1 b_i;
        p_r <= #1 p_r_c;
        p_i <= #1 p_i_c;
    end
endmodule
`endcelldefine
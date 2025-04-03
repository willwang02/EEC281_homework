// prob7.v

`timescale 10ps/1ps
`celldefine
module prob7(
    clk,
    a,
    b
);
    input  clk, a;
    reg    a_r, b_r;
    output b;
    always @(posedge clk) begin
        a_r <= a;
        b_r <= a_r;
    end
    assign b = b_r;
endmodule
`endcelldefine


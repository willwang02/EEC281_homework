// prob5.v

`timescale 10ps/1ps
`celldefine
module prob5(
    a,
    b,
    c
);
    input [3:0]    a;
    input [3:0]    b;
    output reg [3:0]   c;
    wire [7:0]      c_pre;

    assign c_pre = {{4{a[3]}}, a} * {{4{b[3]}}, b} + {1'b1,{3{1'b0}}};
    always @(*) begin
        c = c_pre[7 : 4];
        // $display("%d", c);
    end
endmodule
`endcelldefine
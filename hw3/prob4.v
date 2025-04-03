// prob4.v

`timescale 10ps/1ps
`celldefine
module prob4(
    a,
    b,
    c
);
    input [3:0]    a;
    input [3:0]    b;
    output reg [5:0]   c;
    wire [7:0]      c_pre;

    assign c_pre = {{4{a[3]}}, a} * {{4{b[3]}}, b};
    always @(*) begin
        // $display("%d %d %d", {{4{a[3]}}, a}, {{4{b[3]}}, b}, $signed(c_pre));
        if(c_pre[7 : 5] == 3'b000 || c_pre[7 : 5] == 3'b111)
            c = c_pre[5 : 0];
        else if(c_pre[7] == 1'b0)
            c = 6'b011111;
        else
            c = 6'b100000;
        // $display("%d", c);
    end
endmodule
`endcelldefine
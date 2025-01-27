`timescale 10ps/1ps
`celldefine
module CPA (
    a, 
    b, 
    c
    );

    // input interface
    input [4:0]     a;
    input [4:0]     b;
    // output interface
    output [5:0]     c;
    
    reg [3:0]       i;
    reg [5:0]       carry;
    //----- main
    for (i = 0;i < 5;i = i + 1)begin
        assign c[i] = a[i] ^ b[i] ^ carry[i];
        assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
    end
    assign c[5] = carry[5];
endmodule
`endcelldefine


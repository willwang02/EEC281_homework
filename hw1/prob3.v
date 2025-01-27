`timescale 10ps/1ps

module prob3(
    in,
    mantissa,
    exp
    );

    input [6:0]         in;

    output reg [3:0]    mantissa;
    output reg [2:0]    exp;
    reg [9:0]           tmp;
    integer i;

    always @(*) begin
        i = 9;
        // $write("in: %d\n", in);
        tmp = in <<< 3;
        // $write("in: %d\n", in);
        while(i > 0 && tmp[i - 1] == tmp[i])
            i = i - 1;
        exp = i - 7;
        mantissa = tmp[i -: 4];
        // $write("i: %d\n", i);
    end

endmodule

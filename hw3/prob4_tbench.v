// prob4_tbench.v
`timescale 10ps/1ps
module prob4_tbench;
    reg [3:0]  a;
    reg [3:0]  b;
    wire [5:0] c;
    integer i, seed;
    prob4 _prob4(.a(a), .b(b), .c(c));
    initial begin
        #500;
        #10 a = 4'b0000; b = 4'b0000;
        #10 a = 4'b1111; b = 4'b0001;
        #10 a = 4'b1000; b = 4'b0111;
        #10 a = 4'b0111; b = 4'b0111;
        #10 a = 4'b1000; b = 4'b1000;
        #10 a = 4'b0010; b = 4'b0100;
        #10 a = 4'b0010; b = 4'b1000;
        #10 a = 4'b0110; b = 4'b0011;
        #10 a = 4'b1100; b = 4'b0011;
        #10 a = 4'b1100; b = 4'b0101;
        #10 a = 4'b1010; b = 4'b0101;
        #10 a = 4'b1110; b = 4'b0001;
        #10 a = 4'b1110; b = 4'b0010;
        #10 a = 4'b1110; b = 4'b0100;
        #10 a = 4'b0101; b = 4'b0101;
        #100
        $finish;
    end

    initial begin
        $monitor("Time: %0t | a = %0d, b = %0d, out_hw = %0d)",
                    $time, $signed(a), $signed(b), $signed(c));
    end

endmodule
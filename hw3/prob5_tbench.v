// prob5_tbench.v
`timescale 10ps/1ps
module prob5_tbench;
    reg [3:0]  a;
    reg [3:0]  b;
    wire [3:0] c;
    integer i, seed;
    prob5 _prob5(.a(a), .b(b), .c(c));
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
        $monitor("Time: %0t | a = %2.2f, b = %2.2f, out_hw = %0d)",
                    $time, $signed(a) / 4.0, $signed(b) / 4.0, $signed(c));
    end

endmodule
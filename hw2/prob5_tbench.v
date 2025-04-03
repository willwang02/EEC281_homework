// prob5_tbench.v
`timescale 10ps/1ps
module prob5_tbench;
    reg         clk;
    reg         reset;
    reg [11:0]  a;
    reg [11:0]  b;
    wire [11:0] c;
    reg [11:0] a_old1, a_old2, a_old3;
    reg [11:0] b_old1, b_old2, b_old3;
    integer i, seed;
    prob5 _prob5(.clk(clk), .a(a), .b(b), .c(c));
    initial begin
        reset = 1'b1;
        seed = 5;
        #500;
        reset = 1'b0;
        @(posedge clk); #10
        for (i = 0; i < 15; i = i + 1) begin
            a = $random(seed) % 4096;
            b = $random(seed) % 4096;
            @(posedge clk); #10
            if(i - 2 > 0)begin
                if (c == a_old3 + b_old3)
                    $display("Time: %0t | Test %0d: a = %0d, b = %0d, out_hw = %0d, out_ref = %0d, correct)",
                            $time, i-2, a_old3, b_old3, c, a_old3 + b_old3);
                else
                    $display("Time: %0t | Test %0d: a = %0d, b = %0d, out_hw = %0d, out_ref = %0d, wrong)",
                            $time, i-2, a_old3, b_old3, c, a_old3 + b_old3);
            end
            a_old3 = a_old2;
            b_old3 = b_old2;
            a_old2 = a_old1;
            b_old2 = b_old1;
            a_old1 = a;
            b_old1 = b;
        end
        @(posedge clk); #10
        if (c == a_old3 + b_old3)
            $display("Time: %0t | Test %0d: a = %0d, b = %0d, out_hw = %0d, out_ref = %0d, correct)",
                    $time, i-2, a_old2, b_old3, c, a_old3 + b_old3);
        else
            $display("Time: %0t | Test %0d: a = %0d, b = %0d, out_hw = %0d, out_ref = %0d, wrong)",
                    $time, i-2, a_old2, b_old3, c, a_old3 + b_old3);

        @(posedge clk); #10
        if (c == a_old2 + b_old2)
            $display("Time: %0t | Test %0d: a = %0d, b = %0d, out_hw = %0d, out_ref = %0d, correct)",
                    $time, i-1, a_old2, b_old2, c, a_old2 + b_old2);
        else
            $display("Time: %0t | Test %0d: a = %0d, b = %0d, out_hw = %0d, out_ref = %0d, wrong)",
                    $time, i-1, a_old2, b_old2, c, a_old2 + b_old2);
        @(posedge clk); #10
        if (c == a_old1 + b_old1)
            $display("Time: %0t | Test %0d: a = %0d, b = %0d, out_hw = %0d, out_ref = %0d, correct)",
                    $time, i, a_old1, b_old1, c, a_old1 + b_old1);
        else
            $display("Time: %0t | Test %0d: a = %0d, b = %0d, out_hw = %0d, out_ref = %0d, wrong)",
                    $time, i, a_old1, b_old1, c, a_old1 + b_old1);
        repeat (50) @ (posedge clk);
        $finish;
    end

    always begin
        if(reset == 1'b1)begin
            clk = 1'b0;
            #1;
        end
        else begin
            #100
            clk = ~clk;
        end
    end

endmodule
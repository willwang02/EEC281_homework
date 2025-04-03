// prob4_tbench.v
`timescale 10ps/1ps
module prob3_tbench;
    reg         clk;
    reg         reset;
    reg [11:0]  a;
    reg [11:0]  b;
    wire [11:0] c;
    reg [11:0] a_old, b_old;
    integer i, seed;
    prob4 _prob4(.clk(clk), .a(a), .b(b), .c(c));
    initial begin
        reset = 1'b1;
        seed = 4;
        #500;
        reset = 1'b0;
        @(posedge clk); #10
        for (i = 0; i < 15; i = i + 1) begin
            a = $random(seed) % 4096;
            b = $random(seed) % 4096;
            @(posedge clk); #10
            if(i!=0)begin
                if (c == a_old + b_old)
                    $display("Time: %0t | Test %0d: a = %0d, b = %0d, out_hw = %0d, out_ref = %0d, correct)",
                            $time, i, a_old, b_old, c, a_old + b_old);
                else
                    $display("Time: %0t | Test %0d: a = %0d, b = %0d, out_hw = %0d, out_ref = %0d, wrong)",
                            $time, i, a_old, b_old, c, a_old + b_old);
            end
            a_old = a;
            b_old = b;
        end
        @(posedge clk); #10
        if (c == a_old + b_old)
            $display("Time: %0t | Test %0d: a = %0d, b = %0d, out_hw = %0d, out_ref = %0d, correct)",
                    $time, i, a_old, b_old, c, a_old + b_old);
        else
            $display("Time: %0t | Test %0d: a = %0d, b = %0d, out_hw = %0d, out_ref = %0d, wrong)",
                    $time, i, a_old, b_old, c, a_old + b_old);
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
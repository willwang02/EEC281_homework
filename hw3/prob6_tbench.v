// prob6_tbench.v
`timescale 10ps/1ps
module prob6_tbench;
    reg         clk;
    reg         reset;
    reg [3:0]  a_r, a_i;
    reg [3:0]  b_r, b_i;
    wire [8:0] p_r, p_i;
    reg [3:0] a_r_old, a_i_old, b_r_old, b_i_old;
    reg [8:0] p_r_ref, p_i_ref;
    reg [15:0] i;
    prob6 _prob6(.clk(clk), .a_r(a_r), .a_i(a_i), .b_r(b_r), .b_i(b_i), .p_r(p_r), .p_i(p_i));
    initial begin
        reset = 1'b1;
        #500;
        reset = 1'b0;
        @(posedge clk); #10
        for (i = 0; i < 16'b1111111111111111; i = i + 1) begin
            a_r = i[3:0];
            a_i = i[7:4];
            b_r = i[11:8];
            b_i = i[15:12];
            @(posedge clk); #10
            if(i!=0)begin
                if (p_r == p_r_ref && p_i == p_i_ref)
                    $display("Test %0d: a_r = %0d, a_i = %0d, b_r = %0d, b_i = %0d, p_r = %0d, p_i = %0d, p_r_ref = %0d, p_i_ref = %0d, correct)",
                            i, $signed(a_r_old), $signed(a_i_old), $signed(b_r_old), $signed(b_i_old), $signed(p_r), $signed(p_i), $signed(p_r_ref), $signed(p_i_ref));
                else
                    $display("Test %0d: a_r = %0d, a_i = %0d, b_r = %0d, b_i = %0d, p_r = %0d, p_i = %0d, p_r_ref = %0d, p_i_ref = %0d, wrong)",
                            i, $signed(a_r_old), $signed(a_i_old), $signed(b_r_old), $signed(b_i_old), $signed(p_r), $signed(p_i), $signed(p_r_ref), $signed(p_i_ref));
            end
            a_r_old = a_r;
            a_i_old = a_i;
            b_r_old = b_r;
            b_i_old = b_i;
            p_r_ref = {{5{a_r[3]}}, a_r} * {{5{b_r[3]}}, b_r} - {{5{a_i[3]}}, a_i} * {{5{b_i[3]}}, b_i};
            p_i_ref = {{5{a_r[3]}}, a_r} * {{5{b_i[3]}}, b_i} + {{5{a_i[3]}}, a_i} * {{5{b_r[3]}}, b_r};
        end
        @(posedge clk); #10
        if (p_r == p_r_ref && p_i == p_i_ref)
            $display("Test %0d: a_r = %0d, a_i = %0d, b_r = %0d, b_i = %0d, p_r = %0d, p_i = %0d, p_r_ref = %0d, p_i_ref = %0d, correct)",
                    i, $signed(a_r_old), $signed(a_i_old), $signed(b_r_old), $signed(b_i_old), $signed(p_r), $signed(p_i), $signed(p_r_ref), $signed(p_i_ref));
        else
            $display("Test %0d: a_r = %0d, a_i = %0d, b_r = %0d, b_i = %0d, p_r = %0d, p_i = %0d, p_r_ref = %0d, p_i_ref = %0d, wrong)",
                    i, $signed(a_r_old), $signed(a_i_old), $signed(b_r_old), $signed(b_i_old), $signed(p_r), $signed(p_i), $signed(p_r_ref), $signed(p_i_ref));
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
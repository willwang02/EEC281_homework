`timescale 10ps/1ps
module prob1_tbench;
    reg clk;
    reg reset;
    reg [11:0] theta;
    wire [15:0] out;
    integer file;
    prob1 _prob1(.clk(clk), .theta(theta), .out(out));
    initial begin
        reset = 1'b1;
        #500;
        reset = 1'b0;
        @(posedge clk); #10
        
        file = $fopen("output_1.m", "w");
        for (theta = 12'b000000000000; theta < 12'b111111111111; theta = theta + 1) begin
            @(posedge clk); #10
            $fwrite(file,"%d %d\n", theta, out);
        end
        theta = 12'b111111111111;
        @(posedge clk); #10
        $fwrite(file,"%d %d\n", theta, out);
        $fclose(file);
        @(posedge clk); #10
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
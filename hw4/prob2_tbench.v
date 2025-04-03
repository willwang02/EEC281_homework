`timescale 10ps/1ps
module prob2_tbench;

    reg clk, reset;
    reg [7:0] image_pixel;
    reg [7:0] filter_pixel;
    reg go;
    wire [32 * 49 - 1:0] conv_out;
    wire [32 * 49 - 1:0] relu_out;
    wire [32 * 9 - 1:0] out;

    prob2 uut (
        .clk(clk),
        .image_pixel(image_pixel),
        .filter_pixel(filter_pixel),
        .go(go),
        .conv_out(conv_out),
        .relu_out(relu_out),
        .out(out)
    );

    integer i, data_type;
    integer scan_image, scan_filter;
    integer image_file, filter_file;
    integer r;
    initial begin
        $recordfile("prob2_tbench");
        $recordvars(prob2_tbench);
        reset = 1'b1;
        #500;
        reset = 1'b0;
        
        go = 0;
        data_type = 3;
        image_pixel = 0;
        filter_pixel = 0;
        repeat (5) @ (posedge clk);
        go = 1;
        if(data_type == 0) begin
            image_file = $fopen("image_0.txt", "w");
            filter_file = $fopen("filter_0.txt", "w");
            r = 123;
            // $fwrite(image_file, "aa = [");
            @ (posedge clk);
            for (i = 0; i < 1225; i = i + 1) begin
                @ (posedge clk);
                r = $random(r);
                image_pixel = (r & 8'hFF);
                $fwrite(image_file, "%d ", image_pixel);
                if (i % 35 == 34 && i != 1224)
                    $fwrite(image_file, "\n");
            end
            // $fwrite(image_file, "]\n");
            // $fwrite(image_file, "f = [");
            for (i = 0; i < 121; i = i + 1) begin
                @ (posedge clk);
                r = $random(r);
                filter_pixel = $signed((r & 8'hFF) - 128);
                $fwrite(filter_file, "%d ", $signed(filter_pixel));
                if (i % 11 == 10 && i != 120)
                    $fwrite(filter_file, "\n");
            end
            // $fwrite(image_file, "]\n");
        end
        else if (data_type == 1) begin
            // @(posedge clk);
            @(posedge clk);
            $display("data_type == 1 start\n");
            image_file = $fopen("image_1.txt", "r");
            filter_file = $fopen("filter_1.txt", "r");
            for (i = 0; i < 1225; i = i + 1) begin
                @(posedge clk);
                scan_image = $fscanf(image_file, "%d", image_pixel);
                if (scan_image != 1) begin
                    $display("Error: Failed to read image_data.txt!");
                    $finish;
                end
            end
            // $display("read image finished\n");
            // @(posedge clk);
            // @(posedge clk);
            for (i = 0; i < 121; i = i + 1) begin
                @(posedge clk);
                scan_filter = $fscanf(filter_file, "%d", filter_pixel);
                if (scan_filter != 1) begin
                    $display("Error: Failed to read filter_data.txt!");
                    $finish;
                end
            end
            // $display("read filter finished\n");
        end
        else if (data_type == 2) begin
            // @(posedge clk);
            @(posedge clk);
            $display("data_type == 2 start\n");
            image_file = $fopen("image_2.txt", "r");
            filter_file = $fopen("filter_2.txt", "r");
            for (i = 0; i < 1225; i = i + 1) begin
                @(posedge clk);
                scan_image = $fscanf(image_file, "%d", image_pixel);
                if (scan_image != 1) begin
                    $display("Error: Failed to read image_data.txt!");
                    $finish;
                end
            end
            // $display("read image finished\n");
            // @(posedge clk);
            // @(posedge clk);
            for (i = 0; i < 121; i = i + 1) begin
                @(posedge clk);
                scan_filter = $fscanf(filter_file, "%d", filter_pixel);
                if (scan_filter != 1) begin
                    $display("Error: Failed to read filter_data.txt!");
                    $finish;
                end
            end
            // $display("read filter finished\n");
        end
        else if (data_type == 3) begin
            // @(posedge clk);
            @(posedge clk);
            $display("data_type == 3 start\n");
            image_file = $fopen("image_3.txt", "r");
            filter_file = $fopen("filter_3.txt", "r");
            for (i = 0; i < 1225; i = i + 1) begin
                @(posedge clk);
                scan_image = $fscanf(image_file, "%d", image_pixel);
                if (scan_image != 1) begin
                    $display("Error: Failed to read image_data.txt!");
                    $finish;
                end
            end
            // $display("read image finished\n");
            // @(posedge clk);
            // @(posedge clk);
            for (i = 0; i < 121; i = i + 1) begin
                @(posedge clk);
                scan_filter = $fscanf(filter_file, "%d", filter_pixel);
                if (scan_filter != 1) begin
                    $display("Error: Failed to read filter_data.txt!");
                    $finish;
                end
            end
            // $display("read filter finished\n");
        end
        repeat (1000) @ (posedge clk);
        $display("%d %d %d %d %d %d %d\n%d %d %d %d %d %d %d\n%d %d %d %d %d %d %d\n%d %d %d %d %d %d %d\n%d %d %d %d %d %d %d\n%d %d %d %d %d %d %d\n%d %d %d %d %d %d %d\n",
            $signed(conv_out[32 * 49 - 1 : 32 * 48]), $signed(conv_out[32 * 48 - 1 : 32 * 47]), $signed(conv_out[32 * 47 - 1 : 32 * 46]), $signed(conv_out[32 * 46 - 1 : 32 * 45]), $signed(conv_out[32 * 45 - 1 : 32 * 44]), $signed(conv_out[32 * 44 - 1 : 32 * 43]), $signed(conv_out[32 * 43 - 1 : 32 * 42]),
            $signed(conv_out[32 * 42 - 1 : 32 * 41]), $signed(conv_out[32 * 41 - 1 : 32 * 40]), $signed(conv_out[32 * 40 - 1 : 32 * 39]), $signed(conv_out[32 * 39 - 1 : 32 * 38]), $signed(conv_out[32 * 38 - 1 : 32 * 37]), $signed(conv_out[32 * 37 - 1 : 32 * 36]), $signed(conv_out[32 * 36 - 1 : 32 * 35]), 
            $signed(conv_out[32 * 35 - 1 : 32 * 34]), $signed(conv_out[32 * 34 - 1 : 32 * 33]), $signed(conv_out[32 * 33 - 1 : 32 * 32]), $signed(conv_out[32 * 32 - 1 : 32 * 31]), $signed(conv_out[32 * 31 - 1 : 32 * 30]), $signed(conv_out[32 * 30 - 1 : 32 * 29]), $signed(conv_out[32 * 29 - 1 : 32 * 28]), 
            $signed(conv_out[32 * 28 - 1 : 32 * 27]), $signed(conv_out[32 * 27 - 1 : 32 * 26]), $signed(conv_out[32 * 26 - 1 : 32 * 25]), $signed(conv_out[32 * 25 - 1 : 32 * 24]), $signed(conv_out[32 * 24 - 1 : 32 * 23]), $signed(conv_out[32 * 23 - 1 : 32 * 22]), $signed(conv_out[32 * 22 - 1 : 32 * 21]), 
            $signed(conv_out[32 * 21 - 1 : 32 * 20]), $signed(conv_out[32 * 20 - 1 : 32 * 19]), $signed(conv_out[32 * 19 - 1 : 32 * 18]), $signed(conv_out[32 * 18 - 1 : 32 * 17]), $signed(conv_out[32 * 17 - 1 : 32 * 16]), $signed(conv_out[32 * 16 - 1 : 32 * 15]), $signed(conv_out[32 * 15 - 1 : 32 * 14]), 
            $signed(conv_out[32 * 14 - 1 : 32 * 13]), $signed(conv_out[32 * 13 - 1 : 32 * 12]), $signed(conv_out[32 * 12 - 1 : 32 * 11]), $signed(conv_out[32 * 11 - 1 : 32 * 10]), $signed(conv_out[32 * 10 - 1 : 32 * 9]), $signed(conv_out[32 * 9 - 1 : 32 * 8]), $signed(conv_out[32 * 8 - 1 : 32 * 7]), 
            $signed(conv_out[32 * 7 - 1 : 32 * 6]), $signed(conv_out[32 * 6 - 1 : 32 * 5]), $signed(conv_out[32 * 5 - 1 : 32 * 4]), $signed(conv_out[32 * 4 - 1 : 32 * 3]), $signed(conv_out[32 * 3 - 1 : 32 * 2]), $signed(conv_out[32 * 2 - 1 : 32 * 1]), $signed(conv_out[32 * 1 - 1 : 32 * 0]));

        
        $display("%d %d %d %d %d %d %d\n%d %d %d %d %d %d %d\n%d %d %d %d %d %d %d\n%d %d %d %d %d %d %d\n%d %d %d %d %d %d %d\n%d %d %d %d %d %d %d\n%d %d %d %d %d %d %d\n",
            $signed(relu_out[32 * 49 - 1 : 32 * 48]), $signed(relu_out[32 * 48 - 1 : 32 * 47]), $signed(relu_out[32 * 47 - 1 : 32 * 46]), $signed(relu_out[32 * 46 - 1 : 32 * 45]), $signed(relu_out[32 * 45 - 1 : 32 * 44]), $signed(relu_out[32 * 44 - 1 : 32 * 43]), $signed(relu_out[32 * 43 - 1 : 32 * 42]),
            $signed(relu_out[32 * 42 - 1 : 32 * 41]), $signed(relu_out[32 * 41 - 1 : 32 * 40]), $signed(relu_out[32 * 40 - 1 : 32 * 39]), $signed(relu_out[32 * 39 - 1 : 32 * 38]), $signed(relu_out[32 * 38 - 1 : 32 * 37]), $signed(relu_out[32 * 37 - 1 : 32 * 36]), $signed(relu_out[32 * 36 - 1 : 32 * 35]), 
            $signed(relu_out[32 * 35 - 1 : 32 * 34]), $signed(relu_out[32 * 34 - 1 : 32 * 33]), $signed(relu_out[32 * 33 - 1 : 32 * 32]), $signed(relu_out[32 * 32 - 1 : 32 * 31]), $signed(relu_out[32 * 31 - 1 : 32 * 30]), $signed(relu_out[32 * 30 - 1 : 32 * 29]), $signed(relu_out[32 * 29 - 1 : 32 * 28]), 
            $signed(relu_out[32 * 28 - 1 : 32 * 27]), $signed(relu_out[32 * 27 - 1 : 32 * 26]), $signed(relu_out[32 * 26 - 1 : 32 * 25]), $signed(relu_out[32 * 25 - 1 : 32 * 24]), $signed(relu_out[32 * 24 - 1 : 32 * 23]), $signed(relu_out[32 * 23 - 1 : 32 * 22]), $signed(relu_out[32 * 22 - 1 : 32 * 21]), 
            $signed(relu_out[32 * 21 - 1 : 32 * 20]), $signed(relu_out[32 * 20 - 1 : 32 * 19]), $signed(relu_out[32 * 19 - 1 : 32 * 18]), $signed(relu_out[32 * 18 - 1 : 32 * 17]), $signed(relu_out[32 * 17 - 1 : 32 * 16]), $signed(relu_out[32 * 16 - 1 : 32 * 15]), $signed(relu_out[32 * 15 - 1 : 32 * 14]), 
            $signed(relu_out[32 * 14 - 1 : 32 * 13]), $signed(relu_out[32 * 13 - 1 : 32 * 12]), $signed(relu_out[32 * 12 - 1 : 32 * 11]), $signed(relu_out[32 * 11 - 1 : 32 * 10]), $signed(relu_out[32 * 10 - 1 : 32 * 9]), $signed(relu_out[32 * 9 - 1 : 32 * 8]), $signed(relu_out[32 * 8 - 1 : 32 * 7]), 
            $signed(relu_out[32 * 7 - 1 : 32 * 6]), $signed(relu_out[32 * 6 - 1 : 32 * 5]), $signed(relu_out[32 * 5 - 1 : 32 * 4]), $signed(relu_out[32 * 4 - 1 : 32 * 3]), $signed(relu_out[32 * 3 - 1 : 32 * 2]), $signed(relu_out[32 * 2 - 1 : 32 * 1]), $signed(relu_out[32 * 1 - 1 : 32 * 0]));

        $display("%d %d %d\n%d %d %d\n%d %d %d",
                    out[32 * 9 - 1 : 32 * 8],
                    out[32 * 8 - 1 : 32 * 7],
                    out[32 * 7 - 1 : 32 * 6],
                    out[32 * 6 - 1 : 32 * 5],
                    out[32 * 5 - 1 : 32 * 4],
                    out[32 * 4 - 1 : 32 * 3],
                    out[32 * 3 - 1 : 32 * 2],
                    out[32 * 2 - 1 : 32 * 1],
                    out[32 * 1 - 1 : 32 * 0]);
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
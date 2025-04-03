`timescale 10ps/1ps
module prob2 (
    clk,
    image_pixel,
    filter_pixel,
    go,
    conv_out,
    relu_out,
    out
);
    input clk, go;
    input [7:0] image_pixel;
    input [7:0] filter_pixel;
    output reg [32 * 9 - 1:0] out;
    output reg [32 * 49 - 1:0] conv_out;
    output reg [32 * 49 - 1:0] relu_out;
    reg [8 * 11 - 1:0] image_din;
    reg [8 * 11 - 1:0] filter_din;
    wire [8 * 11 - 1:0] image_dout;
    wire [8 * 11 - 1:0] filter_dout;
    reg [11 * 11 - 1:0] image_addr;
    reg [7 * 11 - 1:0] filter_addr;
    
    reg image_we, filter_we;
    memory #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(11)
    ) image (
        .clk(clk),
        .we(image_we),
        .addr(image_addr),
        .din(image_din),
        .dout(image_dout)
    );
    memory #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(7)
    ) filter (
        .clk(clk),
        .we(filter_we),
        .addr(filter_addr),
        .din(filter_din),
        .dout(filter_dout)
    );

    reg signed [31:0] out_conv [0:48];
    reg [31:0] out_relu [0:48];
    reg [31:0] out_max_pool [0:8];


    localparam IDLE = 3'b000;
    localparam READ_IMAGE = 3'b001;
    localparam READ_FILTER = 3'b010;
    localparam CONV = 3'b011;
    localparam PREPARE = 3'b100;
    localparam STOP = 3'b110;

    reg [2:0] state, state_c;
    reg [10:0] cnt, cnt_c;
    always @(state or go or cnt) begin
        state_c = state;
        cnt_c = cnt - 11'b00000000001;
        case (state)
            IDLE:begin
                if(go == 1'b1)begin
                    $display("go start\n");
                    state_c = PREPARE;
                    cnt_c = 11'b00000000000;
                end
                else
                    cnt_c = 11'b00000000000;
            end
            PREPARE:begin
                if(cnt == 11'b00000000000)begin
                    // $display("PREPARE finished\n");
                    state_c = READ_IMAGE;
                    cnt_c = 11'b10011001000;
                    image_we = 1'b1;
                end
            end
            READ_IMAGE:begin
                if(cnt == 11'b00000000000) begin
                    // $display("READ_IMAGE finished\n");
                    state_c = READ_FILTER;
                    cnt_c = 11'b00001111001;
                    
                    filter_we = 1'b1;
                end
            end
            READ_FILTER:begin
                if(cnt == 11'b00000000000) begin
                    // $display("READ_FILTER finished\n");
                    state_c = CONV;
                    //cnt_c = 11'b00100001100;
                    cnt_c = 11'b00000000001;
                end
            end
            CONV:begin
                if(cnt == 11'b00000000000) begin
                    image_we = 1'b0;
                    filter_we = 1'b0;
                end
                
            end
            STOP:begin end
            default: state_c = IDLE;
        endcase
    end
    always @(posedge clk) begin
        state <= state_c;
        cnt <= cnt_c;
        // $display("state_c: %d, cnt_c: %d\n",state_c, cnt);
    end

    reg [5:0] conv_cnt;
    reg [3:0] row;
    reg signed [31:0] sum;
    reg [10:0] image_base_addr;
    reg [6:0] filter_base_addr;
    reg [3:0] idx;
    reg [3:0] pos_cnt;
    reg [5:0] max_pool_cnt[0:8];
    reg [4:0] pos[0:8];
    integer i;
    always @(posedge clk) begin
        if (state == PREPARE) begin
            conv_cnt <= 0;
            row <= 0;
            sum <= 0;
            image_base_addr <= 0;
            filter_base_addr <= 0;
            idx <= 0;
            pos_cnt <= 0;
            max_pool_cnt[0] <= 16;
            max_pool_cnt[1] <= 18;
            max_pool_cnt[2] <= 20;
            max_pool_cnt[3] <= 30;
            max_pool_cnt[4] <= 32;
            max_pool_cnt[5] <= 34;
            max_pool_cnt[6] <= 44;
            max_pool_cnt[7] <= 46;
            max_pool_cnt[8] <= 48;
            pos[0] <= 16;
            pos[1] <= 15;
            pos[2] <= 14;
            pos[3] <= 9;
            pos[4] <= 8;
            pos[5] <= 7;
            pos[6] <= 2;
            pos[7] <= 1;
            pos[8] <= 0;
            out_max_pool[0] <= 0;
            out_max_pool[1] <= 0;
            out_max_pool[2] <= 0;
            out_max_pool[3] <= 0;
            out_max_pool[4] <= 0;
            out_max_pool[5] <= 0;
            out_max_pool[6] <= 0;
            out_max_pool[7] <= 0;
            out_max_pool[8] <= 0;


        end
        if (state == READ_IMAGE) begin
            // if(11'b10011001000 - cnt == 0)
                // $display("cnt:%d, image_addr:%d, image_pixel: %d\n",cnt, 11'b10011001000 - cnt,image_pixel);
            image_din <= {{80{1'b1}},image_pixel};
            image_addr <= {{110{1'b1}},11'b10011001000 - cnt};
        end
        else if (state == READ_FILTER) begin
            // $display("cnt:%d, filter_addr:%b, filter_pixel: %d\n",cnt, {7'b1111000 - cnt[6:0]}, $signed(filter_pixel));
            filter_din <= {{80{1'b1}},filter_pixel};
            filter_addr <= {{70{1'b1}},7'b1111001 - cnt[6:0]};
        end
        else if(state == CONV) begin
            if(conv_cnt <= 49) begin
                // stage 1: read data
                    
                if(row == 11) begin
                    image_addr <= image_addr;
                    filter_addr <= filter_addr;
                    row <= 0;
                    conv_cnt <= conv_cnt + 1;
                    image_base_addr <= 35 * ((conv_cnt + 1) / 7 * 4) + (conv_cnt + 1) % 7 * 4;
                    filter_base_addr <= 0;
                    
                end
                else begin
                    // $display("row:%d, filter_addr_1 = %d, filter_addr_2 = %d\n", row,filter_addr[7 * 2 - 1 : 7 * 1], filter_addr[7 * 1 - 1 : 7 * 0]);
                    image_addr[11 * 11 - 1 : 11 * 10] <= image_base_addr + 0;
                    image_addr[11 * 10 - 1 : 11 * 9] <= image_base_addr + 1;
                    image_addr[11 * 9 - 1 : 11 * 8] <= image_base_addr + 2;
                    image_addr[11 * 8 - 1 : 11 * 7] <= image_base_addr + 3;
                    image_addr[11 * 7 - 1 : 11 * 6] <= image_base_addr + 4;
                    image_addr[11 * 6 - 1 : 11 * 5] <= image_base_addr + 5;
                    image_addr[11 * 5 - 1 : 11 * 4] <= image_base_addr + 6;
                    image_addr[11 * 4 - 1 : 11 * 3] <= image_base_addr + 7;
                    image_addr[11 * 3 - 1 : 11 * 2] <= image_base_addr + 8;
                    image_addr[11 * 2 - 1 : 11 * 1] <= image_base_addr + 9;
                    image_addr[11 * 1 - 1 : 11 * 0] <= image_base_addr + 10;

                    filter_addr[7 * 11 - 1 : 7 * 10] <= filter_base_addr + 0;
                    filter_addr[7 * 10 - 1 : 7 * 9] <= filter_base_addr + 1;
                    filter_addr[7 * 9 - 1 : 7 * 8] <= filter_base_addr + 2;
                    filter_addr[7 * 8 - 1 : 7 * 7] <= filter_base_addr + 3;
                    filter_addr[7 * 7 - 1 : 7 * 6] <= filter_base_addr + 4;
                    filter_addr[7 * 6 - 1 : 7 * 5] <= filter_base_addr + 5;
                    filter_addr[7 * 5 - 1 : 7 * 4] <= filter_base_addr + 6;
                    filter_addr[7 * 4 - 1 : 7 * 3] <= filter_base_addr + 7;
                    filter_addr[7 * 3 - 1 : 7 * 2] <= filter_base_addr + 8;
                    filter_addr[7 * 2 - 1 : 7 * 1] <= filter_base_addr + 9;
                    filter_addr[7 * 1 - 1 : 7 * 0] <= filter_base_addr + 10;
                    image_base_addr <= image_base_addr + 35;
                    filter_base_addr <= filter_base_addr + 11;
                    row <= row + 1;
                end

                //stage 2: multiply and add up
                if(row == 0) begin
                    // out_conv[conv_cnt - 1] <= sum;
                    // $display("out_conv[%d]: %d",conv_cnt - 1, sum);
                    // sum <= 0;
                    out_conv[conv_cnt] <= 0;
                    // $display("conv_out: %b", conv_out);
                    conv_out <= {out_conv[0], out_conv[1], out_conv[2], out_conv[3], out_conv[4], out_conv[5], out_conv[6],
                                out_conv[7], out_conv[8], out_conv[9], out_conv[10], out_conv[11], out_conv[12], out_conv[13], 
                                out_conv[14], out_conv[15], out_conv[16], out_conv[17], out_conv[18], out_conv[19], out_conv[20], 
                                out_conv[21], out_conv[22], out_conv[23], out_conv[24], out_conv[25], out_conv[26], out_conv[27], 
                                out_conv[28], out_conv[29], out_conv[30], out_conv[31], out_conv[32], out_conv[33], out_conv[34], 
                                out_conv[35], out_conv[36], out_conv[37], out_conv[38], out_conv[39], out_conv[40], out_conv[41], 
                                out_conv[42], out_conv[43], out_conv[44], out_conv[45], out_conv[46], out_conv[47], out_conv[48]};
                end
                else begin
                    // $display("row = %d, sum = %d", row, sum);
                    // $display("row: %d, filter_dout = %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d", row,
                    //     $signed(filter_dout[8 * 11 - 1 : 8 * 10]),
                    //     $signed(filter_dout[8 * 10 - 1 : 8 * 9]),
                    //     $signed(filter_dout[8 * 9 - 1 : 8 * 8]),
                    //     $signed(filter_dout[8 * 8 - 1 : 8 * 7]),
                    //     $signed(filter_dout[8 * 7 - 1 : 8 * 6]),
                    //     $signed(filter_dout[8 * 6 - 1 : 8 * 5]),
                    //     $signed(filter_dout[8 * 5 - 1 : 8 * 4]),
                    //     $signed(filter_dout[8 * 4 - 1 : 8 * 3]),
                    //     $signed(filter_dout[8 * 3 - 1 : 8 * 2]),
                    //     $signed(filter_dout[8 * 2 - 1 : 8 * 1]),
                    //     $signed(filter_dout[8 * 1 - 1 : 8 * 0]));
                    // $display("row: %d, image_dout = %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d", row,
                    //     image_dout[8 * 11 - 1 : 8 * 10],
                    //     image_dout[8 * 10 - 1 : 8 * 9],
                    //     image_dout[8 * 9 - 1 : 8 * 8],
                    //     image_dout[8 * 8 - 1 : 8 * 7],
                    //     image_dout[8 * 7 - 1 : 8 * 6],
                    //     image_dout[8 * 6 - 1 : 8 * 5],
                    //     image_dout[8 * 5 - 1 : 8 * 4],
                    //     image_dout[8 * 4 - 1 : 8 * 3],
                    //     image_dout[8 * 3 - 1 : 8 * 2],
                    //     image_dout[8 * 2 - 1 : 8 * 1],
                    //     image_dout[8 * 1 - 1 : 8 * 0]);
                    // $display("row: %d, product = %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d", row,
                    //     $signed({18'b0,image_dout[8 * 11 - 1 : 8 * 10]}) * $signed(filter_dout[8 * 11 - 1 : 8 * 10]),
                    //     $signed({18'b0,image_dout[8 * 11 - 1 : 8 * 10]}) * $signed(filter_dout[8 * 11 - 1 : 8 * 10])+
                    // $signed({18'b0,image_dout[8 * 10 - 1 : 8 * 9]}) * $signed(filter_dout[8 * 10 - 1 : 8 * 9]),
                    // $signed({18'b0,image_dout[8 * 9 - 1 : 8 * 8]}) * $signed(filter_dout[8 * 9 - 1 : 8 * 8]),
                    // $signed({18'b0,image_dout[8 * 8 - 1 : 8 * 7]}) * $signed(filter_dout[8 * 8 - 1 : 8 * 7]),
                    // $signed({18'b0,image_dout[8 * 7 - 1 : 8 * 6]}) * $signed(filter_dout[8 * 7 - 1 : 8 * 6]),
                    // $signed({18'b0,image_dout[8 * 6 - 1 : 8 * 5]}) * $signed(filter_dout[8 * 6 - 1 : 8 * 5]),
                    // $signed({18'b0,image_dout[8 * 5 - 1 : 8 * 4]}) * $signed(filter_dout[8 * 5 - 1 : 8 * 4]),
                    // $signed({18'b0,image_dout[8 * 4 - 1 : 8 * 3]}) * $signed(filter_dout[8 * 4 - 1 : 8 * 3]),
                    // $signed({18'b0,image_dout[8 * 3 - 1 : 8 * 2]}) * $signed(filter_dout[8 * 3 - 1 : 8 * 2]),
                    // $signed({18'b0,image_dout[8 * 2 - 1 : 8 * 1]}) * $signed(filter_dout[8 * 2 - 1 : 8 * 1]),
                    // $signed({18'b0,image_dout[8 * 1 - 1 : 8 * 0]}) * $signed(filter_dout[8 * 1 - 1 : 8 * 0]));
                    out_conv[conv_cnt] <= $signed({1'b0,image_dout[8 * 11 - 1 : 8 * 10]}) * $signed(filter_dout[8 * 11 - 1 : 8 * 10])
                    + $signed({18'b0,image_dout[8 * 10 - 1 : 8 * 9]}) * $signed(filter_dout[8 * 10 - 1 : 8 * 9])
                    + $signed({18'b0,image_dout[8 * 9 - 1 : 8 * 8]}) * $signed(filter_dout[8 * 9 - 1 : 8 * 8])
                    + $signed({18'b0,image_dout[8 * 8 - 1 : 8 * 7]}) * $signed(filter_dout[8 * 8 - 1 : 8 * 7])
                    + $signed({18'b0,image_dout[8 * 7 - 1 : 8 * 6]}) * $signed(filter_dout[8 * 7 - 1 : 8 * 6])
                    + $signed({18'b0,image_dout[8 * 6 - 1 : 8 * 5]}) * $signed(filter_dout[8 * 6 - 1 : 8 * 5])
                    + $signed({18'b0,image_dout[8 * 5 - 1 : 8 * 4]}) * $signed(filter_dout[8 * 5 - 1 : 8 * 4])
                    + $signed({18'b0,image_dout[8 * 4 - 1 : 8 * 3]}) * $signed(filter_dout[8 * 4 - 1 : 8 * 3])
                    + $signed({18'b0,image_dout[8 * 3 - 1 : 8 * 2]}) * $signed(filter_dout[8 * 3 - 1 : 8 * 2])
                    + $signed({18'b0,image_dout[8 * 2 - 1 : 8 * 1]}) * $signed(filter_dout[8 * 2 - 1 : 8 * 1])
                    + $signed({18'b0,image_dout[8 * 1 - 1 : 8 * 0]}) * $signed(filter_dout[8 * 1 - 1 : 8 * 0])
                    + out_conv[conv_cnt];
                end

            end
            if(row == 0 && conv_cnt != 0) begin // 1 conv complete -> ReLU
                out_relu[conv_cnt - 1] <= (out_conv[conv_cnt - 1][31] == 1'b1) ? 0 : out_conv[conv_cnt - 1];
                // $display("out_relu[%d]: %d\n",conv_cnt - 1,  (out_conv[conv_cnt - 1][31] == 1'b1) ? 0 : out_conv[conv_cnt - 1]);
                relu_out <= {out_relu[0], out_relu[1], out_relu[2], out_relu[3], out_relu[4], out_relu[5], out_relu[6],
                            out_relu[7], out_relu[8], out_relu[9], out_relu[10], out_relu[11], out_relu[12], out_relu[13], 
                            out_relu[14], out_relu[15], out_relu[16], out_relu[17], out_relu[18], out_relu[19], out_relu[20], 
                            out_relu[21], out_relu[22], out_relu[23], out_relu[24], out_relu[25], out_relu[26], out_relu[27], 
                            out_relu[28], out_relu[29], out_relu[30], out_relu[31], out_relu[32], out_relu[33], out_relu[34], 
                            out_relu[35], out_relu[36], out_relu[37], out_relu[38], out_relu[39], out_relu[40], out_relu[41], 
                            out_relu[42], out_relu[43], out_relu[44], out_relu[45], out_relu[46], out_relu[47], out_relu[48]};
            end
            if(row >= 1 && conv_cnt - 1 == max_pool_cnt[idx]) begin
                // $display("conv_cnt: %d, max_pool_cnt[%d]: %d, pos_cnt: %d\n",conv_cnt - 1, idx, max_pool_cnt[idx], pos_cnt);
                if(pos_cnt < 9) begin
                    if(out_max_pool[idx] < out_relu[conv_cnt - 1 - pos[pos_cnt]])
                        out_max_pool[idx] <= out_relu[conv_cnt - 1 - pos[pos_cnt]];
                    else
                        out_max_pool[idx] <= out_max_pool[idx];
                    pos_cnt <= pos_cnt + 1;
                    // $display("out_max_pool[%d]: %d, out_relu[%d - 1 - pos[%d]]: %d\n",idx, out_max_pool[idx],conv_cnt, pos_cnt, out_relu[conv_cnt - 1 - pos[pos_cnt]]);
                end
                else begin
                    out <= {out_max_pool[0],out_max_pool[1], out_max_pool[2], out_max_pool[3], 
                    out_max_pool[4], out_max_pool[5], out_max_pool[6], 
                    out_max_pool[7], out_max_pool[8]};
                    pos_cnt <= 0;
                    idx <= idx + 1;
                end
            end
        end
    end
    
endmodule
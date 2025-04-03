module memory#(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 11
)(
    clk,
    we,
    addr,
    din,
    dout
);
    input  clk;
    input  we;
    input [ADDR_WIDTH * 11 - 1 : 0]    addr;
    input [DATA_WIDTH * 11 - 1 : 0]    din;
    output reg  [DATA_WIDTH * 11 - 1 : 0]    dout;
    reg [DATA_WIDTH - 1 : 0] mem [0 : (1 << ADDR_WIDTH) - 1];

    always @(*) begin
        if (we) begin
            mem[addr[ADDR_WIDTH * 11 - 1 : ADDR_WIDTH * 10]] <= din[DATA_WIDTH * 11 - 1 : DATA_WIDTH * 10];
            mem[addr[ADDR_WIDTH * 10 - 1 : ADDR_WIDTH * 9]] <= din[DATA_WIDTH * 10 - 1 : DATA_WIDTH * 9];
            mem[addr[ADDR_WIDTH * 9 - 1 : ADDR_WIDTH * 8]] <= din[DATA_WIDTH * 9 - 1 : DATA_WIDTH * 8];
            mem[addr[ADDR_WIDTH * 8 - 1 : ADDR_WIDTH * 7]] <= din[DATA_WIDTH * 8 - 1 : DATA_WIDTH * 7];
            mem[addr[ADDR_WIDTH * 7 - 1 : ADDR_WIDTH * 6]] <= din[DATA_WIDTH * 7 - 1 : DATA_WIDTH * 6];
            mem[addr[ADDR_WIDTH * 6 - 1 : ADDR_WIDTH * 5]] <= din[DATA_WIDTH * 6 - 1 : DATA_WIDTH * 5];
            mem[addr[ADDR_WIDTH * 5 - 1 : ADDR_WIDTH * 4]] <= din[DATA_WIDTH * 5 - 1 : DATA_WIDTH * 4];
            mem[addr[ADDR_WIDTH * 4 - 1 : ADDR_WIDTH * 3]] <= din[DATA_WIDTH * 4 - 1 : DATA_WIDTH * 3];
            mem[addr[ADDR_WIDTH * 3 - 1 : ADDR_WIDTH * 2]] <= din[DATA_WIDTH * 3 - 1 : DATA_WIDTH * 2];
            mem[addr[ADDR_WIDTH * 2 - 1 : ADDR_WIDTH * 1]] <= din[DATA_WIDTH * 2 - 1 : DATA_WIDTH * 1];
            mem[addr[ADDR_WIDTH * 1 - 1 : ADDR_WIDTH * 0]] <= din[DATA_WIDTH * 1 - 1 : DATA_WIDTH * 0];
        end
        else begin
            dout[DATA_WIDTH * 11 - 1 : DATA_WIDTH * 10] <= mem[addr[ADDR_WIDTH * 11 - 1 : ADDR_WIDTH * 10]];
            dout[DATA_WIDTH * 10 - 1 : DATA_WIDTH * 9] <= mem[addr[ADDR_WIDTH * 10 - 1 : ADDR_WIDTH * 9]];
            dout[DATA_WIDTH * 9 - 1 : DATA_WIDTH * 8] <= mem[addr[ADDR_WIDTH * 9 - 1 : ADDR_WIDTH * 8]];
            dout[DATA_WIDTH * 8 - 1 : DATA_WIDTH * 7] <= mem[addr[ADDR_WIDTH * 8 - 1 : ADDR_WIDTH * 7]];
            dout[DATA_WIDTH * 7 - 1 : DATA_WIDTH * 6] <= mem[addr[ADDR_WIDTH * 7 - 1 : ADDR_WIDTH * 6]];
            dout[DATA_WIDTH * 6 - 1 : DATA_WIDTH * 5] <= mem[addr[ADDR_WIDTH * 6 - 1 : ADDR_WIDTH * 5]];
            dout[DATA_WIDTH * 5 - 1 : DATA_WIDTH * 4] <= mem[addr[ADDR_WIDTH * 5 - 1 : ADDR_WIDTH * 4]];
            dout[DATA_WIDTH * 4 - 1 : DATA_WIDTH * 3] <= mem[addr[ADDR_WIDTH * 4 - 1 : ADDR_WIDTH * 3]];
            dout[DATA_WIDTH * 3 - 1 : DATA_WIDTH * 2] <= mem[addr[ADDR_WIDTH * 3 - 1 : ADDR_WIDTH * 2]];
            dout[DATA_WIDTH * 2 - 1 : DATA_WIDTH * 1] <= mem[addr[ADDR_WIDTH * 2 - 1 : ADDR_WIDTH * 1]];
            dout[DATA_WIDTH * 1 - 1 : DATA_WIDTH * 0] <= mem[addr[ADDR_WIDTH * 1 - 1 : ADDR_WIDTH * 0]];
        end
    end

endmodule
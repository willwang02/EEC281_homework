`timescale 10ps/1ps

module prob2(
    mantissa,
    exp,
    out
    );

    input [3:0]     mantissa;
    input [2:0]     exp;

    output reg [10:0]    out;
    always @(*) begin
        if (exp[2] == 2'b0)begin
            out = {{3{mantissa[3]}}, mantissa, {4'b0000}} << exp; 
        end else begin
            out = $signed({{3{mantissa[3]}}, mantissa, {4'b0000}}) >>> (-exp);
            // $write("-exp: %h\n", -exp); 
        end
    end

endmodule

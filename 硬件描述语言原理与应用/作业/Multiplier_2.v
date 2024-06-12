`timescale 1ns / 10ps

module Multiplier_2(
    input      [1:0] x,
    input      [1:0] y,
    output reg [3:0] z
);

    always @ (*) begin
        case (y) //对乘数进行枚举
            2'b00:begin //乘数为0，输出0
                z = 4'b0000;
            end
            2'b01:begin //乘数为1，输出不变
                z = {2'b00, x};
            end
            2'b10:begin //乘数为2，左移一位
                z = {1'b0, x, 1'b0};
            end
            2'b11:begin //乘数为3，左移一位并与原数相加
                z = {x[1]&x[0], x[1]^(x[1]&x[0]), x[1]^x[0], x[0]};
            end
            default: ;
        endcase
    end

endmodule
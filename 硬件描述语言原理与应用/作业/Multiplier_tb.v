`timescale 1ns / 10ps

module Multiplier_tb;

    //inputs
    reg  [1:0] x;
    reg  [1:0] y;

    //outputs
    wire [3:0] z;

    //乘法器实例
    Multiplier_2 
        U_Multipler_1(
            .x(x),
            .y(y),
            .z(z)
        );
    
    //扫描所有情况
    initial begin
        x=2'b00; y=2'b00;
        #100 x=2'b00; y=2'b01;
        #100 x=2'b00; y=2'b11;
        #100 x=2'b00; y=2'b10;

        #100 x=2'b01; y=2'b00;
        #100 x=2'b01; y=2'b01;
        #100 x=2'b01; y=2'b11;
        #100 x=2'b01; y=2'b10;

        #100 x=2'b11; y=2'b00;
        #100 x=2'b11; y=2'b01;
        #100 x=2'b11; y=2'b11;
        #100 x=2'b11; y=2'b10;

        #100 x=2'b10; y=2'b00;
        #100 x=2'b10; y=2'b01;
        #100 x=2'b10; y=2'b11;
        #100 x=2'b10; y=2'b10;
        #100 $stop;
    end

endmodule
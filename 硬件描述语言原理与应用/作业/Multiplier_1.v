`timescale 1ns / 10ps

module Multiplier_1( //Array Mutiplier
    input   [1:0]   x,
    input   [1:0]   y, 
    output  [3:0]   z
);
    wire x0_y0, x0_y1, x1_y0, x1_y1; 
    wire c1, c2; 

    //求部分积
    assign x0_y0 = x[0] & y[0];
    assign x0_y1 = x[0] & y[1];
    assign x1_y0 = x[1] & y[0];
    assign x1_y1 = x[1] & y[1];

    //求和并输出，本质为一个半加器和一个全加器
    assign z[0] = x0_y0;
    assign z[1] = x0_y1 ^ x1_y0;
    assign z[2] = x1_y1 ^ (x0_y1 & x1_y0); 
    assign z[3] = x1_y1 & (x0_y1 & x1_y0);

endmodule
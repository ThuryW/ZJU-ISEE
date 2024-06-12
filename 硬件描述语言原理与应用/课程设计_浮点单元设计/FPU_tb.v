`timescale 1ns / 10ps

module FPU_tb;
    //inputs
    reg        clk      ;
    reg        rst      ;
    reg [31:0] dividend ;
    reg [31:0] divisor  ;

    //outputs
    reg [31:0] quotient ;

    parameter delay = 5 ;

    FPU 
        U_FPU(
            .clk(clk)           ,
            .rst(rst)           ,
            .dividend(dividend) ,
            .divisor(divisor)   ,
            .quotient(quotient)
        );

    initial begin
        //create .vpd file
        `ifdef DUMP_VPD
            $vcdpluson();
        `endif
        //create .vcd file
        $dumpfile("FPU_Wave.vcd");
        $dumpvars;
    end

    //clock
	always #(delay/2) clk=~clk;

    initial begin
        // initial 
        clk       = 0  ; 
        rst       = 1  ;

        // special == 0 : 1.5 / 0.5 = 3
        // output should be 0_10000000_10000000000000000000000
        dividend = 32'b0_01111111_10000000000000000000000; //1.5
        divisor  = 32'b0_01111110_00000000000000000000000; //0.5
        #(delay * 1.5 + 1) rst = 0;

        // special == 0 : 0.5 / 1.5 = 0.33333333
        // output should be 0_01111101_01010101010101010101011
        #(delay * 45     ) rst = 1;
                           dividend = 32'b0_01111110_00000000000000000000000; //0.5
                           divisor  = 32'b0_01111111_10000000000000000000000; //1.5
        #(delay * 1.5 + 1) rst = 0;
        
        // special == 0 : dividend is unnormalized
        // output should be 0_00000000_01100010101010101010101
        #(delay * 45     ) rst = 1;
                           dividend = 32'b0_00000000_10010100000000000000000; //unnormalized
                           divisor  = 32'b0_01111111_10000000000000000000000; 
        #(delay * 1.5 + 1) rst = 0;

        // special == 0 : divisor is unnormalized
        // output should be 0_11111110_00011101110001000111100
        #(delay * 45     ) rst = 1;
                           dividend = 32'b0_01111111_10000000000000000000000; 
                           divisor  = 32'b0_00000000_10101100000000000000000; //unnormalized
        #(delay * 1.5 + 1) rst = 0;

        // special == 0 : dividend and divisor are both unnormalized
        // output should be 0_01111111_01011000000000000000000
        #(delay * 45     ) rst = 1;
                           dividend = 32'b0_00000000_10101100000000000000000; //unnormalized
                           divisor  = 32'b0_00000000_10000000000000000000000; //unnormalized
        #(delay * 1.5 + 1) rst = 0;

        // special == 0 : quotient is unnormalized
        // output should be 0_00000000_10100000011110100100010
        #(delay * 45     ) rst = 1;
                           dividend = 32'b0_01000000_11111000000000000000000; 
                           divisor  = 32'b0_10111111_10010010000000000000000;
        #(delay * 1.5 + 1) rst = 0;

        // special == 1 : x / infinity = 0 (x not NaN,infinity or zero)
        // output should be zero
        #(delay * 45     ) rst = 1;
                           dividend = 32'b0_01111111_10000000000000000000000; //1.5
                           divisor  = 32'b0_11111111_00000000000000000000000; //infinity
        #(delay * 1.5 + 1) rst = 0;

        // special == 2 : x / 0 = infinity (x not NaN,infinity or zero)
        // output should be infinity
        #(delay * 45     ) rst = 1;
                           dividend = 32'b0_01111111_10000000000000000000000; //1.5
                           divisor  = 32'b0_00000000_00000000000000000000000; //zero
        #(delay * 1.5 + 1) rst = 0;

        // special == 3 : 0 / 0 = NaN
        // output should be NaN
        #(delay * 45     ) rst = 1;
                           dividend = 32'b0_00000000_00000000000000000000000; //zero
                           divisor  = 32'b0_00000000_00000000000000000000000; //zero
        #(delay * 1.5 + 1) rst = 0;

        // special == 4 : infinity / infinity = NaN
        // output should be NaN
        #(delay * 45     ) rst = 1;
                           dividend = 32'b0_11111111_00000000000000000000000; //infinity
                           divisor  = 32'b0_11111111_00000000000000000000000; //infinity
        #(delay * 1.5 + 1) rst = 0;

        // special == 5 : dividend is NaN, quotient is NaN
        // output should be NaN
        #(delay * 45     ) rst = 1;
                           dividend = 32'b0_11111111_11110000000000000000000; //NaN
                           divisor  = 32'b0_00000000_00000000000000000000000; //zero
        #(delay * 1.5 + 1) rst = 0;

        // special == 5 : divisor is NaN, quotient is NaN
        // output should be NaN
        #(delay * 45     ) rst = 1;
                           dividend = 32'b0_01111111_10000000000000000000000; //1.5
                           divisor  = 32'b0_11111111_11110000000000000000000; //NaN
        #(delay * 1.5 + 1) rst = 0;

        // special == 5 : dividend and divisor are both NaN, quotient is NaN
        // output should be NaN
        #(delay * 45     ) rst = 1;
                           dividend = 32'b0_11111111_11110000000000000000000; //NaN
                           divisor  = 32'b0_11111111_11110000000000000000000; //NaN
        #(delay * 1.5 + 1) rst = 0;

        // special == 6 : infinity / 0 = infinity
        // output should be infinity
        #(delay * 45     ) rst = 1;
                           dividend = 32'b0_11111111_00000000000000000000000; //infinity
                           divisor  = 32'b0_00000000_00000000000000000000000; //zero
        #(delay * 1.5 + 1) rst = 0;

        // special == 7 : infinity / x = infinity (x not NaN,infinity or zero)
        // output should be infinity
        #(delay * 45     ) rst = 1;
                           dividend = 32'b0_11111111_00000000000000000000000; //infinity
                           divisor  = 32'b0_01111111_10000000000000000000000; 
        #(delay * 1.5 + 1) rst = 0;

        // special == 8 : zero / x = zero (x not NaN,infinity or zero)
        // output should be zero
        #(delay * 45     ) rst = 1;
                           dividend = 32'b0_00000000_00000000000000000000000; //zero
                           divisor  = 32'b0_01111111_10000000000000000000000; 
        #(delay * 1.5 + 1) rst = 0;

        // special == 9 : overflow, quotient is infinity
        // output should be infinity
        #(delay * 45     ) rst = 1;
                           dividend = 32'b0_10000011_01000000000000000000000; 
                           divisor  = 32'b0_00000011_01000000000000000000000;
        #(delay * 1.5 + 1) rst = 0;

        // special == 10 : quotient is zero
        // output should be zero
        #(delay * 45     ) rst = 1;
                           dividend = 32'b0_00000011_01000000000000000000000; 
                           divisor  = 32'b0_10011111_01000000000000000000000;
        #(delay * 1.5 + 1) rst = 0;

        #(delay * 100    ) $finish;

    end

endmodule
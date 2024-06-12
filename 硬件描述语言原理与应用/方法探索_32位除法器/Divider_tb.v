`timescale 1ns / 10ps

module Divider_tb;
    //inputs
    reg        clk       ;
    reg        rst       ;
    reg [31:0] dividend  ;
    reg [31:0] divisor   ;

    //outputs
    reg [31:0] remainder ;
    reg [31:0] quotient  ;

    parameter delay = 10 ;

    Divider 
        U_Divider(
            .clk(clk)            ,
            .rst(rst)            ,
            .dividend(dividend)  ,
            .divisor(divisor)    ,
            .remainder(remainder),
            .quotient(quotient)
        );

    initial begin
        //create .vpd file
        `ifdef DUMP_VPD
               $vcdpluson();
        `endif
        //create .vcd file
        $dumpfile("divider_wave.vcd");
        $dumpvars;
    end

    //clock
	always #(delay/2) clk=~clk;

    initial begin
        // initial 
        clk       = 0  ; 
        rst       = 1  ;
        
        //normal case 1
        dividend  = 74 ; //32'b0000_0000_0000_0000_0000_0000_0100_1010;
        divisor   = 8  ; //32'b0000_0000_0000_0000_0000_0000_0000_1000;
        #(delay * 1.5 + 1) rst = 0;

        //divided
        #(delay * 15     ) rst = 1; 
                           dividend = 32'b1111_0000_0000_0000_0000_0000_0000_0000 ; 
                           divisor  = 32'b0000_0000_0000_0000_0000_0000_0000_1111 ;
        #(delay * 1.5 + 1) rst = 0;

        //divisor > dividend
        #(delay * 65     ) rst = 1; dividend = 65  ; divisor = 109;
        #(delay * 1.5 + 1) rst = 0;

        //divisor is zero
        #(delay * 15     ) rst = 1; dividend = 86  ; divisor = 0  ;
        #(delay * 1.5 + 1) rst = 0;

        #(delay * 15     ) $finish;
    end

endmodule
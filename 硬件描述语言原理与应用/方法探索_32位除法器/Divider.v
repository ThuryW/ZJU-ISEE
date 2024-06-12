`timescale 1ns / 10ps

module Divider (
    input             clk        ,
    input             rst        , 
    input      [31:0] dividend   , 
    input      [31:0] divisor    , 
    output reg [31:0] remainder  , 
    output reg [31:0] quotient     
);
    //state number
    parameter WAIT = 0, GMSB = 1, NEXT = 2, SHIFT = 3, CHECK_DONE = 4;

    reg [63:0] temp_remainder    ;
    reg [63:0] new_divisor       ;
    reg [31:0] temp_a, temp_b    ;

    //L1 saves the MSB of dividend, L2 saves the MSB of divisor
    //L1,L2,f range from -31 to 31, the highest bit is the sign bit
    reg [5 :0] f, L1, L2         ; 
    reg [3 :0] state, next_state ;

    //initial 
    always @(rst) begin
        temp_a    = dividend ;
        temp_b    = divisor  ;
        L1        = 0        ;
        L2        = 0        ;
    end

    //三段式FSM
    always @(posedge clk) begin
        if (rst) 
            state <= WAIT;
        else
            state <= next_state;
    end

    always @(state) begin
        case(state)
            WAIT:
                next_state = (divisor == 0)? CHECK_DONE : GMSB;
            GMSB:
                next_state = NEXT;
            NEXT:        
                next_state = (f[5] != 0)? CHECK_DONE : SHIFT;
            SHIFT:
                next_state = CHECK_DONE;  
            CHECK_DONE:
                next_state = (f[5] != 0)? CHECK_DONE : SHIFT;
            default: ;
        endcase
    end

    always @(posedge clk) begin
        case(state)
            WAIT: begin // 0 initial
                remainder   <= dividend              ;
                quotient    <= 0                     ;
                new_divisor <= {divisor, {32{1'b0}}} ;
            end
            GMSB: begin // 1 get the MSB and subtract
                //可综合 用if
                if     (temp_a[31] == 1) L1 = 31;
                else if(temp_a[30] == 1) L1 = 30;
                else if(temp_a[29] == 1) L1 = 29;
                else if(temp_a[28] == 1) L1 = 28;
                else if(temp_a[27] == 1) L1 = 27;
                else if(temp_a[26] == 1) L1 = 26;
                else if(temp_a[25] == 1) L1 = 25;
                else if(temp_a[24] == 1) L1 = 24;
                else if(temp_a[23] == 1) L1 = 23;
                else if(temp_a[22] == 1) L1 = 22;
                else if(temp_a[21] == 1) L1 = 21;
                else if(temp_a[20] == 1) L1 = 20;
                else if(temp_a[19] == 1) L1 = 19;
                else if(temp_a[18] == 1) L1 = 18;
                else if(temp_a[17] == 1) L1 = 17;
                else if(temp_a[16] == 1) L1 = 16;
                else if(temp_a[15] == 1) L1 = 15;
                else if(temp_a[14] == 1) L1 = 14;
                else if(temp_a[13] == 1) L1 = 13;
                else if(temp_a[12] == 1) L1 = 12;
                else if(temp_a[11] == 1) L1 = 11;
                else if(temp_a[10] == 1) L1 = 10;
                else if(temp_a[9 ] == 1) L1 = 9 ;
                else if(temp_a[8 ] == 1) L1 = 8 ;
                else if(temp_a[7 ] == 1) L1 = 7 ;
                else if(temp_a[6 ] == 1) L1 = 6 ;
                else if(temp_a[5 ] == 1) L1 = 5 ;
                else if(temp_a[4 ] == 1) L1 = 4 ;
                else if(temp_a[3 ] == 1) L1 = 3 ;
                else if(temp_a[2 ] == 1) L1 = 2 ;
                else if(temp_a[1 ] == 1) L1 = 1 ;
                else                     L1 = 0 ;

                if     (temp_b[31] == 1) L2 = 31;
                else if(temp_b[30] == 1) L2 = 30;
                else if(temp_b[29] == 1) L2 = 29;
                else if(temp_b[28] == 1) L2 = 28;
                else if(temp_b[27] == 1) L2 = 27;
                else if(temp_b[26] == 1) L2 = 26;
                else if(temp_b[25] == 1) L2 = 25;
                else if(temp_b[24] == 1) L2 = 24;
                else if(temp_b[23] == 1) L2 = 23;
                else if(temp_b[22] == 1) L2 = 22;
                else if(temp_b[21] == 1) L2 = 21;
                else if(temp_b[20] == 1) L2 = 20;
                else if(temp_b[19] == 1) L2 = 19;
                else if(temp_b[18] == 1) L2 = 18;
                else if(temp_b[17] == 1) L2 = 17;
                else if(temp_b[16] == 1) L2 = 16;
                else if(temp_b[15] == 1) L2 = 15;
                else if(temp_b[14] == 1) L2 = 14;
                else if(temp_b[13] == 1) L2 = 13;
                else if(temp_b[12] == 1) L2 = 12;
                else if(temp_b[11] == 1) L2 = 11;
                else if(temp_b[10] == 1) L2 = 10;
                else if(temp_b[9 ] == 1) L2 = 9 ;
                else if(temp_b[8 ] == 1) L2 = 8 ;
                else if(temp_b[7 ] == 1) L2 = 7 ;
                else if(temp_b[6 ] == 1) L2 = 6 ;
                else if(temp_b[5 ] == 1) L2 = 5 ;
                else if(temp_b[4 ] == 1) L2 = 4 ;
                else if(temp_b[3 ] == 1) L2 = 3 ;
                else if(temp_b[2 ] == 1) L2 = 2 ;
                else if(temp_b[1 ] == 1) L2 = 1 ;
                else                     L2 = 0 ;

                // f = L1 - L2;
                f = L1 + (~L2 + 1);
            end
            NEXT: begin // 2
                temp_remainder   <= {dividend, {32{1'b0}}} ;
                quotient         <= 0                      ;
                case(f)
                    0 : new_divisor <= {new_divisor[63:0], { 0{1'b0}}};
                    1 : new_divisor <= {new_divisor[62:0], { 1{1'b0}}};
                    2 : new_divisor <= {new_divisor[61:0], { 2{1'b0}}};
                    3 : new_divisor <= {new_divisor[60:0], { 3{1'b0}}};
                    4 : new_divisor <= {new_divisor[59:0], { 4{1'b0}}};
                    5 : new_divisor <= {new_divisor[58:0], { 5{1'b0}}};
                    6 : new_divisor <= {new_divisor[57:0], { 6{1'b0}}};
                    7 : new_divisor <= {new_divisor[56:0], { 7{1'b0}}};
                    8 : new_divisor <= {new_divisor[55:0], { 8{1'b0}}};
                    9 : new_divisor <= {new_divisor[54:0], { 9{1'b0}}};
                    10: new_divisor <= {new_divisor[53:0], {10{1'b0}}};
                    11: new_divisor <= {new_divisor[52:0], {11{1'b0}}};
                    12: new_divisor <= {new_divisor[51:0], {12{1'b0}}};
                    13: new_divisor <= {new_divisor[50:0], {13{1'b0}}};
                    14: new_divisor <= {new_divisor[49:0], {14{1'b0}}};
                    15: new_divisor <= {new_divisor[48:0], {15{1'b0}}};
                    16: new_divisor <= {new_divisor[47:0], {16{1'b0}}};
                    17: new_divisor <= {new_divisor[46:0], {17{1'b0}}};
                    18: new_divisor <= {new_divisor[45:0], {18{1'b0}}};
                    19: new_divisor <= {new_divisor[44:0], {19{1'b0}}};
                    20: new_divisor <= {new_divisor[43:0], {20{1'b0}}};
                    21: new_divisor <= {new_divisor[42:0], {21{1'b0}}};
                    22: new_divisor <= {new_divisor[41:0], {22{1'b0}}};
                    23: new_divisor <= {new_divisor[40:0], {23{1'b0}}};
                    24: new_divisor <= {new_divisor[39:0], {24{1'b0}}};
                    25: new_divisor <= {new_divisor[38:0], {25{1'b0}}};
                    26: new_divisor <= {new_divisor[37:0], {26{1'b0}}};
                    27: new_divisor <= {new_divisor[36:0], {27{1'b0}}};
                    28: new_divisor <= {new_divisor[35:0], {28{1'b0}}};
                    29: new_divisor <= {new_divisor[34:0], {29{1'b0}}};
                    30: new_divisor <= {new_divisor[33:0], {30{1'b0}}};
                    31: new_divisor <= {new_divisor[32:0], {31{1'b0}}};
                    default: ;
                endcase
                
            end
            SHIFT: begin // 3
                if(temp_remainder >= new_divisor) begin
                    quotient       <= {quotient[30:0], 1'b1}       ;
                    temp_remainder <= temp_remainder - new_divisor ;
                    new_divisor    <= {1'b0, new_divisor[62:1]}    ;
                end
                else begin
                    quotient       <= {quotient[30:0], 1'b0}    ;
                    temp_remainder <= temp_remainder            ;
                    new_divisor    <= {1'b0, new_divisor[62:1]} ;
                end   
                f = f + 6'b111111;             
            end
            CHECK_DONE: begin // 4
                //if divisor is zero ,set quotient to max value, set remainder to dividend
                if(divisor == 0) begin
                    remainder <= dividend   ;
                    quotient  <= {32{1'b1}} ;
                end
                else begin
                    remainder <= temp_remainder[63:32] ;
                end;
            end
            default: ;
        endcase
    end

endmodule
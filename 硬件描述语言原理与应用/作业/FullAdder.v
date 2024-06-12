module FullAdder (
    input  a  ,
    input  b  ,
    input  ci ,
    output s  ,
    output co 
);   
    wire temp1, temp2, temp3;

    HalfAdder U1_HalfAdder(.a(a), .b(b), .s(temp1), .co(temp2));
    HalfAdder U2_HalfAdder(.a(ci), .b(temp1), .s(s), .co(temp3));
    assign co = temp2 | temp3;

endmodule
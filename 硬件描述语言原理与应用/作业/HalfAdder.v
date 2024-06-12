module HalfAdder (
    input  a ,
    input  b ,
    output co,
    output s 
);
    assign {co, s} = a + b;
endmodule
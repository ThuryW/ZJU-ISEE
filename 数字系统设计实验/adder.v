module adder(a,b,s,ci,co);
    parameter n = 22;
    input [n-1:0] a,b;
    input ci;
    output [n-1:0] s;
    output co;
    assign {co,s}=a+b+ci; 
endmodule
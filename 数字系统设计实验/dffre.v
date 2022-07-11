module dffre(clk,d,en,r,q);//D触发器子模块
    parameter n = 21;
    input clk;
    input [n-1:0] d;
    input en,r;
    output reg [n-1:0] q=0; //q初始化为0
    always@(posedge clk) begin
        if(r) q=0;  //复位
        else if(en) q=d;
    end
endmodule
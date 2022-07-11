module timer(clk,r,en,done);//定时器
    parameter n=4, counter_bits=2;
    input clk,r,en;
    output reg done=0;
    reg [counter_bits-1:0] q=0;//计数变量
    always@(posedge clk) begin
        done=en&&(q==n-1);//定时结束
        if(r) q=0;
        else if(en) q=q+1;
        else q=q;
    end
endmodule
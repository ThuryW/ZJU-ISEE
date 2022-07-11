module counter_n(clk,r,en,q,co);//计数器 分频器
    parameter n=4, counter_bits=2;
    input clk,r,en;
    output reg co=0;
    output reg [counter_bits-1:0] q=0;
    always@(posedge clk) begin
        co=en&&(q==n-1); //进位输出
        //计算q输出
        if(r) q=0;
        else if(en) q=(q==n-1)?0:q+1;
        else q=q;
    end
endmodule
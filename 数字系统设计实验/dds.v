module dds(k,clk,reset,sampling_pulse,sample,new_sample_ready);
    input clk,reset,sampling_pulse;
    input [21:0] k;
    output [15:0] sample;
    output new_sample_ready;
    wire [21:0] raw_addr;    
    wire [21:0] adder_result;
    wire [15:0] data;

    //相位累加器
    adder #(.n(22)) adder1(.a(k),.b(raw_addr),.s(adder_result),.ci(1'b0),.co());
    dffre #(.n(22)) dffre1(.clk(clk), .d(adder_result), .en(sampling_pulse), .r(reset), .q(raw_addr));

    wire [9:0] rom_addr;
    wire [15:0] raw_data;
    //地址处理，用组合电路
    assign rom_addr[9:0]=(raw_addr[20]==0)?raw_addr[19:10]:((raw_addr[20:10]==1024)?1023:~raw_addr[19:10]+1);

    //生成正弦
    sine_rom sin1(.clk(clk), .addr(rom_addr), .dout(raw_data));

    //数据处理，用组合电路
    dffre #(.n(1)) dffre4(.clk(clk), .d(raw_addr[21]), .en(1'b1), .r(1'b0), .q(area)); //生成area
    assign data[15:0]=(area==0)?raw_data[15:0]:~raw_data[15:0]+1;

    //输出结果
    dffre #(.n(16)) dffre2(.clk(clk), .d(data), .en(sampling_pulse), .r(1'b0), .q(sample));
    dffre #(.n(1)) dffre3(.clk(clk), .d(sampling_pulse), .en(1'b1), .r(1'b0), .q(new_sample_ready));
endmodule
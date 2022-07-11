module note_player(
    input clk,
    input reset,
    input play_enable,
    input [5:0] note_to_load,
    input [5:0] duration_to_load,
    input load_new_note,
    output reg note_done,
    input sampling_pulse,
    input beat,
    output sample_ready,
    output [15:0] sample
);
    reg load,timer_clear,timer_done=0;
    wire [5:0] temp_q;
    wire [19:0] temp_dout;
    //控制器模块
    parameter RESET=0, WAIT=1, DONE=2, LOAD=3;
    reg [1:0] state,nextstate;
    always@(posedge clk) begin
        if(reset) state=RESET;
        else state=nextstate;
    end
    always@(*) begin
        timer_clear=0;load=0;note_done=0;//默认为0
        case (state)
            RESET:
                begin
                    timer_clear=1;load=0;note_done=0;
                    nextstate=WAIT;
                end
            WAIT:
                begin
                    timer_clear=0;load=0;note_done=0;
                    if(!play_enable) nextstate=RESET;
                    else if(timer_done) nextstate=DONE;
                    else if(load_new_note) nextstate=LOAD;
                    else nextstate=WAIT;
                end
            DONE:
                begin
                    timer_clear=1;load=0;note_done=1;
                    nextstate=WAIT;
                end
            LOAD:
                begin
                    timer_clear=1;load=1;note_done=0;
                    nextstate=WAIT;
                end
        endcase
    end

    //音符节拍定时器
    reg [5:0] q=0;//计数变量
    always@(posedge clk) begin
        timer_done=beat&&(q==duration_to_load-1);//定时结束
        if(timer_clear) q=0;
        else if(beat) q=q+1;
        else q=q;
    end

    //数据通道
    dffre #(.n(6)) dffre1(.clk(clk), .d(note_to_load), .r((~play_enable)|reset), .en(load), .q(temp_q));
    frequency_rom FreqROM(.clk(clk), .addr(temp_q), .dout(temp_dout));
    dds DDS(.clk(clk), .sampling_pulse(sampling_pulse), .k({2'b00,temp_dout}), .reset(1'b0), .new_sample_ready(sample_ready), .sample(sample));
endmodule
module mcu(
    input clk,
    input reset,
    input next,
    input play_pause,
    input song_done,
    output reg play,
    output reg reset_play,
    output [1:0] song
    );
    parameter RESET=0,PAUSE=1,PLAY=2,NEXT=3;//状态编码
    reg [1:0] state,nextstate;
    reg NextSong;
    //第一段，时序电路，D寄存器
    always@(posedge clk) begin
        if(reset) state=RESET;
        else state=nextstate;
    end
    //第二段，组合电路，下一状态和输出
    always@(*) begin
        play=0;NextSong=0;reset_play=0;//默认为0
        case (state)
            RESET:
                begin
                    play=0;NextSong=0;reset_play=1;
                    nextstate=PAUSE;
                end
            PAUSE:
                begin
                    play=0;NextSong=0;reset_play=0;
                    if(play_pause) nextstate=PLAY;
                    else if(next) nextstate=NEXT;
                    else nextstate=PAUSE;
                end
            PLAY:
                begin
                    play=1;NextSong=0;reset_play=0;
                    if(play_pause) nextstate=PAUSE;
                    else if(next) nextstate=NEXT;
                    else if(song_done) nextstate=RESET;
                    else nextstate=PLAY;
                end
            NEXT:
                begin
                    play=0;NextSong=1;reset_play=1;
                    nextstate=PLAY;
                end
        endcase
    end
    //2位二进制计数器
    counter_n #(.n(4),.counter_bits(2)) counter1(.clk(clk), .r(1'b0), .en(NextSong), .q(song));
endmodule
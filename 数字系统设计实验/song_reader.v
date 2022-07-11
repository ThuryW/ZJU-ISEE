module song_reader(
    input clk,
    input reset,
    input play,
    input [1:0] song,
    input note_done,
    output reg song_done,
    output reg [5:0] note,
    output reg [5:0] duration,
    output reg new_note);
    //输出初始化
    initial begin
        note=0;
        duration=0;
    end
    parameter RESET=0,NEW_NOTE=1,WAIT=2,NEXT_NOTE=3;//状态编码
    wire [6:0] addr; //7位音符地址

    //控制器
    reg [1:0] state,nextstate;
    reg NextSong;
    always@(posedge clk) begin//第一段，时序电路，D寄存器
        if(reset) state=RESET;
        else state=nextstate;
    end
    always@(*) begin//第二段，组合电路，下一状态和输出
        new_note=0;
        case (state)
            RESET: 
                begin
                    new_note=0;
                    nextstate=(play==1)?NEW_NOTE:RESET;
                end
            NEW_NOTE:
                begin
                    new_note=1;
                    nextstate=WAIT;
                end
            WAIT:
                begin
                    new_note=0;
                    if(play==0) nextstate=RESET;
                    else if(note_done==0) nextstate=WAIT;
                    else nextstate=NEXT_NOTE;  
                end
            NEXT_NOTE: 
                begin
                    new_note=0;
                    nextstate=NEW_NOTE;
                end
        endcase
    end

    //数据通道模块
    wire co;
    wire [11:0] dout;
    counter_n #(.n(32),.counter_bits(5)) counter1(.clk(clk),.r(reset),.en(note_done),.q(addr[4:0]),.co(co));//地址计数器
    assign addr[6:5]=song[1:0];//拼接完整地址
    song_rom rom1(.clk(clk),.addr(addr),.dout(dout));//读取音符
    always@(*) {note[5:0],duration[5:0]}=dout;

    //结束判断状态机
    parameter NOT_DONE=0,DONE=1,DONE_WAIT=2;
    reg [1:0] end_state=0,end_nextstate;
    always@(posedge clk) begin//第一段
        end_state=end_nextstate;
    end
    always@(*) begin//第二段
        song_done=0;
        case (end_state)
            NOT_DONE:
                begin
                    song_done=0;
                    if(co==1 || duration==0) end_nextstate=DONE;
                    else end_nextstate=NOT_DONE;
                end 
            DONE:
                begin
                    song_done=1;
                    end_nextstate=DONE_WAIT;
                end   
            DONE_WAIT:
                begin
                    song_done=0;
                    if(duration==0) end_nextstate=DONE_WAIT;
                    else end_nextstate=NOT_DONE;
                end
        endcase
    end
endmodule
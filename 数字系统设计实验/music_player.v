module music_player(
    input clk, 
	input reset,
	input play_pause, 
	input next,
	input NewFrame, 
	output [15:0] sample, 
	output play, 
	output [1:0] song
);
	parameter sim=0;
	wire song_done,reset_play,note_done,new_note;
	wire [5:0] note_to_play,duration_for_note;
	wire tempd1,tempd2,ready,beat;
    //主控制器mcu
    mcu MCU(
		.clk(clk),.reset(reset),.next(next),.play_pause(play_pause),.song_done(song_done),
		.play(play),.reset_play(reset_play),.song(song)
		);
	
	//乐曲读取song_reader
	song_reader SONGREADER(
		.clk(clk),.reset(reset_play),.play(play),.song(song),.note_done(note_done),
		.song_done(song_done),.note(note_to_play), .duration(duration_for_note),.new_note(new_note)
		);
	
	//同步化电路
	dffre #(.n(1)) dffre1(.clk(clk),.r(1'b0),.en(1'b1),.d(NewFrame),.q(tempd1));
	dffre #(.n(1)) dffre2(.clk(clk),.r(1'b0),.en(1'b1),.d(tempd1),.q(tempd2));
	assign ready=tempd1 & (~tempd2);

	//分频器（节拍产生器）
	counter_n #(.n(sim?64:1000),.counter_bits(10)) counter_n1(.clk(clk),.r(1'b0),.en(ready),.q(),.co(beat));

	//音符播放
	note_player NOTEPLAYER(
		.clk(clk),.reset(reset_play),.play_enable(play),.note_to_load(note_to_play),.duration_to_load(duration_for_note),
		.load_new_note(new_note),.note_done(note_done),.sampling_pulse(ready),.beat(beat),
		.sample_ready(),.sample(sample)
		);
endmodule
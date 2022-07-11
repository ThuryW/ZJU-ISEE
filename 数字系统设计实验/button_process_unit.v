//
// This module synchronizes, debounces, and one-pulses a button input.
//
module button_process_unit(
  input clk,
  input reset,
  input ButtonIn,
  output ButtonOut
  );
  parameter sim=100000;//分频比

  //同步器模块,两个D触发器
  wire asynch_in;
  wire temp,synch_out;
  assign asynch_in=ButtonIn;
  dffre #(.n(1)) dffre1(.clk(clk), .r(1'b0), .en(1'b1), .d(asynch_in), .q(temp));
  dffre #(.n(1)) dffre2(.clk(clk), .r(1'b0), .en(1'b1), .d(temp), .q(synch_out));
  
  //防颤动电路模块
  parameter LOW=0,WAIT_HIGH=1,HIGH=2,WAIT_LOW=3;
  wire pulse1kHz,timer_done;
  reg timer_clr,v0,in;
  reg [1:0] state,nextstate;

  counter_n #(.n(sim?32:100000), .counter_bits(17)) counter_n1(.clk(clk), .r(1'b0), .en(1'b1), .q(), .co(pulse1kHz));//分频器
  timer #(.n(sim?32:100000), .counter_bits(20)) timer1(.clk(clk), .en(pulse1kHz), .r(timer_clr), .done(timer_done));//计时器
  //第一段，时序电路，D寄存器
  always@(posedge clk) begin
    if(reset) state=LOW;
    else state=nextstate;
  end
  //第二段，组合电路，下一状态和输出
  always@(*) begin
    in=synch_out;//输入in即上一个模块的输出synch_out
    timer_clr=0;v0=0;//默认为0
    case (state)
      LOW:
        begin
          timer_clr=1;v0=0;
          nextstate=(in==1)?WAIT_HIGH:LOW;
        end
      WAIT_HIGH:
        begin
          timer_clr=0;v0=1;
          nextstate=(timer_done==1)?HIGH:WAIT_HIGH;
        end
      HIGH:
        begin
          timer_clr=1;v0=1;
          nextstate=(in==1)?HIGH:WAIT_LOW;
        end
      WAIT_LOW:
        begin
          timer_clr=0;v0=1;
          nextstate=(timer_done==1)?LOW:WAIT_LOW;
        end
      endcase
  end

  //脉宽变换电路模块
  wire temp1;
  dffre #(.n(1)) dffre3(.clk(clk), .r(1'b0), .en(1'b1), .d(v0), .q(temp1));
  assign ButtonOut=v0 & (~temp1); //与门

endmodule
   
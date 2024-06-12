`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV-Pipline CPU
// Module Name: HarzardUnit
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: Deal with harzards in pipline
//////////////////////////////////////////////////////////////////////////////////
module HarzardUnit(
    input wire CpuRst, ICacheMiss, DCacheMiss, 
    input wire BranchE, JalrE, JalD, 
    input wire [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdMW,
    input wire [1:0] RegReadE,
    input wire MemToRegE,
    input wire [2:0] RegWriteMW,
    output reg StallF, FlushF, StallD, FlushD, StallE, FlushE, StallMW, FlushMW,
    output reg Forward1E, Forward2E
);
    
    //无需综合，直接用initial初始化全部置0
    initial begin
        StallF  <= 1'b0;
        StallD  <= 1'b0;
        StallE  <= 1'b0;
        StallMW <= 1'b0;
        FlushF  <= 1'b0;
        FlushD  <= 1'b0;
        FlushE  <= 1'b0;
        FlushMW <= 1'b0;
        Forward1E <= 1'b0;
        Forward2E <= 1'b0;
    end
    
    //Stall and Flush signals generate
    always @(*) begin
        if(CpuRst) begin //CpuRst信号，全局复位清零，即全部寄存器重新冲洗
            FlushF  <= 1'b1;
            FlushD  <= 1'b1;
            FlushE  <= 1'b1;
            FlushMW <= 1'b1;
            StallF  <= 1'b0;
            StallD  <= 1'b0;
            StallE  <= 1'b0;
            StallMW <= 1'b0;
        end
        else begin
            if(DCacheMiss) begin // Cache miss
                StallF  <= 1'b1;
                StallD  <= 1'b1;
                StallE  <= 1'b1;
                StallMW <= 1'b1;
                FlushF  <= 1'b0;
                FlushD  <= 1'b0;
                FlushE  <= 1'b0;
                FlushMW <= 1'b0;
            end
            else if(JalrE || BranchE) begin
                //分支跳转导致的控制冒险，如果需要跳转则需要冲洗流水线
                //分支预测，先往下执行，再考虑冲洗
                //在执行阶段才能确定跳转
                //此时IF马上要重新取目标PC值，而ID和EX中则马上要更新为分支指令的下一条和下下条指令，必须冲洗
                StallF  <= 1'b0;
                StallD  <= 1'b0;
                StallE  <= 1'b0;
                StallMW <= 1'b0;
                FlushF  <= 1'b0;
                FlushD  <= 1'b1;
                FlushE  <= 1'b1;
                FlushMW <= 1'b0;
            end
            else if(MemToRegE == 1'b1 && (Rs1D == RdE || Rs2D == RdE)) begin
                //当正在Ex执行阶段的指令是load指令，并且下条指令需要用到load结果，则流水线停顿一个周期
                //IF, ID需要保持不变，同时EX插入一个nop气泡
                StallF  <= 1'b1;
                StallD  <= 1'b1;
                StallE  <= 1'b0;
                StallMW <= 1'b0;
                FlushF  <= 1'b0;
                FlushD  <= 1'b0;
                FlushE  <= 1'b1;                
                FlushMW <= 1'b0;
            end
            else if(JalD) begin
                //在该指令执行到ID阶段就已经确定要无条件跳转
                //此时IF马上要重新取目标PC值，而ID则马上要更新为分支指令的下一条指令，必须冲洗
                StallF  <= 1'b0;
                StallD  <= 1'b0;
                StallE  <= 1'b0;
                StallMW <= 1'b0;
                FlushF  <= 1'b0;
                FlushD  <= 1'b1;
                FlushE  <= 1'b0;
                FlushMW <= 1'b0;
            end
            else begin
                StallF  <= 1'b0;
                StallD  <= 1'b0;
                StallE  <= 1'b0;
                StallMW <= 1'b0;
                FlushF  <= 1'b0;
                FlushD  <= 1'b0;
                FlushE  <= 1'b0;
                FlushMW <= 1'b0;
            end
        end
    end

    //Forward Register Source 1
    always @(*) begin
        if(Rs1E == RdMW && RdMW != 0 && RegWriteMW!=3'b0 && RegReadE[1] == 1'b1)
            //当正在Ex执行阶段的指令中，Rs1需要用到上条指令的计算结果，则数据前递
            Forward1E <= 1'b1;
        else
            Forward1E <= 1'b0;
    end

    //Forward Register Source 2
    always @(*) begin
        if(Rs2E == RdMW && RdMW != 0 && RegWriteMW!=3'b0 && RegReadE[0] == 1'b1)
            //当正在Ex执行阶段的指令中，Rs1需要用到上条指令的计算结果，则数据前递
            Forward2E <= 1'b1;
        else
            Forward2E <= 1'b0;
    end


endmodule

//功能说明
    //HarzardUnit用来处理流水线冲突，通过插入气泡，forward以及冲刷流水段解决数据相关和控制相关，组合逻辑电路
    //可以最后实现。前期测试CPU正确性时，可以在每两条指令间插入四条空指令，然后直接把本模块输出定为，不forward，不stall，不flush 
//输入
    //CpuRst                                    外部信号，用来初始化CPU，当CpuRst==1时CPU全局复位清零（所有段寄存器flush），Cpu_Rst==0时cpu开始执行指令
    //ICacheMiss, DCacheMiss                    为后续实验预留信号，暂时可以无视，用来处理cache miss
    //BranchE, JalrE, JalD                      用来处理控制相关
    //Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdMW     	用来处理数据相关，分别表示源寄存器1号码，源寄存器2号码，目标寄存器号码
    //RegReadE RegReadD[1]==1                   表示A1对应的寄存器值被使用到了，RegReadD[0]==1表示A2对应的寄存器值被使用到了，用于forward的处理
    //RegWriteMW                      			用来处理数据相关，RegWrite!=3'b0说明对目标寄存器有写入操作
    //MemToRegE                                 表示Ex段当前指令 从Data Memory中加载数据到寄存器中
//输出
    //StallF, FlushF, StallD, FlushD, StallE, FlushE, StallMW, FlushMW    控制四个段寄存器进行stall（维持状态不变）和flush（清零）
    //Forward1E, Forward2E                                                              控制forward
//实验要求  
    //实现HarzardUnit模块   
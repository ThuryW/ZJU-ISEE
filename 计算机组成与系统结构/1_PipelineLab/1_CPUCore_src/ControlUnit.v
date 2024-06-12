`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV-Pipline CPU
// Module Name: ControlUnit
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: RISC-V Instruction Decoder
//////////////////////////////////////////////////////////////////////////////////
`include "Parameters.v"   
`define ControlOut {{JalD,JalrD},{MemToRegD},{RegWriteD},{MemWriteD},{LoadNpcD},{RegReadD},{BranchTypeD},{AluContrlD},{AluSrc1D,AluSrc2D},{ImmType}}
module ControlUnit(
    input wire [6:0] Op,
    input wire [2:0] Fn3,
    input wire [6:0] Fn7,
    output reg JalD,
    output reg JalrD,
    output reg [2:0] RegWriteD,
    output reg MemToRegD,
    output reg [3:0] MemWriteD,
    output reg LoadNpcD,
    output reg [1:0] RegReadD,
    output reg [2:0] BranchTypeD,
    output reg [3:0] AluContrlD,
    output reg [1:0] AluSrc2D,
    output reg AluSrc1D,
    output reg [2:0] ImmType
);
    always @(*) begin
        case(Op)
            `R: begin
                JalD      <= 0;
                JalrD     <= 0;
                RegWriteD <= `LW;
                MemToRegD <= 0;
                MemWriteD <= 4'b0;
                LoadNpcD  <= 0;
                RegReadD  <= 2'b11;
                BranchTypeD <= `NOBRANCH;
                AluSrc1D  <= 0;     
                AluSrc2D  <= 2'b00;
                ImmType   <= `RTYPE;
                case(Fn3)
                    3'b000:
                        if(Fn7 == 7'b0000000) 
                            AluContrlD <= `ADD;
                        else 
                            AluContrlD <= `SUB;
                    3'b001:
                        AluContrlD <= `SLL;
                    3'b010:
                        AluContrlD <= `SLT;
                    3'b011:
                        AluContrlD <= `SLTU;
                    3'b100:
                        AluContrlD <= `XOR;
                    3'b101:
                        if(Fn7 == 7'b0000000) 
                            AluContrlD <= `SRL;
                        else 
                            AluContrlD <= `SRA;
                    3'b110:
                        AluContrlD <= `OR;
                    default: //3'b111
                        AluContrlD <= `AND;
                endcase
            end
            `I: begin
                JalD      <= 0;
                JalrD     <= 0;
                RegWriteD <= `LW;
                MemToRegD <= 0;
                MemWriteD <= 4'b0;
                LoadNpcD  <= 0;
                RegReadD  <= 2'b10;
                BranchTypeD <= `NOBRANCH;
                AluSrc1D  <= 0;     
                AluSrc2D  <= 2'b10;
                ImmType   <= `ITYPE;
                case(Fn3)
                    3'b000: //ADDI
                        AluContrlD <= `ADD;
                    3'b001: //SLLI
                        AluContrlD <= `SLL;
                    3'b010: //SLTI
                        AluContrlD <= `SLT;
                    3'b011: //SLTIU
                        AluContrlD <= `SLTU;
                    3'b100: //XORI
                        AluContrlD <= `XOR;
                    3'b101: //SRLI SRAI
                        if(Fn7 == 7'b0000000) 
                            AluContrlD <= `SRL;
                        else 
                            AluContrlD <= `SRA;
                    3'b110: //ORI
                        AluContrlD <= `OR;
                    3'b111: //ANDI
                        AluContrlD <= `AND;
                    default: ;
                endcase
            end
            `I_Load: begin
                JalD      <= 0;
                JalrD     <= 0;
                //RegWriteD
                MemToRegD <= 1;
                MemWriteD <= 4'b0;
                LoadNpcD  <= 0;
                RegReadD  <= 2'b10;
                BranchTypeD <= `NOBRANCH;
                AluSrc1D  <= 0;     
                AluSrc2D  <= 2'b10;
                ImmType   <= `ITYPE;
                AluContrlD <= `ADD;
                case(Fn3)
                    3'b000: //LB
                        RegWriteD <= `LB;
                    3'b001: //LH
                        RegWriteD <= `LH;
                    3'b010: //LW
                        RegWriteD <= `LW;
                    3'b100: //LBU
                        RegWriteD <= `LBU;
                    3'b101: //LHU
                        RegWriteD <= `LHU;    
                    default: ;
                endcase
            end
            `S: begin
                JalD      <= 0;
                JalrD     <= 0;
                RegWriteD <= `NOREGWRITE;
                MemToRegD <= 1;
                //MemWriteD
                LoadNpcD  <= 0;
                RegReadD  <= 2'b11;
                BranchTypeD <= `NOBRANCH;
                AluSrc1D  <= 0;     
                AluSrc2D  <= 2'b10;
                ImmType   <= `STYPE;
                AluContrlD <= `ADD;
                case(Fn3)
                    3'b000: //SB
                        MemWriteD <= 4'b0001;
                    3'b001: //SH
                        MemWriteD <= 4'b0011;
                    3'b010: //SW
                        MemWriteD <= 4'b1111;
                    default: ;
                endcase
            end
            `B: begin
                JalD      <= 0;
                JalrD     <= 0;
                RegWriteD <= `NOREGWRITE;
                MemToRegD <= 1;
                MemWriteD <= 4'b0
                LoadNpcD  <= 0;
                RegReadD  <= 2'b11;
                //BranchTypeD
                AluSrc1D  <= 0;     
                AluSrc2D  <= 2'b00;
                ImmType   <= `BTYPE;
                AluContrlD <= `SLT;
                case(Fn3)
                    3'b000: //BEQ
                        BranchTypeD <= `BEQ;
                    3'b001: //BNE                        
                        BranchTypeD <= `BNE;
                    3'b100: //BLT
                        BranchTypeD <= `BLT;
                    3'b101: //BGE                        
                        BranchTypeD <= `BGE;
                    3'b110: //BLTU
                        BranchTypeD <= `BLTU;
                    3'b111: //BGEU
                        BranchTypeD <= `BGEU;
                    default: ;
                endcase
            end
            `U_LUI: begin
                JalD      <= 0;
                JalrD     <= 0;
                RegWriteD <= `LW;
                MemToRegD <= 0;
                MemWriteD <= 4'b0
                LoadNpcD  <= 0;
                RegReadD  <= 2'b00;
                BranchTypeD <= `NOBRANCH;
                AluSrc1D  <= 0;     
                AluSrc2D  <= 2'b10;
                ImmType   <= `UTYPE;
                AluContrlD <= `LUI;
            end
            `U_AUIPC: begin
                JalD      <= 0;
                JalrD     <= 0;
                RegWriteD <= `LW;
                MemToRegD <= 0;
                MemWriteD <= 4'b0
                LoadNpcD  <= 0;
                RegReadD  <= 2'b00;
                BranchTypeD <= `NOBRANCH;
                AluSrc1D  <= 1;     
                AluSrc2D  <= 2'b10;
                ImmType   <= `UTYPE;
                AluContrlD <= `ADD;
            end
            `J_JAL: begin
                JalD      <= 1;
                JalrD     <= 0;
                RegWriteD <= `LW;
                MemToRegD <= 0;
                MemWriteD <= 4'b0
                LoadNpcD  <= 1;
                RegReadD  <= 2'b00;
                BranchTypeD <= `NOBRANCH;
                AluSrc1D  <= 1;     
                AluSrc2D  <= 2'b10;
                ImmType   <= `JTYPE;
                AluContrlD <= `ADD;
            end
            `J_JALR: begin
                JalD      <= 0;
                JalrD     <= 1;
                RegWriteD <= `LW;
                MemToRegD <= 0;
                MemWriteD <= 4'b0
                LoadNpcD  <= 1;
                RegReadD  <= 2'b00;
                BranchTypeD <= `NOBRANCH;
                AluSrc1D  <= 0;     
                AluSrc2D  <= 2'b10;
                ImmType   <= `ITYPE;
                AluContrlD <= `ADD;
            end
            default: begin
                // 避免综合出锁存器
                JalD      <= 0;
                JalrD     <= 0;
                RegWriteD <= `NOREGWRITE;
                MemToRegD <= 0;
                MemWriteD <= 4'b0
                LoadNpcD  <= 0;
                RegReadD  <= 2'b00;
                BranchTypeD <= `NOBRANCH;
                AluSrc1D  <= 0;     
                AluSrc2D  <= 2'b00;
                ImmType   <= `RTYPE;
                AluContrlD <= `ADD;
            end
        endcase
    end

endmodule

//功能说明
    //ControlUnit       是本CPU的指令译码器，组合逻辑电路
//输入
    // Op               是指令的操作码部分
    // Fn3              是指令的func3部分
    // Fn7              是指令的func7部分
//输出
    // JalD==1          表示Jal指令到达ID译码阶段
    // JalrD==1         表示Jalr指令到达ID译码阶段
    // RegWriteD        表示ID阶段的指令对应的 寄存器写入模式 ，所有模式定义在Parameters.v中
    // MemToRegD==1     表示ID阶段的指令需要将data memory读取的值写入寄存器,
    // MemWriteD        共4bit，采用独热码格式，对于data memory的32bit字按byte进行写入,MemWriteD=0001表示只写入最低1个byte，和xilinx bram的接口类似
    // LoadNpcD==1      表示将NextPC输出到ResultM
    // RegReadD[1]==1   表示A1对应的寄存器值被使用到了，RegReadD[0]==1表示A2对应的寄存器值被使用到了，用于forward的处理
    // BranchTypeD      表示不同的分支类型，所有类型定义在Parameters.v中
    // AluContrlD       表示不同的ALU计算功能，所有类型定义在Parameters.v中
    // AluSrc2D         表示Alu输入源2的选择
    // AluSrc1D         表示Alu输入源1的选择
    // ImmType          表示指令的立即数格式，所有类型定义在Parameters.v中   
//实验要求  
    //实现ControlUnit模块   
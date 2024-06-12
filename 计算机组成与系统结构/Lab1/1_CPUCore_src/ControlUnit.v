`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV CPU
// Module Name: ControlUnit
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: RISC-V Instruction Decoder
//////////////////////////////////////////////////////////////////////////////////
`include "Parameters.v"   
`define ControlOut {{Jal,Jalr},{MemToReg},{RegWrite},{MemWrite},{LoadNpc},{RegRead},{BranchType},{AluContrl},{AluSrc1,AluSrc2},{ImmType}}
module ControlUnit(
    input wire [6:0] Op,
    input wire [2:0] Fn3,
    input wire [6:0] Fn7,
	input wire [31:7] In,
	//input wire [2:0] Type,
    output reg Jal,
    output reg Jalr,
    output reg [2:0] RegWrite,
    output reg MemToReg,
    output reg [3:0] MemWrite,
    output reg LoadNpc,
    output reg [1:0] RegRead,
    output reg [2:0] BranchType,
    output reg [3:0] AluContrl,
    output reg [1:0] AluSrc2,
    output reg AluSrc1,
    output reg [2:0] ImmType,
	output reg [31:0] Imm
);
    always @(*) begin
        case(Op)
            `R: begin
                Jal      <= 0;           //不需要跳�?
                Jalr     <= 0;
                RegWrite <= `LW;         //直接写入到寄存器
                MemToReg <= 0;           //选择RegWriteData = Result
                MemWrite <= 4'b0;        //不需写入到Memory
                LoadNpc  <= 0;           //选择Result = AluOut
                RegRead  <= 2'b11;       //用到�?2个寄存器
                BranchType <= `NOBRANCH; //不涉及Branch
                AluSrc1  <= 0;           //ALU第一个输入�?�择Reg1
                AluSrc2  <= 2'b00;       //ALU第二个输入�?�择Reg2
                ImmType  <= `RTYPE;
                Imm      <= 0;           //不会用到Imm
                /*�?有的R指令*/
                case(Fn3)
                    3'b000:
                        if(Fn7 == 7'b0000000) 
                            AluContrl <= `ADD;
                        else 
                            AluContrl <= `SUB;
                    3'b001:
                        AluContrl <= `SLL;
                    3'b010:
                        AluContrl <= `SLT;
                    3'b011:
                        AluContrl <= `SLTU;
                    3'b100:
                        AluContrl <= `XOR;
                    3'b101:
                        if(Fn7 == 7'b0000000) 
                            AluContrl <= `SRL;
                        else 
                            AluContrl <= `SRA;
                    3'b110:
                        AluContrl <= `OR;
                    default: //3'b111
                        AluContrl <= `AND;
                endcase
            end
            `I: begin
                Jal      <= 0;           //不需要跳�?
                Jalr     <= 0;
                RegWrite <= `LW;         //直接写入到寄存器
                MemToReg <= 0;           //选择RegWriteData = Result
                MemWrite <= 4'b0;        //不需写入到Memory
                LoadNpc  <= 0;           //选择Result = AluOut
                RegRead  <= 2'b10;       //只用到第�?个寄存器
                BranchType <= `NOBRANCH; //不涉及Branch
                AluSrc1  <= 0;           //ALU第一个输入�?�择Reg1
                AluSrc2  <= 2'b10;       //ALU第二个输入�?�择Imm
                ImmType  <= `ITYPE;
                Imm      <= {{20{In[31]}}, In[31:20]}; //I指令�?�?的立即数   
                /*�?有的I格式算术指令*/       
                case(Fn3)
                    3'b000: //ADDI
                        AluContrl <= `ADD;
                    3'b001: //SLLI
                        AluContrl <= `SLL;
                    3'b010: //SLTI
                        AluContrl <= `SLT;
                    3'b011: //SLTIU
                        AluContrl <= `SLTU;
                    3'b100: //XORI
                        AluContrl <= `XOR;
                    3'b101: //SRLI SRAI
                        if(In[30] == 1'b0) 
                            AluContrl <= `SRL;
                        else 
                            AluContrl <= `SRA;
                    3'b110: //ORI
                        AluContrl <= `OR;
                    3'b111: //ANDI
                        AluContrl <= `AND;
                    default: ;
                endcase
            end
            `I_Load: begin
                Jal      <= 0;           //不需要跳�?
                Jalr     <= 0;
                //RegWrite               //根据具体指令选择
                MemToReg <= 1;           //选择RegWriteData = DM_RD_Ext
                MemWrite <= 4'b0;        //不需写入到Memory
                LoadNpc  <= 0;           //选择Result = AluOut
                RegRead  <= 2'b10;       //只用到第1个寄存器
                BranchType <= `NOBRANCH; //不涉及Branch
                AluSrc1  <= 0;           //ALU第一个输入选择Reg1
                AluSrc2  <= 2'b10;       //ALU第二个输入选择Imm
                ImmType  <= `ITYPE;
                Imm      <= {{20{In[31]}}, In[31:20]}; //I指令的立即数，需要符号扩展
                AluContrl <= `ADD;
                /*�?有的I格式Load指令*/       
                case(Fn3)
                    3'b000: //LB
                        RegWrite <= `LB;
                    3'b001: //LH
                        RegWrite <= `LH;
                    3'b010: //LW
                        RegWrite <= `LW;
                    3'b100: //LBU
                        RegWrite <= `LBU;
                    3'b101: //LHU
                        RegWrite <= `LHU;    
                    default: ;
                endcase
            end
            `S: begin
                Jal      <= 0;           //不需要跳�?
                Jalr     <= 0;
                RegWrite <= `NOREGWRITE; //不需要写入寄存器
                MemToReg <= 1;           //1�?0都无�?谓，因为不会写入寄存�?
                //MemWrite               //根据具体指令选择
                LoadNpc  <= 0;           //选择Result = AluOut
                RegRead  <= 2'b11;       //用到两个寄存�?
                BranchType <= `NOBRANCH; //不涉及Branch
                AluSrc1  <= 0;           //ALU第一个输入�?�择Reg1
                AluSrc2  <= 2'b10;       //ALU第二个输入�?�择Imm
                ImmType  <= `STYPE;
                Imm      <= {{20{In[31]}}, In[31:25], In[11:7]}; //S指令�?�?的立即数
                AluContrl <= `ADD;
                /*�?有的S指令*/       
                case(Fn3)
                    3'b000: //SB
                        MemWrite <= 4'b0001;
                    3'b001: //SH
                        MemWrite <= 4'b0011;
                    3'b010: //SW
                        MemWrite <= 4'b1111;
                    default: ;
                endcase
            end  
            `B: begin
                Jal      <= 0;           //不用J跳转
                Jalr     <= 0;
                RegWrite <= `NOREGWRITE; //不需要写入寄存器
                MemToReg <= 1;           //1�?0都无�?谓，因为不会写入寄存�?
                MemWrite <= 4'b0;        //不需写入到Memory
                LoadNpc  <= 0;           //选择Result = AluOut
                RegRead  <= 2'b11;       //用到两个寄存�?
                //BranchType             //根据具体指令选择
                AluSrc1  <= 0;           //ALU第一个输入�?�择Reg1
                AluSrc2  <= 2'b00;       //ALU第二个输入�?�择Reg2
                ImmType  <= `BTYPE;
                Imm      <= {{20{In[31]}}, In[7], In[30:25], In[11:8], 1'b0}; //S指令�?�?的立即数
                AluContrl <= `SLT;       //B指令用不到ALU，无�?�?
                /*�?有的B指令*/       
                case(Fn3)
                    3'b000: //BEQ
                        BranchType <= `BEQ;
                    3'b001: //BNE                        
                        BranchType <= `BNE;
                    3'b100: //BLT
                        BranchType <= `BLT;
                    3'b101: //BGE                        
                        BranchType <= `BGE;
                    3'b110: //BLTU
                        BranchType <= `BLTU;
                    3'b111: //BGEU
                        BranchType <= `BGEU;
                    default: ;
                endcase
            end
            `U_LUI: begin
                Jal      <= 0;           //不需要跳�?
                Jalr     <= 0;
                RegWrite <= `LW;         //直接写入到寄存器
                MemToReg <= 0;           //选择RegWriteData = Result
                MemWrite <= 4'b0;        //不需写入到Memory
                LoadNpc  <= 0;           //选择Result = AluOut
                RegRead  <= 2'b00;       //输入不会用到寄存�?
                BranchType <= `NOBRANCH; //不涉及Branch
                AluSrc1  <= 0;           //ALU第一个输入�?�择Reg1
                AluSrc2  <= 2'b10;       //ALU第二个输入�?�择Imm
                ImmType  <= `UTYPE;
                Imm      <= {In[31:12], 12'b0};  
                AluContrl <= `LUI;
            end
            `U_AUIPC: begin
                Jal      <= 0;           //不需要跳�?
                Jalr     <= 0;
                RegWrite <= `LW;         //直接写入到寄存器
                MemToReg <= 0;           //选择RegWriteData = Result
                MemWrite <= 4'b0;        //不需写入到Memory
                LoadNpc  <= 0;           //选择Result = AluOut
                RegRead  <= 2'b00;       //输入不会用到寄存�?
                BranchType <= `NOBRANCH; //不涉及Branch
                AluSrc1  <= 1;           //ALU第一个输入�?�择PC
                AluSrc2  <= 2'b10;       //ALU第二个输入�?�择Imm
                ImmType  <= `UTYPE;
                Imm      <= {In[31:12], 12'b0};  
                AluContrl <= `ADD;
            end   
            `J_JAL: begin
                Jal      <= 1;           
                Jalr     <= 0;
                RegWrite <= `LW;         //直接写入到寄存器
                MemToReg <= 0;           //选择RegWriteData = Result
                MemWrite <= 4'b0;        //不需写入到Memory
                LoadNpc  <= 1;           //选择Result = PC + 4
                RegRead  <= 2'b00;       //输入不会用到寄存�?
                BranchType <= `NOBRANCH; //不涉及Branch
                AluSrc1  <= 1;           //ALU第一个输入�?�择PC
                AluSrc2  <= 2'b10;       //ALU第二个输入�?�择Imm
                ImmType  <= `JTYPE;
                Imm      <= {11'b0, In[31], In[19:12], In[20], In[30:21], 1'b0};  
                AluContrl <= `ADD;       //JAL并不涉及到ALU，无�?�?
            end
            `J_JALR: begin
                Jal      <= 0;           
                Jalr     <= 1;
                RegWrite <= `LW;         //直接写入到寄存器
                MemToReg <= 0;           //选择RegWriteData = Result
                MemWrite <= 4'b0;        //不需写入到Memory
                LoadNpc  <= 1;           //选择Result = PC + 4
                RegRead  <= 2'b00;       //输入不会用到寄存�?
                BranchType <= `NOBRANCH; //不涉及Branch
                AluSrc1  <= 0;           //ALU第一个输入�?�择Reg1
                AluSrc2  <= 2'b10;       //ALU第二个输入�?�择Imm
                ImmType  <= `JTYPE;
                Imm      <= {{20{In[31]}}, In[31:20]}; //Imm是有符号数，需要考虑符号拓展 
                AluContrl <= `ADD;       
            end 
            default: ;
        endcase
    end
endmodule

//功能说明
    //ControlUnit       是本CPU的指令译码器，组合�?�辑电路
//输入
    // Op               是指令的操作码部�?
    // Fn3              是指令的func3部分
    // Fn7              是指令的func7部分
//输出
    // Jal==1          表示Jal指令信号
    // Jalr==1         表示Jalr指令信号
    // RegWrite        表示 寄存器写入模�? ，所有模式定义在Parameters.v�?
    // MemToReg==1     表示指令�?要将data memory读取的�?�写入寄存器,
    // MemWrite        �?4bit，采用独热码格式，对于data memory�?32bit字按byte进行写入,MemWrite=0001表示只写入最�?1个byte，和xilinx bram的接口类�?
    // LoadNpc==1      表示将NextPC输出到Result
    // RegRead[1]==1   表示A1对应的寄存器值被使用到了，RegRead[0]==1表示A2对应的寄存器值被使用到了
    // BranchType      表示不同的分支类型，�?有类型定义在Parameters.v�?
    // AluContrl       表示不同的ALU计算功能，所有类型定义在Parameters.v�?
    // AluSrc2         表示Alu输入�?2的�?�择
    // AluSrc1         表示Alu输入�?1的�?�择
    // ImmType         表示指令的立即数格式，所有类型定义在Parameters.v�?   
//实验要求  
    //实现ControlUnit模块   
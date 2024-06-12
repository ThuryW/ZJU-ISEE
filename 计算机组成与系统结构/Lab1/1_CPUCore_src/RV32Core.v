`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV CPU
// Module Name: RV32Core
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: Top level of our CPU Core
//////////////////////////////////////////////////////////////////////////////////
module RV32Core(
    input  wire CPU_CLK,
    input  wire CPU_RST,
    input  wire [31:0] CPU_Debug_DataRAM_A2,
    input  wire [31:0] CPU_Debug_DataRAM_WD2,
    input  wire [ 3:0] CPU_Debug_DataRAM_WE2,
    output wire [31:0] CPU_Debug_DataRAM_RD2,
    input  wire [31:0] CPU_Debug_InstRAM_A2,
    input  wire [31:0] CPU_Debug_InstRAM_WD2,
    input  wire [ 3:0] CPU_Debug_InstRAM_WE2,
    output wire [31:0] CPU_Debug_InstRAM_RD2
);
	//wire values definitions
    wire [31:0] PC;
    wire [31:0] Instr;
    wire Jal, Jalr, LoadNpc, MemToReg, AluSrc1;
    wire [2:0] RegWrite;
    wire [3:0] MemWrite;
    wire [1:0] RegRead;
    wire [2:0] BranchType;
    wire [4:0] AluContrl;
    wire [1:0] AluSrc2;
    wire [31:0] RegWriteData;
    wire [31:0] DM_RD_Ext;
    wire [2:0] ImmType;
    wire [31:0] Imm;
    wire [31:0] JalNPC,JalrTarget;
    wire [6:0] OpCode, Funct7;
    wire [2:0] Funct3;
    wire [4:0] Rs1, Rs2, Rd;
    wire [31:0] RegOut1;
    wire [31:0] RegOut2;
    wire [31:0] Operand1;
    wire [31:0] Operand2;
    wire Branch;
    wire [31:0] AluOut;
    wire [31:0] DM_RD;
    wire [31:0] Result;

    //wire values assignments
    assign {Funct7, Rs2, Rs1, Funct3, Rd, OpCode} = Instr;
    assign JalNPC = Imm+PC;
    assign JalrTarget = AluOut; //{AluOut[31:1],1'b0};
    assign Operand1 = (AluSrc1)? PC : RegOut1;
    assign Operand2 = (AluSrc2[1])? (Imm) :(AluSrc2[0]? Rs2 : RegOut2);
    assign Result = (LoadNpc)? (PC+4) : AluOut;
    assign RegWriteData = (~MemToReg)? Result : DM_RD_Ext;

    NPC_Generator NPC_Generator1(
        .clk(CPU_CLK),
        .rst(CPU_RST),
        .JalrTarget(JalrTarget), //AluOut
        .BranchTarget(JalNPC), 
        .JalTarget(JalNPC),
        .Branch(Branch),
        .Jal(Jal),
        .Jalr(Jalr),
        .PC(PC)
    );

    InstrSeg InstrSeg1(
        .clk(CPU_CLK),
        .A(PC),
        .RD(Instr),
        .A2(CPU_Debug_InstRAM_A2),
        .WD2(CPU_Debug_InstRAM_WD2),
        .WE2(CPU_Debug_InstRAM_WE2),
        .RD2(CPU_Debug_InstRAM_RD2)
    );

    ControlUnit ControlUnit1(
        .Op(OpCode),
        .Fn3(Funct3),
        .Fn7(Funct7),
        .Jal(Jal),
        .Jalr(Jalr),
        .In(Instr[31:7]),
        //.Type(ImmType),
        .RegWrite(RegWrite),
        .MemToReg(MemToReg),
        .MemWrite(MemWrite),
        .LoadNpc(LoadNpc),
        .RegRead(RegRead),
        .BranchType(BranchType),
        .AluContrl(AluContrl),
        .AluSrc1(AluSrc1),
        .AluSrc2(AluSrc2),
        .Imm(Imm),
        .ImmType(ImmType)
    );

    RegisterFile RegisterFile1(
        .clk(CPU_CLK),
        .rst(CPU_RST),
        .WE3(|RegWrite),
        .A1(Rs1),
        .A2(Rs2),
        .A3(Rd),
        .WD3(RegWriteData),
        .RD1(RegOut1),
        .RD2(RegOut2)
    );

    ALU ALU1(
        .Operand1(Operand1),
        .Operand2(Operand2),
        .AluContrl(AluContrl),
        .AluOut(AluOut)
    );

    BranchDecisionMaking BranchDecisionMaking1(
        .BranchType(BranchType),
        .Operand1(Operand1),
        .Operand2(Operand2),
        .Branch(Branch)
    );

    DataSeg DataSeg1(
        .clk(CPU_CLK),
        .A(AluOut),
        .WD(RegOut2),
        .WE(MemWrite),
        .RD(DM_RD),
        .A2(CPU_Debug_DataRAM_A2),
        .WD2(CPU_Debug_DataRAM_WD2),
        .WE2(CPU_Debug_DataRAM_WE2),
        .RD2(CPU_Debug_DataRAM_RD2)
    );

    DataExt DataExt1(
        .IN(DM_RD),
        .LoadedBytesSelect(AluOut[1:0]),
        .RegWrite(RegWrite),
        .OUT(DM_RD_Ext)
    );
     
endmodule

//功能说明
    //RV32I 指令集CPU的顶层模块
//实验要求  
    //无需修改
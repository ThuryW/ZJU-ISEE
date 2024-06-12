`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV-Pipline CPU
// Module Name: MEMSegReg
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: EX-MEM Segment Register
//////////////////////////////////////////////////////////////////////////////////
module MWSegReg(
    input wire clk,
    input wire en,
    input wire clear,
    //Data Signals
    input wire [31:0] AluOutE,
    output reg [31:0] AluOutMW, 
    input wire [31:0] ForwardData2,
    input wire [4:0] RdE,
    output reg [4:0] RdMW,
    input wire [31:0] PCE,
    output reg [31:0] PCMW,
    output wire [31:0] RD,
    //Data Memory Debug
    input wire [31:0] A2,
    input wire [31:0] WD2,
    input wire [3:0] WE2,
    output wire [31:0] RD2,
    //Control Signals
    input wire [3:0] MemWriteE,
    input wire [2:0] RegWriteE,
    output reg [2:0] RegWriteMW,
    input wire MemToRegE,
    output reg MemToRegMW,
    input wire LoadNpcE,
    output reg LoadNpcMW
);
    wire [31:0] RD_raw;
    reg  [31:0] StoreDataMW;
    reg  [3:0]  MemWriteMW; 

    always @(posedge clk) begin
        // 使能信号en有效时考虑赋新值，否则保持原值
        if(en)
            if(clear) begin
                MemToRegMW <= 0;
                RegWriteMW <= 0;
                LoadNpcMW  <= 0;
                PCMW       <= 0;
                RdMW       <= 0;
                AluOutMW   <= 0;
                StoreDataMW <= 0;
                MemWriteMW <= 0;
            end
            else begin
                MemToRegMW <= MemToRegE;
                RegWriteMW <= RegWriteE;
                LoadNpcMW  <= LoadNpcE;
                PCMW       <= PCE;
                RdMW       <= RdE;
                AluOutMW   <= AluOutE;
                StoreDataMW <= ForwardData2;
                MemWriteMW <= MemWriteE;
            end
    end

    DataRam DataRamInst(
        .clk   (clk),    
        .wea   ((AluOutMW[1:0] == 0)?(MemWriteMW):((AluOutMW[1:0] == 1)?(MemWriteMW << 1):((AluOutMW[1:0] == 2)?(MemWriteMW << 2):(MemWriteMW << 3)))),   
        .addra (AluOutMW[31:2]),
        .dina  ((AluOutMW[1:0] == 0)?(StoreDataMW):((AluOutMW[1:0] == 1)?(StoreDataMW << 8):((AluOutMW[1:0] == 2)?(StoreDataMW << 16):(StoreDataMW << 24)))), 
        .douta (RD_raw),
        .web   (WE2),
        .addrb (A2[31:2]),
        .dinb  (WD2),
        .doutb (RD2)
    );

    assign RD = RD_raw;
/*
    // 该部分参考IDSegReg
    reg stall_ff = 1'b0;
    reg clear_ff = 1'b0;
    reg [31:0] RD_old =32'b0;

    always @(posedge clk) begin
        stall_ff <= ~en;
        clear_ff <= clear;
        RD_old   <= RD_raw;
    end

    assign RD = stall_ff ? RD_old : (clear_ff ? 32'b0 : RD_raw );
*/

endmodule

//功能说明
    //MWSegReg是第四段寄存器
    //类似于IDSegReg.V中对Bram的调用和拓展，它同时包含了一个同步读写的Bram
    //（此处你可以调用我们提供的举例：DataRam，它将会自动综合为block memory，你也可以替代性的调用xilinx的bram ip核）。
    //举例：DataRam DataRamInst (
    //    .clk    (),                      //请补全
    //    .wea    (),                      //请补全
    //    .addra  (),                      //请补全
    //    .dina   (),                      //请补全
    //    .douta  ( RD_raw         ),
    //    .web    ( WE2            ),
    //    .addrb  ( A2[31:2]       ),
    //    .dinb   ( WD2            ),
    //    .doutb  ( RD2            )
    //    );  

//实验要求  
    //实现MWSegReg模块

//注意事项
    //输入到DataRam的addra是字地址，一个字32bit
    //请配合DataExt模块实现非字对齐字节load

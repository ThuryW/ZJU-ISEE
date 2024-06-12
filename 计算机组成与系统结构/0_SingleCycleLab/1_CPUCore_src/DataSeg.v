`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV CPU
// Module Name: DataSeg
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
//////////////////////////////////////////////////////////////////////////////////
module DataSeg(
    input wire clk,
    //Data Memory Access
    input wire [31:0] A,
    input wire [31:0] WD,
    input wire [3:0] WE,
    output wire [31:0] RD,
    //Data Memory Debug
    input wire [31:0] A2,
    input wire [31:0] WD2,
    input wire [3:0] WE2,
    output wire [31:0] RD2
);

    wire [31:0] RD_raw;
    DataRam DataRamInst(
        .clk    (clk),    
        .wea    ((A[1:0] == 0)?(WE):((A[1:0] == 1)?(WE << 1):((A[1:0] == 2)?(WE << 2):(WE << 3)))),   
        .addra  (A[31:2]),
        .dina   ((A[1:0] == 0)?(WD):((A[1:0] == 1)?(WD << 8):((A[1:0] == 2)?(WD << 16):(WD << 24)))), 
        .douta  (RD_raw),
        .web    (WE2),
        .addrb  (A2[31:2]),
        .dinb   (WD2),
        .doutb  (RD2)
    );   

    assign RD = RD_raw;

endmodule

//功能说明
    //DataSeg同时包含了一个同步读写的Bram
    //（此处你可以调用我们提供的DataRam，它将会自动综合为block memory，你也可以替代性的调用xilinx的bram ip核）。

//实验要求  
    //你需要补全上方代码，需补全的片段截取如下
    //DataRam DataRamInst (
    //    .clk    (???),                      //请补全
    //    .wea    (???),                      //请补全
    //    .addra  (???),                      //请补全
    //    .dina   (???),                      //请补全
    //    .douta  ( RD_raw         ),
    //    .web    ( WE2            ),
    //    .addrb  ( A2[31:2]       ),
    //    .dinb   ( WD2            ),
    //    .doutb  ( RD2            )
    //);   
//注意事项
    //输入到DataRam的addra是字地址，一个字32bit
    //请配合DataExt模块实现非字对齐字节load
    //请通过补全代码实现非字对齐store

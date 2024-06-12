`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV CPU
// Module Name: InstrSeg
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
//////////////////////////////////////////////////////////////////////////////////
module InstrSeg(
    input  wire clk,
    //Instrution Memory Access
    input  wire [31:0] A,
    output wire [31:0] RD,
    //Instruction Memory Debug
    input  wire [31:0] A2,
    input  wire [31:0] WD2,
    input  wire [ 3:0] WE2,
    output wire [31:0] RD2
    //
);     
    wire [31:0] RD_raw;
    InstructionRam InstructionRamInst (
         .clk    (clk),                        
         .addra  (A[31:2]),                        
         .douta  (RD_raw),
         .web    (|WE2),
         .addrb  (A2[31:2]),
         .dinb   (WD2),
         .doutb  (RD2)
     );
    // Add clear and stall support
    // if chip not enabled, output output last read result
    // else if chip clear, output 0
    // else output values from bram
  
    assign RD =  RD_raw;

endmodule


//????
    //InstrSeg??????????Bram?????????????InstructionRam?
    //????????block memory???????????xilinx?bram ip???

//????  
    //????????????????????
    //InstructionRam InstructionRamInst (
    //     .clk    (),                        
    //     .addra  (),                        
    //     .douta  ( RD_raw     ),
    //     .web    ( |WE2       ),
    //     .addrb  ( A2[31:2]   ),
    //     .dinb   ( WD2        ),
    //     .doutb  ( RD2        )
    // );
//????
    //输入到DataRam的addra是字地址，一个字32bit
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV-Pipline CPU
// Module Name: ALU
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: ALU unit of RISCV CPU
//////////////////////////////////////////////////////////////////////////////////
`include "Parameters.v"   
module ALU(
    input wire [31:0] Operand1,
    input wire [31:0] Operand2,
    input wire [3:0] AluContrl,
    output reg [31:0] AluOut
);

    always @(*) begin
        case(AluContrl)
            `SLL: 
                case(Operand2[4:0])
                    1: AluOut <= Operand1 << 1;
                    2: AluOut <= Operand1 << 2;
                    3: AluOut <= Operand1 << 3;
                    4: AluOut <= Operand1 << 4;
                    5: AluOut <= Operand1 << 5;
                    6: AluOut <= Operand1 << 6;
                    7: AluOut <= Operand1 << 7;
                    8: AluOut <= Operand1 << 8;
                    9: AluOut <= Operand1 << 9;
                    10: AluOut <= Operand1 << 10;
                    11: AluOut <= Operand1 << 11;
                    12: AluOut <= Operand1 << 12;
                    13: AluOut <= Operand1 << 13;
                    14: AluOut <= Operand1 << 14;
                    15: AluOut <= Operand1 << 15;
                    16: AluOut <= Operand1 << 16;
                    17: AluOut <= Operand1 << 17;
                    18: AluOut <= Operand1 << 18;
                    19: AluOut <= Operand1 << 19;
                    20: AluOut <= Operand1 << 20;
                    21: AluOut <= Operand1 << 21;
                    22: AluOut <= Operand1 << 22;
                    23: AluOut <= Operand1 << 23;
                    24: AluOut <= Operand1 << 24;
                    25: AluOut <= Operand1 << 25;
                    26: AluOut <= Operand1 << 26;
                    27: AluOut <= Operand1 << 27;
                    28: AluOut <= Operand1 << 28;
                    29: AluOut <= Operand1 << 29;
                    30: AluOut <= Operand1 << 30;
                    31: AluOut <= Operand1 << 31;
                    32: AluOut <= Operand1 << 32;
                    default: AluOut <= Operand1;
                endcase
            `SRL:
                case(Operand2[4:0])
                    1: AluOut <= Operand1 >> 1;
                    2: AluOut <= Operand1 >> 2;
                    3: AluOut <= Operand1 >> 3;
                    4: AluOut <= Operand1 >> 4;
                    5: AluOut <= Operand1 >> 5;
                    6: AluOut <= Operand1 >> 6;
                    7: AluOut <= Operand1 >> 7;
                    8: AluOut <= Operand1 >> 8;
                    9: AluOut <= Operand1 >> 9;
                    10: AluOut <= Operand1 >> 10;
                    11: AluOut <= Operand1 >> 11;
                    12: AluOut <= Operand1 >> 12;
                    13: AluOut <= Operand1 >> 13;
                    14: AluOut <= Operand1 >> 14;
                    15: AluOut <= Operand1 >> 15;
                    16: AluOut <= Operand1 >> 16;
                    17: AluOut <= Operand1 >> 17;
                    18: AluOut <= Operand1 >> 18;
                    19: AluOut <= Operand1 >> 19;
                    20: AluOut <= Operand1 >> 20;
                    21: AluOut <= Operand1 >> 21;
                    22: AluOut <= Operand1 >> 22;
                    23: AluOut <= Operand1 >> 23;
                    24: AluOut <= Operand1 >> 24;
                    25: AluOut <= Operand1 >> 25;
                    26: AluOut <= Operand1 >> 26;
                    27: AluOut <= Operand1 >> 27;
                    28: AluOut <= Operand1 >> 28;
                    29: AluOut <= Operand1 >> 29;
                    30: AluOut <= Operand1 >> 30;
                    31: AluOut <= Operand1 >> 31;
                    32: AluOut <= Operand1 >> 32;
                    default: AluOut <= Operand1;
                endcase  
            `SRA:
                case(Operand2[4:0])
                    1: AluOut <= {{1{Operand1[31]}}, Operand1[31:1]};
                    2: AluOut <= {{2{Operand1[31]}}, Operand1[31:2]};
                    3: AluOut <= {{3{Operand1[31]}}, Operand1[31:3]};
                    4: AluOut <= {{4{Operand1[31]}}, Operand1[31:4]};
                    5: AluOut <= {{5{Operand1[31]}}, Operand1[31:5]};
                    6: AluOut <= {{6{Operand1[31]}}, Operand1[31:6]};
                    7: AluOut <= {{7{Operand1[31]}}, Operand1[31:7]};
                    8: AluOut <= {{8{Operand1[31]}}, Operand1[31:8]};
                    9: AluOut <= {{9{Operand1[31]}}, Operand1[31:9]};
                    10: AluOut <= {{10{Operand1[31]}}, Operand1[31:10]};
                    11: AluOut <= {{11{Operand1[31]}}, Operand1[31:11]};
                    12: AluOut <= {{12{Operand1[31]}}, Operand1[31:12]};
                    13: AluOut <= {{13{Operand1[31]}}, Operand1[31:13]};
                    14: AluOut <= {{14{Operand1[31]}}, Operand1[31:14]};
                    15: AluOut <= {{15{Operand1[31]}}, Operand1[31:15]};
                    16: AluOut <= {{16{Operand1[31]}}, Operand1[31:16]};
                    17: AluOut <= {{17{Operand1[31]}}, Operand1[31:17]};
                    18: AluOut <= {{18{Operand1[31]}}, Operand1[31:18]};
                    19: AluOut <= {{19{Operand1[31]}}, Operand1[31:19]};
                    20: AluOut <= {{20{Operand1[31]}}, Operand1[31:20]};
                    21: AluOut <= {{21{Operand1[31]}}, Operand1[31:21]};
                    22: AluOut <= {{22{Operand1[31]}}, Operand1[31:22]};
                    23: AluOut <= {{23{Operand1[31]}}, Operand1[31:23]};
                    24: AluOut <= {{24{Operand1[31]}}, Operand1[31:24]};
                    25: AluOut <= {{25{Operand1[31]}}, Operand1[31:25]};
                    26: AluOut <= {{26{Operand1[31]}}, Operand1[31:26]};
                    27: AluOut <= {{27{Operand1[31]}}, Operand1[31:27]};
                    28: AluOut <= {{28{Operand1[31]}}, Operand1[31:28]};
                    29: AluOut <= {{29{Operand1[31]}}, Operand1[31:29]};
                    30: AluOut <= {{30{Operand1[31]}}, Operand1[31:30]};
                    31: AluOut <= {{31{Operand1[31]}}, Operand1[31:31]};
                    default: AluOut <= Operand1;
                endcase  
            `ADD:
                AluOut <= Operand1 + Operand2;  
            `SUB:
                AluOut <= Operand1 - Operand2;  
            `XOR:
                AluOut <= Operand1 ^ Operand2;  
            `OR:
                AluOut <= Operand1 | Operand2;  
            `AND:
                AluOut <= Operand1 & Operand2;  
            `SLT:
                if(Operand1[31] ==1 && Operand2[31] == 0)
                    //Operand1 < 0, Operand2 >= 0
                    AluOut <= 32'b1;
                else if(Operand1[31] == 0 && Operand2[31] == 1) 
                    //Operand1 >= 0, Operand2 < 0
                    AluOut <= 32'b0;
                else if(Operand1[31] == 1 && Operand2[31] == 1) 
                    //Operand1 < 0, Operand2 < 0
                    AluOut <= (Operand1 < Operand2)? 32'b1 : 32'b0;
                else
                    //Operand1 >= 0, Operand2 >= 0
                    AluOut <= (Operand1 < Operand2)? 32'b1 : 32'b0; 
            `SLTU:  
                AluOut <= (Operand1 < Operand2)? 32'b1 : 32'b0; 
            `LUI:
                //要和ControlUnit配合
                AluOut <= {Operand2[31:12], 12'b0};  
            default:    
                AluOut <= 32'hxxxxxxxx; 
        endcase
    end

endmodule

//功能和接口说明
	//ALU接受两个操作数，根据AluContrl的不同，进行不同的计算操作，将计算结果输出到AluOut
	//AluContrl的类型定义在Parameters.v中
//推荐格式：
    //case()
    //    `ADD:        AluOut<=Operand1 + Operand2; 
    //   	.......
    //    default:    AluOut <= 32'hxxxxxxxx;                          
    //endcase
//实验要求  
    //实现ALU模块
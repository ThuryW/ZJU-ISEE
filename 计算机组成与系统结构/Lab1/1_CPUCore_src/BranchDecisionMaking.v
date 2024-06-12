`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV CPU
// Module Name: BranchDecisionMaking
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: Decide whether to branch 
//////////////////////////////////////////////////////////////////////////////////
`include "Parameters.v"   
module BranchDecisionMaking(
    input wire [2:0] BranchType,
    input wire [31:0] Operand1,Operand2,
    output reg Branch
);
    always @(*) begin
        case(BranchType)
            `BEQ:    
                Branch <= (Operand1 == Operand2)? 1'b1 : 1'b0;
            `BNE:
                Branch <= (Operand1 != Operand2)? 1'b1 : 1'b0;   
            `BLT:
                if(Operand1[31] ==1 && Operand2[31] == 0)
                    //Operand1 < 0, Operand2 >= 0
                    Branch <= 1'b1;
                else if(Operand1[31] == 0 && Operand2[31] == 1) 
                    //Operand1 >= 0, Operand2 < 0
                    Branch <= 1'b0;
                else if(Operand1[31] == 1 && Operand2[31] == 1) 
                    //Operand1 < 0, Operand2 < 0
                    Branch <= (Operand1 < Operand2)? 1'b1 : 1'b0;
                else
                    //Operand1 >= 0, Operand2 >= 0
                    Branch <= (Operand1 < Operand2)? 1'b1 : 1'b0;   
            `BLTU:
                Branch <= (Operand1 < Operand2)? 1'b1 : 1'b0;
            `BGE:
                if(Operand1[31] ==1 && Operand2[31] == 0)
                    //Operand1 < 0, Operand2 >= 0
                    Branch <= 1'b0;
                else if(Operand1[31] == 0 && Operand2[31] == 1) 
                    //Operand1 >= 0, Operand2 < 0
                    Branch <= 1'b1;
                else if(Operand1[31] == 1 && Operand2[31] == 1) 
                    //Operand1 < 0, Operand2 < 0
                    Branch <= (Operand1 < Operand2)? 1'b0 : 1'b1;
                else
                    //Operand1 >= 0, Operand2 >= 0
                    Branch <= (Operand1 < Operand2)? 1'b0 : 1'b1;
            `BGEU:
                Branch <= (Operand1 >= Operand2)? 1'b1 : 1'b0;  
            default: 
                //NOBRANCH
                Branch <= 1'b0;
        endcase
    end

endmodule

//功能和接口说明
    //BranchDecisionMaking接受两个操作数，根据BranchType的不同，进行不同的判断，当分支应该taken时，令Branch=1'b1
    //BranchTypeE的类型定义在Parameters.v中
//推荐格式：
    //case()
    //    `BEQ: ???
    //      .......
    //    default:                            Branch<=1'b0;  //NOBRANCH
    //endcase
//实验要求  
    //实现BranchDecisionMaking模块
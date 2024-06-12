`timescale 1ns / 1ps

module testBench();

    reg CPU_CLK;
    reg CPU_RST;

    initial begin
        CPU_CLK <= 0;
        CPU_RST <= 0;
    end

    //generate clock signal
    always #1 CPU_CLK = ~CPU_CLK;
    
    // Connect the CPU core
    RV32Core RV32Core1(
        .CPU_CLK(CPU_CLK),
        .CPU_RST(CPU_RST)
    );

    initial begin
        $display("Start Instruction Execution!"); 
        #10;   
        CPU_RST = 1'b1;
        #10;   
        CPU_RST = 1'b0;
        #10000000 		// waiting for instruction Execution to End
        $display("Finish Instruction Execution!"); 
        $display("Simulation Ended!"); 
        $stop();
    end
    
endmodule

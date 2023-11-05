`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2023 10:11:59 PM
// Design Name: 
// Module Name: riscv32isinglecycle_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module riscv32isinglecycle_tb();
reg clk;
reg rst;
localparam p = 20;
riscv32iSingleCycle DUT( 
                        .clk(clk), 
                        .rst(rst));
                        
initial begin
    forever #(p) clk = ~clk;
end
                        
initial begin  
    $dumpfile("riscv32_single_cycle.vcd"); 
    $dumpvars(0, riscv32_single_cycle_tb);
    rst = 1'b1;
    clk = 1'b0; 
    
    #(p * 4) 
    rst = 1'b0;
    #(p*1000) $finish;
end
endmodule

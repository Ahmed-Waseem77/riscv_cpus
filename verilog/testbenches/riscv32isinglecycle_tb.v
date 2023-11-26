/* 
    RiscV32I Single Cycle Processor 
    Copyright (C) 2023 Ahmed Waseem, Ahmed ElBarbary

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

*/     

`timescale 1ns / 1ps
module riscv32IMC_pipelined_tb();
reg clk;
reg rst;
localparam p = 20;
riscv32IMC_pipelined DUT(.clk(clk), 
                         .rst(rst));
                        
initial begin
    forever #(p) clk = ~clk;
end
                        
initial begin  
    $dumpfile("riscv32IMC_pipelined.vcd"); 
    $dumpvars(0, riscv32IMC_pipelined_tb);
    rst = 1'b1;
    clk = 1'b0; 
    
    #(p * 4) 
    rst = 1'b0;
    #(p*1000) $finish;
end
endmodule

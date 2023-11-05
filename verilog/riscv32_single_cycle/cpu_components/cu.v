

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

`timescale 1ns/10ps
module cu( 
   input   wire    [7-1:0]  Instruction, 
   output  wire    [1:0]    alu_op, 
   output  wire             alu_src, 
   output  wire             branch, 
   output  wire             jump, 
   output  wire    [1:0]    mem_out_sel, 
   output  wire             mem_read, 
   output  wire             mem_write, 
   output  wire             reg_write
);

    reg [9:0] flags;
    
    assign {jump, branch, mem_read, mem_out_sel, alu_op, mem_write, alu_src, reg_write} = flags;
      

    initial begin 
        flags = 8'b00000000; 
    end
    
    
    // nop    sub   add   FUNCT 
    // 00     01    10    11                  <= aluop
    // 0011   0001  0000  case on FUNCT       <= alufn output
    
    always @ (*) begin : COMBINATIONAL_OUTPUT
        case(Instruction) 
            
            //LUI 
            7'b0110111 : flags = 10'b000_01_00_011; 
            
            //AUIPC 
            7'b0010111 : flags = 10'b000_10_00_001; 
            
            //JAL      
            7'b1101111 : flags = 10'b100_00_00_000; 
            
            //I-format 
            7'b0010011 : flags = 10'b000_01_11_011;
            
            // R-format
            7'b0110011 : flags = 10'b000_01_11_001;
            
            // LW
            7'b0000011 : flags = 10'b001_00_10_011;
            
            // SW 
            7'b0100011 : flags = 10'b000_00_10_110;
            
            // BRANCHES 
            7'b1100011 : flags = 10'b010_01_01_000;
          
            
            default    : flags = 10'b000_00_00_000; 
            
        endcase
        
    end


// Internal Declarations
endmodule

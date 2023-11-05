

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
   output  wire    [2:0]    mem_read, 
   output  wire    [1:0]    mem_write, 
   output  wire             reg_write
);

    reg [12:0] flags;
    
    assign {jump, branch, mem_read, mem_out_sel, alu_op, mem_write, alu_src, reg_write} = flags;
      

    initial begin 
        flags = 13'd0; 
    end
    
    
    // nop    sub   add   FUNCT 
    // 00     01    10    11                  <= aluop
    // 0011   0001  0000  case on FUNCT       <= alufn output
    
    always @ (*) begin : COMBINATIONAL_OUTPUT
        case(Instruction) 
            
            //LUI 
            7'b0110111 : flags = 13'b00_000_01_00_00_11; 
            
            //AUIPC 
            7'b0010111 : flags = 13'b00_000_10_00_00_01; 
            
            //JAL      
            7'b1101111 : flags = 13'b10_000_00_00_00_00; 
            
            //JALR 
            7'b1100111 : flags = 13'b11_000_11_10_00_11;
            
            //I-format 
            7'b0010011 : flags = 13'b00_000_01_11_00_11;
            
            //R-format
            7'b0110011 : flags = 13'b00_000_01_11_00_01;
            
            
            //LW
            7'b0000011 : flags = 13'b00_001_00_10_00_11;  
            
            //LB 
            7'b0000011 : flags = 13'b00_100_00_10_00_11;  
            
            //LBU
            7'b0000011 : flags = 13'b00_101_00_10_00_11;  
            
            //LH
            7'b0000011 : flags = 13'b00_010_00_10_00_11;  
            
            //LHU
            7'b0000011 : flags = 13'b00_011_00_10_00_11; 
             
            
            //SW 
            7'b0100011 : flags = 13'b00_000_00_10_01_10;  
            
            //SH
            7'b0100011 : flags = 13'b00_000_00_10_10_10;
            
            //SB
            7'b0100011 : flags = 13'b00_000_00_10_11_10;
            
            
            // BRANCHES 
            7'b1100011 : flags = 13'b01_000_01_01_00_00;
          
            
            default    : flags = 13'b00_000_00_00_00_00; 
            
        endcase
        
    end

endmodule

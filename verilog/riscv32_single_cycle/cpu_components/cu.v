

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

`resetall
`timescale 1ns/10ps
module cu( 
   input   wire    [32-1:0] Instruction, 
   output  wire    [2:0]    alu_op, 
   output  wire             alu_src, 
   output  wire             branch, 
   output  wire             jump, 
   output  wire    [1:0]    mem_out_sel, 
   output  wire    [2:0]    mem_read, 
   output  wire    [1:0]    mem_write, 
   output  wire             reg_write
);

// ### Please start your Verilog code here ###
// Internal Declarations
    reg [13:0] flags;
    
    assign {jump, branch, mem_read, mem_out_sel, alu_op, mem_write, alu_src, reg_write} = flags;
      

    initial begin 
        flags = 14'b00000000; 
    end
    
    
    // nop    sub   add           I-FORMAT/R-FORMAT FUNCT           MUL/DIV/REM FUNCT     
    // 000    001   010           011                               100                                <= aluop
    // 0011   0001  check JALR    case on FUNCT                     case on FUNCT                      <= alufn output
    
    always @ (*) begin : COMBINATIONAL_OUTPUT
        case(Instruction[7-1:0]) 
            
            //LUI 
            7'b0110111 : flags = 14'b00_000_01_000_00_11; 
            
            //AUIPC 
            7'b0010111 : flags = 14'b00_000_10_000_00_01; 
            
            //JAL      
            7'b1101111 : flags = 14'b10_000_11_000_00_01; 
            
            //JALR 
            7'b1100111 : flags = 14'b11_000_11_010_00_11;
            
            //I-format 
            7'b0010011 : flags = 14'b00_000_01_011_00_11;
            
            //R-format
            7'b0110011 : begin 
                          if (Instruction[25]) begin // I SPEC 
                            flags = 14'b00_000_01_100_00_01;
                          end 
                          else begin //M SPEC
                            flags = 14'b00_000_01_011_00_01;
                          end
                         end
            
            
            //LW
            7'b0000011 : begin 
                            case(Instruction[14:12]) 
                                3'b010 : flags = 14'b00_001_00_010_00_11; //LW  
                                3'b000 : flags = 14'b00_100_00_010_00_11; //LB 
                                3'b001 : flags = 14'b00_010_00_010_00_11; //LH 
                                3'b100 : flags = 14'b00_101_00_010_00_11; //LBU 
                                3'b101 : flags = 14'b00_011_00_010_00_11; //LHU  

                                default : flags = 14'b00_000_00_000_00_00;
                            endcase 
                         end
            /* LB 
            7'b0000011 : flags = 14'b00_100_00_010_00_11;  
            
            //LBU
            7'b0000011 : flags = 14'b00_101_00_010_00_11;  
            
            //LH
            7'b0000011 : flags = 14'b00_010_00_010_00_11;  
            
            //LHU
            7'b0000011 : flags = 14'b00_011_00_010_00_11; 
             */
            
            //SW 
            7'b0100011 : begin  
                            case(Instruction[14:12]) 

                                3'b010: flags = 14'b00_000_00_010_01_10;    //SW
                                3'b000: flags = 14'b00_000_00_010_11_10;    //SB 
                                3'b001: flags = 14'b00_000_00_010_10_10;    //SH

                                default: flags = 14'b00_000_00_000_00_00;
                            endcase  
                        end
                    
            /*SH
            7'b0100011 : flags = 14'b00_000_00_010_10_10;
            
            //SB
            7'b0100011 : flags = 14'b00_000_00_010_11_10;
            */ 
            
            // BRANCHES 
            7'b1100011 : flags = 14'b01_000_01_001_00_00;
            
            
          
            
            default    : flags = 14'b00_000_00_000_00_00; 
            
        endcase
        
    end

endmodule

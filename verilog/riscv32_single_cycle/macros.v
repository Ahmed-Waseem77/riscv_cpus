
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

`define     IR_rs1          19:15
`define     IR_rs2          24:20
`define     IR_rd           11:7
`define     IR_opcode       6:0
`define     IR_funct3       14:12 
`define     IR_funct7       31:25
`define     IR_shamt        24:20 

`define     OPCODE_Branch   7'b11_00011
`define     OPCODE_Load     7'b00_00011
`define     OPCODE_Store    7'b01_00011 
`define     OPCODE_JALR     7'b11_00111
`define     OPCODE_JAL      7'b11_01111 
`define     OPCODE_Arith_I  7'b00_10011 
`define     OPCODE_Arith_R  7'b01_10011 
`define     OPCODE_AUIPC    7'b00_10111 
`define     OPCODE_LUI      7'b01_10111 

`define     OPCODE_SYSTEM   7'b11_10011  
`define     OPCODE_Custom   7'b10_00111 


`define     F3_ADD          3'b000 
`define     F3_SLL          3'b001 

`define     F3_SLT          3'b010 
`define     F3_SLTU         3'b011 
`define     F3_XOR          3'b100 
`define     F3_SRL          3'b101 
`define     F3_OR           3'b110 
`define     F3_AND          3'b111 

`define     BR_BEQ          3'b000 
`define     BR_BNE          3'b001 
`define     BR_BLT          3'b100
`define     BR_BGE          3'b101 
`define     BR_BLTU         3'b110 
`define     BR_BGEU         3'b111 

`define     OPCODE          IR[`IR_opcode] 

`define     ALU_ADD         4'b00_00 
`define     ALU_SUB         4'b00_01 
`define     ALU_PASS        4'b00_11
`define     ALU_OR          4'b01_00 
`define     ALU_AND         4'b01_01 
`define     ALU_XOR         4'b01_11 
`define     ALU_SRL         4'b10_00
`define     ALU_SRA         4'b10_10 
`define     ALU_SLL         4'b10_01 
`define     ALU_SLT         4'b11_01
`define     ALU_SLTU        4'b11_11
 
`define     SYS_EC_EB       3'b000


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
module instMem( 
   output  wire    [32 - 1:0]  Instruction, 
   input   wire    [8 - 1:0]   pc_current_address
);

reg [31:0] mem [0:63]; //4kb 

assign Instruction = mem[pc_current_address];

initial begin 
mem[0] = 32'h02710337; //lui x6, 10000
mem[1] = 32'h00008397; //auipc x7, 8
mem[2] = 32'h00000033; //add x0, x0, x0
mem[3] = 32'h0080046f; //jal x8, 0x4
mem[4] = 32'h00000033; //add x0, x0, x0
mem[5] = 32'h00024437; //lui x8, 36
mem[6] = 32'h02440467; //jalr x8, 36(x8)
mem[7] = 32'h00000033; //add x0, x0, x0
mem[8] = 32'h00000033; //add x0, x0, x0
mem[9] = 32'h00a00093; //addi x1, x0, 10
mem[10] = 32'h01400113; //addi x2, x0, 20
mem[11] = 32'h00108463; //beq x1, x1, 8 
mem[12] = 32'h00000033;//add x0, x0, x0
mem[13] = 32'h00209663;//bne x1, x2, 12
mem[14] = 32'h00000033; //add x0, x0, x0
mem[15] = 32'h00000033; //add x0, x0, x0
mem[16] = 32'h00000033; //add x0, x0, x0
mem[17] = 32'hfe114ee3; //blt x2, x1, -4
mem[18] = 32'h00115463; //bge x2, x1, 8
mem[19] = 32'h00000033; //add x0, x0, x0
mem[20] = 32'hfe1168e3; //bltu x2, x1, -16
mem[21] = 32'hfe20fee3; //bgeu x1, x2, -4
mem[22] = 32'h00400093; //addi x1, x0, 4
mem[23] = 32'h00800113; //addi x2, x0, 8
mem[24] = 32'h00008503; //lb x10, 0(x1)
mem[25] = 32'h00011583; //lh x11, 0(x2)
mem[26] = 32'h00412603; //lw x12, 4(x2)
mem[25] = 32'h00814683; //lbu x13, 8(x2)
mem[26] = 32'h00c15703; //lhu x14, 12(x2)
end

endmodule

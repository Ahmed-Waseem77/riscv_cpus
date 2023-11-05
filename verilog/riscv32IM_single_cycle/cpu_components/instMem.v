
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
mem[27] = 32'h00814683; //lbu x13, 8(x2)
mem[28] = 32'h00c15703; //lhu x14, 12(x2)
mem[29] = 32'h10600513; //addi x10, x0, 262
mem[30] = 32'h00150023; //sb x1, 0(x10)
mem[31] = 32'h00111423; //sh x1, 8(x2)
mem[32] = 32'h0021a823; //sw x2, 16(x3)
mem[33] = 32'h12c52313; //slti x6, x10, 300
mem[34] = 32'h12c53393; //sltiu x7, x10, 300
mem[35] = 32'h04400113; //addi x2, x0, 68
mem[36] = 32'h02814413; //xori x8, x2, 40
mem[37] = 32'h02816493; //ori x9, x2, 40
mem[38] = 32'h02817513; //andi x10, x2, 40
mem[39] = 32'h01000193; //addi x3, x0, 16
mem[40] = 32'h00219593; //slli x11, x3, 2
mem[41] = 32'h0031d613; //srli x12, x3, 3
mem[42] = 32'h4011d693; //srai x13, x3, 1
mem[43] = 32'h002082b3; //add x5, x1, x2
mem[44] = 32'h40110333; //sub x6, x2, x1
mem[45] = 32'h00200113; //addi x2, x0, 2
mem[46] = 32'h002093b3; //sll x7, x1, x2
mem[47] = 32'h00500193; //addi x3, x0, 5
mem[48] = 32'h00312433; //slt x8, x2, x3
mem[49] = 32'h003134b3; //sltu x9, x2, x3
mem[50] = 32'h00314533; //	xor x10, x2, x3
mem[51] = 32'h0020d5b3; //srl x11, x1, x2
mem[52] = 32'h4021d633; //sra x12, x3, x2
mem[53] = 32'h001166b3; //or x13, x2, x1
mem[54] = 32'h00117733; //and x14, x2, x1
end

endmodule

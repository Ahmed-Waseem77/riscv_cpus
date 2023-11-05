
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
        mem[0]	=	32'b00000000010000000010000110000011 ;	//lw x3, 4(x0)
        mem[1]	=	32'b11111111110000011010000010000011 ;	//lw x1, -4(x3)
        mem[2]	=	32'b01000000000100011000000110110011 ;	//sub x3,x3,x1
        mem[3]	=	32'b00000000000000011000010001100011 ;	//beq x0,x0,4
        mem[4]	=	32'b11111110000000000000110011100011 ;  //beq x0,x0,-4
        mem[5]  = 32'b00000000000100001000000000110011 ;  //add x0, x1,
end

endmodule


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
mem[0] = 32'h09300313;
mem[1] = 32'h00100393;
mem[2] = 32'h00d00e13;
mem[3] = 32'hff300e93;
mem[4] = 32'hfec00f13;
mem[5] = 32'h007e1e33;
mem[6] = 32'h007e5e33;
mem[7] = 32'h407edeb3;
mem[8] = 32'h007e8eb3;
mem[9] = 32'h41de0eb3;
mem[10] = 32'h01c36eb3;
mem[11] = 32'h006e4eb3;
mem[12] = 32'h0063feb3;
mem[13] = 32'h01c3aeb3;
mem[14] = 32'h007f3eb3;

end

endmodule

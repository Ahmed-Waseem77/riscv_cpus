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
module immGen( 
   input   wire    [32-1:0]    Instruction, 
   output  wire    [32 - 1:0]  immediate
);


wire [32-1:0] IR; 
reg  [32-1:0] Imm;

assign IR = Instruction; 
assign immediate = Imm;

always @(*) begin
	case (IR[6:2])
		5'b00_100    : 	Imm = { {21{IR[31]}}, IR[30:25], IR[24:21], IR[20] };
		5'b01_000    :  Imm = { {21{IR[31]}}, IR[30:25], IR[11:8], IR[7] };
		5'b01_101    :  Imm = { IR[31], IR[30:20], IR[19:12], 12'b0 };
		5'b00_101    :  Imm = { IR[31], IR[30:20], IR[19:12], 12'b0 };
		5'b11_011    : 	Imm = { {12{IR[31]}}, IR[19:12], IR[20], IR[30:25], IR[24:21], 1'b0 };
		5'b11_001    : 	Imm = { {21{IR[31]}}, IR[30:25], IR[24:21], IR[20] };
		5'b11_000    : 	Imm = { {20{IR[31]}}, IR[7], IR[30:25], IR[11:8], 1'b0};
		default      : 	Imm = { {21{IR[31]}}, IR[30:25], IR[24:21], IR[20] }; // IMM_I
	endcase 
end

endmodule

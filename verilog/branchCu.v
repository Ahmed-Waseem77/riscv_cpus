

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
module branchCu( 
   // Port Declarations
   input   wire    [14:15-3]  Instruction, 
   input   wire               branch, 
   output  wire    [1:0]      branch_sel, 
   input   wire               cf, 
   input   wire               jump, 
   input   wire               sf, 
   input   wire               vf, 
   input   wire               zf
);




wire [2:0] func3; 
assign func3 =  Instruction;


assign branch_sel[0] = (branch == 1'b1) && (((func3 == 3'd0) && (zf == 1'b1)) 
                                        || ((func3 == 3'd1) && (zf == 1'b0))
                                        || ((func3 == 3'd4) && (sf != vf))
                                        || ((func3 == 3'd5) && (sf == vf))
                                        || ((func3 == 3'd6) && (cf == 1'b0))
                                        || ((func3 == 3'd7) && (cf == 1'b1)) 
                                        || jump);   
assign branch_sel[1] = jump;

endmodule


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
module shifter( input       [31:0] a, 
                input       [4:0]  shamt,  // 5 bits in rs2
                input       [1:0]  type,   
                // IR[30] IR[14]
                // 0      0 SLLI 
                // 0      1 SRLI s
                // 1      1 SRAI
                output reg  [31:0] r);   



wire [31:0] gnd = 32'd0;

always @ * begin 
  case(type) 
    2'b00 : r = a << shamt; 
    2'b01 : r = a >> shamt; 
    2'b11 : r = a >>> shamt;   
    default : r = gnd;
  endcase
end

endmodule

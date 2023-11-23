/* 
    RiscV32IMC Pipelined Processor  
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

`timescale 1ns / 1ps
`define  rs_1ORd Instruction_in[11:7]

module decompressor(input  [32-1:0] Instruction_in,
                    input  [8-1:0]  pc_current_address,
                    output [32-1:0] Instruction,
                    output          step);

reg [32-1:0] decompressor_reg;

always @ (*) begin 
    if(Instruction_in[1:0] != 2'b11) begin //compressed instruction
        case(Instruction_in[1:0])
            2'b01: decompressor_reg = { {(32-26){Instruction_in[12]}}, Instruction_in[12], Instruction_in[6:2] ,`rs_1ORd, 3'b000, `rs_1ORd ,7'b0010011}; //C.ADDI
            default: decompressor_reg = 32'd0;
        endcase
    end
    else begin //non compressed
        decompressor_reg = Instruction_in;
    end
end

assign Instruction = decompressor_reg;

//only do compressed steps when you encounter a lower compressed halfword
assign step = (Instruction_in[1:0] != 2'b11 && ~(^pc_current_address)) ? 1'b1 : 1'b0; 


endmodule

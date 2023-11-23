
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
   output  wire    [32 - 1:0]  Instruction_out, 
   input   wire    [8 - 1:0]   pc_current_address,
   input   wire                step
);

reg [31:0] mem [0:63]; //4kb 

//read values from text file
initial $readmemh("riscv_asm.mem", mem);


reg [32-1:0] Instruction_out_reg; 

always @(*) begin
   if(step) begin //compressed instruction encountered
      if (^pc_current_address) begin //compressed step (multiple of 6, the current compressed instruction is in upper half word)
         Instruction_out_reg = mem[pc_current_address >> 2][32-1:16];
      end
      else begin  //regular step (multiple of 4, the current compressed instruction is in lower half word)
         Instruction_out_reg = mem[pc_current_address >> 2][16-1:0];
      end
   end
   else begin 
      Instruction_out_reg = mem[pc_current_address >> 2];
   end
end

assign Instruction_out = Instruction_out_reg;

endmodule

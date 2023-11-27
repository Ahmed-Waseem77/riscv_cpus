
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
module regFile( 
   input   wire    [32 - 1:0]  Instruction, 
   input   wire                clk, 
   input   wire                reg_write, 
   output  wire    [32 - 1:0]  rs1, 
   output  wire    [32 - 1:0]  rs2, 
   input   wire                rst, 
   input   wire    [32 - 1:0]  write_data_reg_file,
   input   wire    [11:7]      Instruction_rd
);



wire [5-1:0] rs1_in, rs2_in, rd_in; 
assign rs1_in = Instruction[19:15]; 
assign rs2_in = Instruction[24:20];
assign rd_in  = Instruction_rd;


reg [32-1:0] reg_file [32-1:0]; 


integer i;
always @(negedge clk or negedge rst) begin : RESET 
  if (rst) begin 
      for (i = 0; i < 32; i = i + 1) begin 
        reg_file[i] <= 32'd0; 
      end
  end
  else if(reg_write) begin
    reg_file[rd_in] <= write_data_reg_file;
  end 
  reg_file[0] <= 32'b0;
end 

assign rs1 = reg_file[rs1_in]; 
assign rs2 = reg_file[rs2_in];



endmodule

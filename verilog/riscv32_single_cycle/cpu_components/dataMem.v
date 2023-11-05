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
module dataMem( 
   input   wire                clk, 
   input   wire                mem_read, 
   input   wire                mem_write, 
   input   wire    [32- 1:0]   r, 
   output  wire    [32 - 1:0]  read_data_out, 
   input   wire    [32 - 1:0]  rs2, 
   input   wire                rst
);


	reg [32-1:0] mem [0:64-1];  

	assign read_data_out = mem_read ? mem[r[8-1:0] >> 2 ] : read_data_out; 

	initial begin
		mem[1] = 32'd20; 
		mem[4] = 32'd1;
	end 

	always @(posedge clk) begin : MEM_WRITE_SEQ
		if (mem_write) begin 
			mem[r[8-1:0] >> 2] <= rs2; 
		end 
		else begin 
		  mem[r[8-1:0] >> 2] <= mem[r[8-1:0] >> 2];
		end
	end



endmodule

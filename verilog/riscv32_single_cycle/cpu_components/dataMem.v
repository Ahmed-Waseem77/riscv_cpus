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
   input   wire    [2:0]       mem_read, 
   input   wire    [1:0]       mem_write, 
   input   wire    [32- 1:0]   r, 
   output  reg     [32 - 1:0]  read_data_out, 
   input   wire    [32 - 1:0]  rs2, 
   input   wire                rst
);

	reg [32-1:0] mem [0:64-1];  
  integer i; 



	initial begin
		mem[0]=32'd17;
		//mem[1]=32'd9; 
		//mem[2]=32'd25;
		mem[1] = 32'b0000_0000_0000_0001_0000_0001_0000_0110; 
		mem[2] = 32'b0000_0000_0000_0001_0000_0001_0000_0110;
		mem[3] = 32'd5;
		mem[4] = 32'b0000_0000_0000_0001_0000_0001_0000_0110;
		mem[5] = 32'b0000_0000_0000_0001_0000_0001_0000_0110;
		
		for (i = 6; i < 64; i = i + 1) begin 
                    mem[i] <= 32'd0; 
        end
	end 

	//assign read_data_out = mem_read ? mem[r[8-1:0] >> 2] : read_data_out; // combinational always block 
	
	always @(*) begin : MEM_READ_COMBINATIONAL 
	  case(mem_read)  
	     3'b000: read_data_out = read_data_out;                                                    //OFF
	     3'b001: read_data_out = mem[r[8-1:0] >> 2];                                               //LW
	     3'b010: read_data_out = { {16{{mem[r[8-1:0] >> 2][15]}}}, mem[r[8-1:0] >> 2][15:0]};      //LH
	     3'b011: read_data_out = { 16'd0, mem[r[8-1:0] >> 2][15:0]};                               //LHU 
	     3'b100: read_data_out = { {24{{mem[r[8-1:0] >> 2][7]}}} , mem[r[8-1:0] >> 2][7:0]};       //LB 
	     3'b101: read_data_out = { 24'd0 , mem[r[8-1:0] >> 2][7:0]};                               //LBU
	  
	     default : read_data_out = read_data_out;
	  endcase
	end

	always @(posedge clk) begin : MEM_WRITE_SEQ 
		//if (mem_write) begin  //make into a case
		//	mem[r[8-1:0] >> 2] <= rs2; 
		//end 
		//else begin 
		//  mem[r[8-1:0] >> 2] <= mem[r[8-1:0] >> 2];
		//end
	//end 
	
	  case(mem_write) 
	    2'b00 : mem[r[8-1:0] >> 2] <= mem[r[8-1:0] >> 2]; 
	    2'b01 : mem[r[8-1:0] >> 2] <= rs2; //SW
	    2'b10 : mem[r[8-1:0] >> 2] <= {mem[r[8-1:0] >> 2][32-1:16] , rs2[15:0]}; //SH
	    2'b11 : mem[r[8-1:0] >> 2] <= {mem[r[8-1:0] >> 2][32-1:8] , rs2[7:0]};   //SB
	  endcase
	end



endmodule

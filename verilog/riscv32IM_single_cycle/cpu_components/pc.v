
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
module pc( 
   // Port Declarations
   input   wire                       clk, 
   input   wire                       load, 
   output  wire    [8 - 1:0]          pc_current_address, 
   input   wire    [8 - 1:0]          pc_target_addr, 
   input   wire                       rst
);


// Internal Declarations




// ### Please start your Verilog code here ### 
reg [8-1:0] pc; 
assign load = 1'b1; 
assign pc_current_address = pc;

always @(posedge clk or posedge rst) begin 
  if (rst) begin
    pc <= 8'b0;
  end 
  else if (load) begin 
    pc <= pc_target_addr;  
  end
  
end


endmodule

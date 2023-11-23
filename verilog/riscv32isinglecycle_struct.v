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


`resetall 

//`include "./macros.v"              //Pre-Module Directive definitions

`timescale 1ns/10ps 

module riscv32iSingleCycle #(
   parameter N        = 32,        //architecture bit size
   parameter MEM_ADDR = 8,         //addressable memory size (currently 8 bits for [8x8x8x8]x32 addresses)
   parameter REG_ADDR = 5,         //addressable registers size (currently 5 bits for 32x32 addresses)
   parameter OPCODE   = 7,         //opcode size
   parameter RS1      = REG_ADDR,
   parameter RS2      = REG_ADDR,
   parameter RD       = REG_ADDR,
   parameter FUNCT3   = 3,
   parameter FUNCT7   = 7,
   parameter SHAMT    = 5
)
( 
   // Port Declarations
   input   wire             clk, 
   input   wire             rst,
   output  wire  [8-1:0]    pc_out,
   output  wire  [32-1:0]   regfile_in_out
);

// Internal signal declarations
wire  [8-1:0]    CONST4;
wire  [8-1:0]    CONST2;
wire  [32-1:0]   Instruction;
wire  [2:0]      alu_op;
wire             alu_src;
wire  [4:0]      alufn;
wire  [32 - 1:0] b;
wire             branch;
wire  [1:0]      branch_sel;
wire             cf;
wire  [32 - 1:0] immediate;
wire             jump;
wire             load;
wire  [1:0]      mem_out_sel;
wire  [2:0]      mem_read;
wire  [1:0]      mem_write;
wire  [8-1:0]    pc_current_address;
wire  [8 - 1:0]  pc_next;
wire  [32 - 1:0] pc_plus_immediate;
wire  [8 - 1:0]  pc_target_addr;
wire  [32 - 1:0] r;
wire  [32 - 1:0] read_data_out;
wire             reg_write;
wire  [32 - 1:0] rs1;
wire  [32 - 1:0] rs2;
wire             sf;
wire             vf;
wire  [32 - 1:0] write_data_reg_file;
wire             zf;
wire  [32-1:0]   Instruction_in;
wire             step;

// Instances 

//IF STAGE
adder #(8) pc_plus_step( 
   .A_in    (step ? CONST2 : CONST4), 
   .B_in    (pc_current_address), 
   .sum_out (pc_next)
); 

pc pc_inst( 
   .clk                (clk), 
   .load               (load), 
   .pc_current_address (pc_current_address), 
   .pc_target_addr     (pc_target_addr), 
   .rst                (rst)
); 

instMem instMem_inst( 
   .Instruction_out    (Instruction_in), 
   .step               (step),
   .pc_current_address (pc_current_address)
); 

decompressor decompressor_inst(
   .Instruction_in      (Instruction_in),
   .Instruction         (Instruction),
   .pc_current_address  (pc_current_address),
   .step                (step)
);
////////////
//IF_ID PIPE



////////////
//ID STAGE
regFile regFile_inst( 
   .clk                 (clk), 
   .reg_write           (reg_write), 
   .rs1                 (rs1), 
   .rs2                 (rs2), 
   .rst                 (rst), 
   .write_data_reg_file (write_data_reg_file), 
   .Instruction         (Instruction)
); 

cu cu_inst( 
   .Instruction (Instruction), 
   .alu_op      (alu_op), 
   .alu_src     (alu_src), 
   .branch      (branch), 
   .jump        (jump), 
   .mem_out_sel (mem_out_sel), 
   .mem_read    (mem_read), 
   .mem_write   (mem_write), 
   .reg_write   (reg_write)
);

immGen immGen_inst( 
   .Instruction (Instruction), 
   .immediate   (immediate)
); 

adder pc_plus_Imm( 
   .A_in    ({24'b0, pc_current_address}), 
   .B_in    (immediate), 
   .sum_out (pc_plus_immediate)
); 
////////////
//ID_EX PIPE


////////////
//EX STAGE
mux aluSrc_mux( 
   .hi_in   (immediate), 
   .lo_in   (rs2), 
   .sel_in  (alu_src), 
   .sel_out (b)
); 

alu alu_inst( 
   .cf          (cf), 
   .r           (r), 
   .rs1         (rs1), 
   .sf          (sf), 
   .vf          (vf), 
   .zf          (zf), 
   .b           (b), 
   .alufn       (alufn)
); 

aluCu aluCu_inst( 
   .Instruction (Instruction), 
   .alu_op      (alu_op), 
   .alufn       (alufn)
); 

branchCu branchCu_inst( 
   .Instruction (Instruction[14:15-3]), 
   .branch      (branch), 
   .cf          (cf), 
   .jump        (jump), 
   .sf          (sf), 
   .vf          (vf), 
   .zf          (zf), 
   .branch_sel  (branch_sel)
); 

mux_4x1 #(8) targetAddr_mux( 
   .A_00    (pc_next), 
   .B_01    (pc_plus_immediate[8-1:0]), 
   .C_10    (pc_plus_immediate[8-1:0]), 
   .D_11    (r[8-1:0]), 
   .sel     (branch_sel), 
   .sel_out (pc_target_addr)
); 
/////////////
//EX_MEM PIPE


/////////////
//MEM STAGE
dataMem dataMem_inst( 
   .clk           (clk), 
   .mem_read      (mem_read), 
   .mem_write     (mem_write), 
   .r             (r), 
   .rs2           (rs2), 
   .rst           (rst), 
   .read_data_out (read_data_out)
); 

mux_4x1 writeToReg_mux( 
   .A_00    (read_data_out), 
   .B_01    (r), 
   .C_10    (pc_plus_immediate), 
   .D_11    ({24'd0, pc_next}), 
   .sel     (mem_out_sel), 
   .sel_out (write_data_reg_file)
); 


assign regfile_in_out = write_data_reg_file;

assign pc_out = pc_current_address;

assign CONST4 = 8'd4;

assign CONST2 = 8'd2;

assign load = 1'd1;

endmodule 

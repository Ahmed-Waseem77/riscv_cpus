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

module riscv32IMC_pipelined #(
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
wire             stall;
wire             pcSrc;

//pipeline internal declarations

wire [32-1:0]    MEM_WB_Instruction;
wire [3-1:0]     MEM_WB_WB; 
wire [7-1:0]       EX_MEM_M; 

wire [32-1:0]    EX_MEM_r; 

wire [32-1:0]      EX_MEM_rs2;

// Instances 




//IF STAGE
adder #(8) pc_plus_step( 
   .A_in    (step ? CONST2 : CONST4), 
   .B_in    (pc_current_address), 
   .sum_out (pc_next)
); 

pc pc_inst( 
   .clk                (clk), 
   .load               ((stall != 1)&(!(EX_MEM_M[4:2]|EX_MEM_M[1:0]))), 
   .pc_current_address (pc_current_address), 
   .pc_target_addr     (pc_target_addr), 
   .rst                (rst)
); 
/*
instMem instMem_inst( 
   .Instruction_out    (Instruction_in), 
   .step               (step),
   .pc_current_address (pc_current_address)
); */
single_memory SM(
             .clk           (clk), 
            .mem_read      (EX_MEM_M[4:2] ), //mem_read
            .mem_write     (EX_MEM_M[1:0] ), //mem_write 
            .rs2           (EX_MEM_rs2), 
            .rst           (rst), 
            .read_data_out (read_data_out),
            .Instruction_out_reg(Instruction_in),
            .step               (step),
            .r_or_pc_current_address (((EX_MEM_M[4:2]!=0)|(EX_MEM_M[1:0]!=0))?EX_MEM_r:{24'b0, pc_current_address})
    );
decompressor decompressor_inst(
   .Instruction_in      (Instruction_in),
   .Instruction         (Instruction),
   .pc_current_address  (pc_current_address),
   .step                (step)
);
////////////
//IF_ID PIPE

//concats
wire [32+8-1:0] IF_ID_data_in; 
wire [32+8-1:0] IF_ID_data_out; 

//register outputs
wire [32-1:0]   IF_ID_Instruction; 
wire [8-1:0]    IF_ID_pc_current_address;


assign IF_ID_data_in = 
{
   (pcSrc|EX_MEM_M[4:2]|EX_MEM_M[1:0]) ?  32'h00000033 : Instruction,
   pc_current_address
};

assign 
{
   IF_ID_Instruction,
   IF_ID_pc_current_address
}= IF_ID_data_out;

register #(.N(32+8)) IF_ID (
   .clk (clk), 
   .rst (rst), 
   .load(~stall), 
   .D   (IF_ID_data_in),
   .Q   (IF_ID_data_out)
);

////////////
//ID STAGE

                                                     

regFile regFile_inst( 
   .clk                 (clk), 
   .reg_write           (MEM_WB_WB[2] /*reg_write*/), 
   .rs1                 (rs1), 
   .rs2                 (rs2), 
   .rst                 (rst), 
   .write_data_reg_file (write_data_reg_file), 
   .Instruction         (IF_ID_Instruction),
   .Instruction_rd      (MEM_WB_Instruction[11:7])
); 

cu cu_inst( 
   .Instruction (IF_ID_Instruction), 
   .alu_op      (alu_op), 
   .alu_src     (alu_src), 
   .branch      (branch), 
   .jump        (jump), 
   .mem_out_sel (mem_out_sel), 
   .mem_read    (mem_read), 
   .mem_write   (mem_write), 
   .reg_write   (reg_write)
);

//hazard detection mux
wire [3+1+1+1+2+3+2+1:0] temp1;
assign temp1 = (stall || pcSrc) ? 0 : {alu_op, alu_src, branch, jump, mem_out_sel, mem_read, mem_write, reg_write}; 

wire  [3-1:0]    alu_op_mx, mem_read_mx;
wire             alu_src_mx, branch_mx, jump_mx, reg_write_mx;
wire  [2-1:0]    mem_out_sel_mx, mem_write_mx;

assign {alu_op_mx, alu_src_mx, branch_mx, jump_mx, mem_out_sel_mx, mem_read_mx, mem_write_mx, reg_write_mx} = temp1;


immGen immGen_inst( 
   .Instruction (IF_ID_Instruction), 
   .immediate   (immediate)
); 

////////////
//ID_EX PIPE
//concats
wire [32+8+3+5+7+32+32+32-1:0]    ID_EX_data_in; 
wire [32+8+3+5+7+32+32+32-1:0]    ID_EX_data_out; 
wire [1+2-1:0]                    ID_EX_WB_in; 
wire [7-1:0]                      ID_EX_M_in; 
wire [4-1:0]                      ID_EX_EX_in;

//register outputs
wire [32-1:0]      ID_EX_Instruction; 
wire [8-1:0]       ID_EX_pc_current_address;
wire [3-1:0]       ID_EX_WB; 
wire [7-1:0]       ID_EX_M; 
wire [4-1:0]       ID_EX_EX;
wire [32-1:0]      ID_EX_rs1; 
wire [32-1:0]      ID_EX_rs2; 
wire [32-1:0]      ID_EX_immediate;

assign ID_EX_WB_in = 
{
  reg_write_mx,
  mem_out_sel_mx
};

assign ID_EX_M_in = 
{
  branch_mx,
  jump_mx,
  mem_read_mx,
  mem_write_mx
};

assign ID_EX_EX_in = 
{
  alu_src_mx,
  alu_op_mx
};

assign ID_EX_data_in = 
{
   ID_EX_WB_in,
   ID_EX_M_in,
   ID_EX_EX_in,
   IF_ID_Instruction,
   IF_ID_pc_current_address,
   rs1,
   rs2,
   immediate
};

assign
{
   ID_EX_WB,
   ID_EX_M,
   ID_EX_EX,
   ID_EX_Instruction,
   ID_EX_pc_current_address,
   ID_EX_rs1,
   ID_EX_rs2,
   ID_EX_immediate
} = ID_EX_data_out;

register #(.N(32+8+3+5+7+32+32+32)) ID_EX (
   .clk (clk), 
   .rst (rst), 
   .load(1'b1), 
   .D   (ID_EX_data_in), 
   .Q   (ID_EX_data_out)
);


////////////
//EX STAGE

hazard_detection_unit hazard_detection_unit_inst(
   .IF_ID_RegisterRs1(IF_ID_Instruction[19:15]), 
   .IF_ID_RegisterRs2(IF_ID_Instruction[24:20]),
   .ID_EX_RegisterRd(ID_EX_Instruction[11:7]), 
   .ID_EX_memRead((ID_EX_M[2:0] != 3'd0)), 
   .stall(stall)
);         

wire [1:0] s1_sel;
wire [1:0] s2_sel;

forwarding_unit forwarding_unit_inst 
(   
    .ID_EX_rs1_addr(ID_EX_Instruction[19:15]), 
    .ID_EX_rs2_addr(ID_EX_Instruction[24:20]), 
    .EX_MEM_rd(EX_MEM_Instruction[11:7]),
    .MEM_WB_rd(MEM_WB_Instruction[11:7]), 
    .EX_MEM_wb(EX_MEM_WB[2:1]),
    .MEM_WB_wb(MEM_WB_WB[2:1]),
    .s1_sel(s1_sel), 
    .s2_sel(s2_sel)                  
); 

wire [32-1:0] forwarded_rs1; 
wire [32-1:0] forwarded_rs2; 

assign forwarded_rs1 = s1_sel[1] ? (s1_sel[0] ? 32'hdeadbeef : EX_MEM_r) 
                                   : (s1_sel[0] ? write_data_reg_file : ID_EX_rs1); 

assign forwarded_rs2 = s2_sel[1] ? (s2_sel[0] ? 32'hdeadbeef : EX_MEM_r) 
                                   : (s2_sel[0] ? write_data_reg_file : ID_EX_rs2);  


adder pc_plus_Imm( 
   .A_in    ({24'b0, ID_EX_pc_current_address}), 
   .B_in    (ID_EX_immediate), 
   .sum_out (pc_plus_immediate)
); 

mux aluSrc_mux( 
   .hi_in   (ID_EX_immediate), 
   .lo_in   (forwarded_rs2), 
   .sel_in  (ID_EX_EX[3] /*alu_src*/), 
   .sel_out (b)
); 

alu alu_inst( 
   .cf          (cf), 
   .r           (r), 
   .rs1         (forwarded_rs1), 
   .sf          (sf), 
   .vf          (vf), 
   .zf          (zf), 
   .b           (b), 
   .alufn       (alufn)
); 

aluCu aluCu_inst( 
   .Instruction (ID_EX_Instruction), 
   .alu_op      (ID_EX_EX[2:0] /*alu_op*/), 
   .alufn       (alufn)
); 

wire [3+1+1+1+2+2:0] temp2;

assign temp2 = (pcSrc) ? 0 : {ID_EX_WB, ID_EX_M}; 

wire [3-1:0] ID_EX_WB_mx;
wire [7-1:0] ID_EX_M_mx;

assign {ID_EX_WB_mx, ID_EX_M_mx} = temp2;

/////////////
//EX_MEM PIPE
//concats
wire [4+32*4+8+3+7-1:0]    EX_MEM_data_in; 
wire [4+32*4+8+3+7-1:0]    EX_MEM_data_out; 
wire [7-1:0]               EX_MEM_M_in; 
wire [3-1:0]               EX_MEM_WB_in;

//register outputs

wire [3-1:0]       EX_MEM_WB;
wire [32-1:0]      EX_MEM_Instruction; 
wire [8-1:0]       EX_MEM_pc_current_address;
wire [32-1:0]      EX_MEM_pc_plus_immediate;
//wire [32-1:0]      EX_MEM_r; 
 

wire EX_MEM_cf, EX_MEM_sf, EX_MEM_vf, EX_MEM_zf;

assign EX_MEM_WB_in = ID_EX_WB_mx;

assign EX_MEM_M_in = ID_EX_M_mx;

assign EX_MEM_data_in = 
{
   EX_MEM_WB_in,
   EX_MEM_M_in,
   ID_EX_Instruction,
   ID_EX_pc_current_address,
   pc_plus_immediate,
   r,
   forwarded_rs2,
   cf,
   sf,
   vf,
   zf
};

assign
{
   EX_MEM_WB,
   EX_MEM_M,
   EX_MEM_Instruction,
   EX_MEM_pc_current_address,
   EX_MEM_pc_plus_immediate,
   EX_MEM_r,
   EX_MEM_rs2,
   EX_MEM_cf,
   EX_MEM_sf,
   EX_MEM_vf,
   EX_MEM_zf
} = EX_MEM_data_out;

register #(.N(4+32*4+8+3+7)) EX_MEM (
   .clk (clk), 
   .rst (rst), 
   .load(1'b1), 
   .D   (EX_MEM_data_in),
   .Q   (EX_MEM_data_out)
);

/////////////
//MEM STAGE

branchCu branchCu_inst( 
   .Instruction (EX_MEM_Instruction[14:15-3]), 
   .branch      (EX_MEM_M[6] /*branch*/), 
   .jump        (EX_MEM_M[5] /*jump*/), 
   .cf          (EX_MEM_cf),
   .sf          (EX_MEM_sf), 
   .vf          (EX_MEM_vf), 
   .zf          (EX_MEM_zf), 
   .branch_sel  (branch_sel)
); 

mux_4x1 #(8) targetAddr_mux( 
   .A_00    (pc_next), 
   .B_01    (EX_MEM_pc_plus_immediate[8-1:0]), 
   .C_10    (EX_MEM_pc_plus_immediate[8-1:0]), //redundancy
   .D_11    (EX_MEM_r[8-1:0]),  //jalr
   .sel     (branch_sel), 
   .sel_out (pc_target_addr)
); 
/*
dataMem dataMem_inst( 
   .clk           (clk), 
   .mem_read      (EX_MEM_M[4:2] ), //mem_read
   .mem_write     (EX_MEM_M[1:0] ), //mem_write
   .r             (EX_MEM_r), 
   .rs2           (EX_MEM_rs2), 
   .rst           (rst), 
   .read_data_out (read_data_out)
); 
*/

/////////////
//MEM_WB PIPE
/////////////

wire [4+32*5+8-1:0]    MEM_WB_data_in; 
wire [4+32*5+8-1:0]    MEM_WB_data_out; 
wire [3-1:0]           MEM_WB_WB_in;

//register outputs
//wire [3-1:0]       MEM_WB_WB;          //declared before reg module
//wire [32-1:0]      MEM_WB_Instruction; //declared before reg module
wire [8-1:0]       MEM_WB_pc_current_address;
wire [32-1:0]      MEM_WB_pc_plus_immediate;
wire [32-1:0]      MEM_WB_r;  //alu result
wire [32-1:0]      MEM_WB_rs2; 
wire [32-1:0]      MEM_WB_read_data_out;


assign MEM_WB_WB_in = EX_MEM_WB;

assign MEM_WB_data_in = 
{
   MEM_WB_WB_in,
   EX_MEM_Instruction,
   EX_MEM_pc_current_address,
   EX_MEM_pc_plus_immediate,
   EX_MEM_r,
   EX_MEM_rs2,
   read_data_out
};

assign
{
   MEM_WB_WB,
   MEM_WB_Instruction,
   MEM_WB_pc_current_address,
   MEM_WB_pc_plus_immediate,
   MEM_WB_r,
   MEM_WB_rs2,
   MEM_WB_read_data_out
} = MEM_WB_data_out;

register #(.N(4+32*5+8)) MEM_WB (
   .clk (clk), 
   .rst (rst), 
   .load(1'b1), 
   .D   (MEM_WB_data_in),
   .Q   (MEM_WB_data_out)
);

////////////
//WB STAGE
///////////

mux_4x1 writeToReg_mux( 
   .A_00    (MEM_WB_read_data_out), 
   .B_01    (MEM_WB_r), 
   .C_10    (MEM_WB_pc_plus_immediate), 
   .D_11    ({24'd0, MEM_WB_pc_current_address + 4}), 
   .sel     (MEM_WB_WB[1:0]), 
   .sel_out (write_data_reg_file)
); 

// 

assign pcSrc = (branch_sel != 0);

//CONSTANTS AND FPGA VERIFICATION OUTPUTS

assign regfile_in_out = write_data_reg_file;

assign pc_out = pc_current_address;

assign CONST4 = 8'd4;

assign CONST2 = 8'd2;

assign load = 1'd1;

endmodule 

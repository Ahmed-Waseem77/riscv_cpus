
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

module alu( 
   input   wire    [4:0]       alufn, 
   input   wire    [32 - 1:0]  b, 
   output  wire                cf, 
   output  reg     [32- 1:0]   r, 
   input   wire    [32 - 1:0]  rs1, 
   output  wire                sf, 
   output  wire                vf, 
   output  wire                zf
);


// Internal Declarations
    wire [32-1:0] a; 
    wire [4:0] shamt; 
    assign shamt = b[4:0];
    assign a = rs1;
    
    
    wire [31:0] add, divu, remu, op_b;
    wire signed [31:0] mul, mulh, mulhsu, div, rem;
    wire [31:0] mulhu;
    
    wire signed [64-1:0] mul_temp; 
    wire [64-1:0] mulu_temp;      //UNSINGED
    
    
    assign div = a / b; 
    assign divu = a / b; 
    assign rem = a % b; 
    assign remu = a % b;
    assign mul_temp = a * b;
    assign mulu_temp = a * b;
    
    assign mul    = mul_temp[32-1:0]; 
    assign mulh   = mul_temp[64-1:32];   //SIGNED
    assign mulhu  = mulu_temp[64-1:32];  //UNSIGNED
    assign mulhsu = mul_temp[64-1:32];   //SIGNED 
    
    assign op_b = (~b);
    
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b); // Either a Subtraction or addition 
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);
    
    wire[31:0] sh;
    shifter shifter0(.a(a), .shamt(shamt), .type(alufn[1:0]),  .r(sh));
    

    initial begin 
      r = 0; 
    end

    always @ (*) begin
        //(* parallel_case *)
        case (alufn)
            // arithmetic
            5'b000_00 : r = add;
            5'b000_01 : r = add;
            5'b000_11 : r = b;
            // logic
            5'b001_00:  r = a | b;
            5'b001_01:  r = a & b;
            5'b001_11:  r = a ^ b;
            // shift
            5'b010_00:  r = sh;
            5'b010_01:  r = sh;
            5'b010_10:  r = sh;
            // slt & sltu
            5'b011_01:  r = {31'b0,(sf != vf)}; 
            5'b011_11:  r = {31'b0,(~cf)};    
            // jalr
            5'b011_10:  r = {add[32-1:1], 1'b0}; 
            // mul div & rem 
            5'b10000 :  r = mul; //MUL
            5'b10001 :  r = mulh; //MULH 
            5'b10010 :  r = mulhsu; //MULHSU
            5'b10011 :  r = mulhu; //MULHU
            5'b10100 :  r = div; //DIV
            5'b10101 :  r = divu; //DIVU
            5'b10110 :  r = rem; //REM
            5'b10111 :  r = remu; //REMU 
            
            default : r = r;
        endcase
    end
endmodule

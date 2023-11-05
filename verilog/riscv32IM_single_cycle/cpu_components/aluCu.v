
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
module aluCu( 
   input   wire    [32-1:0]   Instruction, 
   input   wire    [2:0]      alu_op, 
   output  reg     [4:0]      alufn
);


// Internal Declarations


// nop    sub   add           I-FORMAT/R-FORMAT FUNCT           MUL/DIV/REM FUNCT     
// 000    001   010           011                               100                                <= aluop
// 0011   0001  check JALR    case on FUNCT                     case on FUNCT                      <= alufn output


always @(*) begin : COMBINATIONAL_OUTPUT 
  case(alu_op) 
    3'b000 : alufn = 5'b00011; //NOP
    3'b001 : alufn = 5'b00001; //SUB DEF ( BRANCHES )
    3'b010 : begin 
              if (Instruction[3]) begin 
                alufn = 5'b01110; //JALR
              end 
              else begin 
                alufn = 5'b00000; //ADD DEF ( LOAD STORE ) 
              end
            end 

    3'b011 : begin            //FUNC3 I-FORMAT/ R-FORMAT
              case (Instruction[14:12]) 
                3'b000 : begin 
                           if(Instruction[30]==1'b1 && Instruction[5]) begin 
                               alufn = 5'b00001; //SUB
                           end 
                           else begin 
                               alufn = 5'b00000; //ADD / ADDI
                           end 
                         end   
                                        
                3'b010 : alufn = 5'b01101;       //SLT/SLTI 
                3'b011 : alufn = 5'b01111;       //SLTU/SLTIU 
                3'b100 : alufn = 5'b00111;       //XOR/XORI 
                3'b110 : alufn = 5'b00100;       //OR/ORI 
                3'b111 : alufn = 5'b00101;       //AND/ANDI
                3'b001 : alufn = 5'b01000;       //SLL/SLLI
                
                3'b101 :  begin 
                            if (Instruction[30]==1'b1) begin
                              alufn = 5'b01001;  //SRL/SRLI
                            end
                            else begin 
                              alufn = 5'b01010;  //SRA/SRAI
                            end
                          end
                
                default : alufn = 5'b00011;
              endcase
             end
            
    3'b100 : begin // FUNCT ON MUL/DIV/REM
               case(Instruction[14:12])
                 3'b000 : alufn = 5'b10000;     //MUL
                 3'b010 : alufn = 5'b10001;     //MULH
                 3'b011 : alufn = 5'b10010;     //MULHSU
                 3'b100 : alufn = 5'b10011;     //MULHU
                 3'b110 : alufn = 5'b10100;     //DIV
                 3'b111 : alufn = 5'b10101;     //DIVU
                 3'b001 : alufn = 5'b10110;     //REM
                 3'b101 : alufn = 5'b10111;     //REMU
                 
                 default : alufn = 5'b00011;                
               endcase
             end
                
    
    default : alufn = 5'b00011;
  endcase
  
end

endmodule

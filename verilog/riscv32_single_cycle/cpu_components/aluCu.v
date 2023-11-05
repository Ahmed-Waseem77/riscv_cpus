

`resetall
`timescale 1ns/10ps
module aluCu( 
   input   wire    [32-1:0]   Instruction, 
   input   wire    [1:0]      alu_op, 
   output  reg     [3:0]      alufn
);


// Internal Declarations

//LUI     nop
//AUIPC   no alu
//JAL     no alu 
//JALR    no alu
//BRANCH  sub 
//LOAD    add 
//STORE   add 
//I-F     FUNCT 
//R-F     FUNCT 

// nop    sub   add   FUNCT 
// 00     01    10    11                  <= aluop
// 0011   0001  0000  case on FUNCT       <= alufn output


always @(*) begin : COMBINATIONAL_OUTPUT 
  case(alu_op) 
    2'b00 : alufn = 4'b0011; //NOP
    2'b01 : alufn = 4'b0001; //SUB
    2'b10 : alufn = 4'b0000; //ADD
    2'b11 : begin            //FUNC3 
              case (Instruction[14:12]) 
                3'b000 : begin 
                           if(Instruction[30]==1'b1) begin 
                               alufn = 4'b0001; //SUB
                           end 
                           else begin 
                               alufn = 4'b0000; //ADD/ADDI
                           end 
                         end                  
                3'b010 : alufn = 4'b1101;       //SLT/SLTI 
                3'b011 : alufn = 4'b1111;       //SLTU/SLTIU 
                3'b100 : alufn = 4'b0111;       //XOR/XORI 
                3'b110 : alufn = 4'b0100;       //OR/ORI 
                3'b111 : alufn = 4'b0101;       //AND/ANDI
                3'b001 : alufn = 4'b1000;       //SLL/SLLI
                3'b101 :  begin 
                            if (Instruction[30]==1'b1) begin
                              alufn = 4'b1001;  //SRL/SRLI
                            end
                            else begin 
                              alufn = 4'b1010;  //SRA/SRAI
                            end
                          end
                
                default : alufn = 4'b0011;
                
              endcase
            end
  endcase
  
end

endmodule

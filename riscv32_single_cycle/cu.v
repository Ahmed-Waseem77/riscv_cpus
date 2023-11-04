

`resetall
`timescale 1ns/10ps
module cu( 
   input   wire    [7-1:0]  Instruction, 
   output  wire    [1:0]    alu_op, 
   output  wire             alu_src, 
   output  wire             branch, 
   output  wire             jump, 
   output  wire    [1:0]    mem_out_sel, 
   output  wire             mem_read, 
   output  wire             mem_write, 
   output  wire             reg_write
);

// ### Please start your Verilog code here ### 



    
    
// Internal Declarations
    reg [9:0] flags;
    
    assign {jump, branch, mem_read, mem_out_sel, alu_op, mem_write, alu_src, reg_write} = flags;
      

    initial begin 
        flags = 8'b00000000; 
    end
    
    
    // nop    sub   add   FUNCT 
    // 00     01    10    11                  <= aluop
    // 0011   0001  0000  case on FUNCT       <= alufn output
    
    always @ (*) begin : COMBINATIONAL_OUTPUT
        case(Instruction) 
            
            //LUI 
            7'b0110111 : flags = 10'b000_01_00_011; 
            
            //AUIPC 
            7'b0010111 : flags = 10'b000_10_00_001; 
            
            //JAL      
            7'b1101111 : flags = 10'b100_00_00_000; 
            
            //I-format 
            7'b0010011 : flags = 10'b000_01_11_011;
            
            // R-format
            7'b0110011 : flags = 10'b000_10_10_001;
            
            // LW
            7'b0000011 : flags = 10'b001_00_00_011;
            
            // SW 
            7'b0100011 : flags = 10'b000_00_00_110;
            
            // BRANCHES 
            7'b1100011 : flags = 10'b010_01_01_000;
          
            
            default    : flags = 10'b000_00_00_000; 
            
        endcase
        
    end


// Internal Declarations
endmodule
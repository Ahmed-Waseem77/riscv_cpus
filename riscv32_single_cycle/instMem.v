
`resetall
`timescale 1ns/10ps
module instMem( 
   output  wire    [32 - 1:0]  Instruction, 
   input   wire    [8 - 1:0]   pc_current_address
);

// ### Please start your Verilog code here ###
// Internal Declarations
reg [31:0] mem [0:63]; //4kb 

assign Instruction = mem[pc_current_address];

initial begin 
  		mem[0]	=	32'b00000000010000000010000110000011 ;	//lw x3, 4(x0)
 		mem[1]	=	32'b11111111110000011010000010000011 ;	//lw x1, -4(x3)
 		mem[2]	=	32'b01000000000100011000000110110011 ;	//sub x3,x3,x1
 		mem[3]	=	32'b00000000000000011000010001100011 ;	//beq x0,x0,4
 		mem[4]	=	32'b11111110000000000000110011100011 ;  //beq x0,x0,-4
 		mem[5]  = 32'b00000000000100001000000000110011 ;  //add x0, x1,
end

endmodule

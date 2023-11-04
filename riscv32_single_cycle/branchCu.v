

`resetall
`timescale 1ns/10ps
module branchCu( 
   // Port Declarations
   input   wire    [14:15-3]  Instruction, 
   input   wire               branch, 
   output  wire    [1:0]      branch_sel, 
   input   wire               cf, 
   input   wire               jump, 
   input   wire               sf, 
   input   wire               vf, 
   input   wire               zf
);


// Internal Declarations


wire [2:0] func3; 
assign func3 =  Instruction;

// ### Please start your Verilog code here ### 

assign branch_sel[0] = (branch == 1'b1) && (func3 == 3'd0) && (zf == 1'b1);   //BEQ
assign branch_sel[0] = (branch == 1'b1) && (func3 == 3'd1) && (zf == 1'b0);   //BNE
assign branch_sel[0] = (branch == 1'b1) && (func3 == 3'd4) && (sf != vf);     //BLT
assign branch_sel[0] = (branch == 1'b1) && (func3 == 3'd5) && (sf == vf);     //BGT
assign branch_sel[0] = (branch == 1'b1) && (func3 == 3'd6) && (cf == 1'b0);   //
assign branch_sel[0] = (branch == 1'b1) && (func3 == 3'd7) && (cf == 1'b1);   //
assign branch_sel[1] = jump;



endmodule

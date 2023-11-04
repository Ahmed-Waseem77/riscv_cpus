`resetall
`timescale 1ns/10ps
module immGen( 
   // Port Declarations
   input   wire    [32-1:0]    Instruction, 
   output  wire    [32 - 1:0]  immediate
);


// Internal Declarations

wire [32-1:0] IR; 
reg  [32-1:0] Imm;

assign IR = Instruction; 
assign immediate = Imm;

// ### Please start your Verilog code here ### 

always @(*) begin
	case (IR[6:2])
		5'b00_100    : 	Imm = { {21{IR[31]}}, IR[30:25], IR[24:21], IR[20] };
		5'b01_000    :  Imm = { {21{IR[31]}}, IR[30:25], IR[11:8], IR[7] };
		5'b01_101    :  Imm = { IR[31], IR[30:20], IR[19:12], 12'b0 };
		5'b00_101    :  Imm = { IR[31], IR[30:20], IR[19:12], 12'b0 };
		5'b11_011    : 	Imm = { {12{IR[31]}}, IR[19:12], IR[20], IR[30:25], IR[24:21], 1'b0 };
		5'b11_001    : 	Imm = { {21{IR[31]}}, IR[30:25], IR[24:21], IR[20] };
		5'b11_000    : 	Imm = { {20{IR[31]}}, IR[7], IR[30:25], IR[11:8], 1'b0};
		default      : 	Imm = { {21{IR[31]}}, IR[30:25], IR[24:21], IR[20] }; // IMM_I
	endcase 
end

endmodule

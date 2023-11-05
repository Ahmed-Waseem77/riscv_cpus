

module alu( 
   input   wire    [24:20]     Instruction, 
   input   wire    [3:0]       alufn, 
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
    wire shamt; 
    assign shamt = Instruction;
    assign a = rs1;
    
    
    wire [31:0] add, op_b;
    
    assign op_b = (~b);
    
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b); // Either a Subtraction or addition 
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);
    
    wire[31:0] sh;
    shifter shifter0(.a(a), .shamt(shamt), .type(alufn[1:0]),  .r(sh));
    


    always @ * begin
        r = 0;
        (* parallel_case *)
        case (alufn)
            // arithmetic
            4'b00_00 : r = add;
            4'b00_01 : r = add;
            4'b00_11 : r = b;
            // logic
            4'b01_00:  r = a | b;
            4'b01_01:  r = a & b;
            4'b01_11:  r = a ^ b;
            // shift
            4'b10_00:  r = sh;
            4'b10_01:  r = sh;
            4'b10_10:  r = sh;
            // slt & sltu
            4'b11_01:  r = {31'b0,(sf != vf)}; 
            4'b11_11:  r = {31'b0,(~cf)};            	
        endcase
    end
endmodule



`resetall
`timescale 1ns/10ps
module shifter( input       [31:0] a, 
                input       [4:0]  shamt,  // 5 bits in rs2
                input       [1:0]  type,   
                // IR[30] IR[14]
                // 0      0 SLLI 
                // 0      1 SRLI s
                // 1      1 SRAI
                output reg  [31:0] r);   


// ### Please start your Verilog code here ###  

wire [31:0] gnd = 32'd0;

always @ * begin 
  case(type) 
    2'b00 : r = a << shamt; 
    2'b01 : r = a >> shamt; 
    2'b11 : r = a >>> shamt;   
    default : r = gnd;
  endcase
end

endmodule

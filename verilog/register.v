
`resetall
`timescale 1ns/10ps

module register #(parameter N=32)( 
   input   wire               clk, 
   input   wire               load, 
   output  wire    [N - 1:0]  Q, 
   input   wire    [N - 1:0]  D, 
   input   wire               rst
);

// Internal Declarations
reg   [N-1:0]   flipflops = {N{1'b0}}; // Initialize to zero
wire  [N-1:0]   gnd = {N{1'b0}}; 

assign Q = flipflops;

always @(posedge clk or posedge rst) begin 
  if (rst) begin
    flipflops <= gnd;
  end 
  else if (load) begin 
    flipflops <= D;  
  end
end

endmodule


`resetall
`timescale 1ns/10ps
module pc( 
   // Port Declarations
   input   wire                       clk, 
   input   wire                       load, 
   output  wire    [8 - 1:0]   pc_current_address, 
   input   wire    [32 - 1:0]          pc_target_addr, 
   input   wire                       rst
);


// Internal Declarations




// ### Please start your Verilog code here ### 
reg [32-1:0] pc; 
assign load = 1'b1; 
assign pc_current_address = pc;

always @(posedge clk or negedge rst) begin 
  if (!rst) begin
    pc <= 32'd0;
  end 
  else if (load) begin 
    pc <= pc_target_addr;  
  end
  
end


endmodule

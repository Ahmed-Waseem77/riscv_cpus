

`resetall
`timescale 1ns/10ps
module regFile( 
   input   wire    [32 - 1:0]  Instruction, 
   input   wire                clk, 
   input   wire                reg_write, 
   output  wire    [32 - 1:0]  rs1, 
   output  wire    [32 - 1:0]  rs2, 
   input   wire                rst, 
   input   wire    [32 - 1:0]  write_data_reg_file
);

// ### Please start your Verilog code here ###


// Internal Declarations


wire [5-1:0] rs1_in, rs2_in, rd_in; 
assign rs1_in = Instruction[19:15]; 
assign rs2_in = Instruction[24:20];
assign rd_in  = Instruction[11:7];


reg [32-1:0] reg_file [32-1:0]; 


integer i;
always @(posedge clk or posedge rst) begin : RESET 
  if (rst) begin 
      for (i = 0; i < 32; i = i + 1) begin 
        reg_file[i] <= 32'd0; 
      end
  end
  else if(reg_write) begin
    reg_file[rd_in] <= write_data_reg_file;
  end 
  reg_file[0] <= 32'b0;
end 

assign rs1 = reg_file[rs1_in]; 
assign rs2 = reg_file[rs2_in];



endmodule

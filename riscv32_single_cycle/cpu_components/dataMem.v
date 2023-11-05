
`resetall
`timescale 1ns/10ps
module dataMem( 
   // Port Declarations
   input   wire                clk, 
   input   wire                mem_read, 
   input   wire                mem_write, 
   input   wire    [32- 1:0]   r, 
   output  wire    [32 - 1:0]  read_data_out, 
   input   wire    [32 - 1:0]  rs2, 
   input   wire                rst
);


// Internal Declarations




// ### Please start your Verilog code here ### 

	reg [32-1:0] mem [0:64-1];  

	assign read_data_out = mem_read ? mem[r[8-1:0] >> 2 ] : read_data_out; 

	initial begin
		mem[0]=32'd17; 
        mem[1]=32'd9; 
        mem[2]=32'd25; 
		//mem[1] = 32'd20; 
		//mem[4] = 32'd1;
	end 

	always @(posedge clk) begin : MEM_WRITE_SEQ
		if (mem_write) begin 
			mem[r[8-1:0] >> 2] <= rs2; 
		end 
		else begin 
		  mem[r[8-1:0] >> 2] <= mem[r[8-1:0] >> 2];
		end
	end



endmodule

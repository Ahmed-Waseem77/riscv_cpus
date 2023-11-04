

`resetall
`timescale 1ns/10ps
module mux #(parameter N=32)( input[N-1:0] hi_in, lo_in, 
                              input sel_in, 
                              output [N-1:0] sel_out);


// ### Please start your Verilog code here ### 

assign sel_out = sel_in ? hi_in : lo_in;

endmodule

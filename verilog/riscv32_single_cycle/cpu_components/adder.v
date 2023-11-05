

`resetall
`timescale 1ns/10ps
module adder #(parameter N=32)( input [N-1:0] A_in, 
                                input [N-1:0] B_in, 
                                output [N-1:0] sum_out);


// ### Please start your Verilog code here ### 

wire gnd; 

assign {gnd, sum_out} = A_in + B_in;
assign gnd = 1'b0;  //Assigning carry out to ground

endmodule

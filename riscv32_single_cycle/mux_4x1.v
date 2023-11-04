
`resetall
`timescale 1ns/10ps
module mux_4x1 #(parameter N = 32)(  input   [N-1:0] A_00, B_01, C_10, D_11,  
                                input   [1:0]   sel,
                                output  [N-1:0] sel_out
                                );


// ### Please start your Verilog code here ### 

assign sel_out = sel[1]   ? (sel[0] ? D_11 : C_10) : 
                            (sel[0] ? B_01 : A_00) ;


endmodule

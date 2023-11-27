`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2023 11:18:57 AM
// Design Name: 
// Module Name: hazard_detection_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module hazard_detection_unit(
                            input [4:0] IF_ID_RegisterRs1, 
                            input [4:0] IF_ID_RegisterRs2,
                            input [4:0]  ID_EX_RegisterRd, 
                            input ID_EX_memRead, 
                            output reg stall
                            );
                            
always @(*) begin 
if     (  ((IF_ID_RegisterRs1==ID_EX_RegisterRd) 
        || (IF_ID_RegisterRs2==ID_EX_RegisterRd)) 
     && ID_EX_memRead 
     && ID_EX_RegisterRd != 0) begin
        stall = 1;
     end
     else begin
        stall = 0;
     end
end
    
endmodule

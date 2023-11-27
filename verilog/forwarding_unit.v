`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2023 09:32:35 AM
// Design Name: 
// Module Name: forwarding_unit
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




`timescale 1ns/1ps

module forwarding_unit(
input       [5-1:0] ID_EX_rs1_addr, 
input       [5-1:0] ID_EX_rs2_addr, 
input       [5-1:0] EX_MEM_rd,
input       [5-1:0] MEM_WB_rd, 
input       [1:0] EX_MEM_wb, 
input       [1:0] MEM_WB_wb,
output reg  [1:0] s1_sel, 
output reg  [1:0] s2_sel
    );  



    
always @ (*) begin 

    if (EX_MEM_wb[1] 
    && (EX_MEM_rd != 5'b0) 
    && (EX_MEM_rd == ID_EX_rs1_addr)) begin 
        
        s1_sel = 2'b10;  
    end  
    else if (MEM_WB_wb[1]
         && (MEM_WB_rd != 5'b0 ) 
         && (MEM_WB_rd == ID_EX_rs1_addr))
    begin 

       
       s1_sel = 2'b01;
       
    end     
    else begin 
      s1_sel =2'b00;
    end
  end 

  always @(*) begin
    if (EX_MEM_wb[1] 
    && (EX_MEM_rd != 5'b0) 
    && (EX_MEM_rd == ID_EX_rs2_addr)) begin  
        
        s2_sel = 2'b10;  
    end     
    else if (MEM_WB_wb[1] 
         && (MEM_WB_rd != 5'b0 ) 
         && (MEM_WB_rd == ID_EX_rs2_addr)) begin 
        
        s2_sel = 2'b01; 
        
    end 
    else begin 
      s2_sel =2'b00;
    end
end 
    
    
endmodule
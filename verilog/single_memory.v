`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2023 08:53:40 AM
// Design Name: 
// Module Name: single_memory
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


module single_memory(
     input   wire                clk, 
 
    input   wire                step,
    input   wire    [2:0]       mem_read, 
    input   wire    [1:0]       mem_write, 
    input   wire    [32- 1:0]   r_or_pc_current_address, 
    output  wire     [32 - 1:0]  read_data_out, 
    output  reg     [32 - 1:0]  Instruction_out_reg,                                       
    input   wire    [32 - 1:0]  rs2, 
    input   wire                rst
    );
    reg [32-1:0] mem [0:128-1];  
    wire    [8 - 1:0]   pc_current_address = ((mem_read!=0)|(mem_write!=0))? pc_current_address:r_or_pc_current_address[8 - 1:0]; 
    wire    [31 : 0]r = ((mem_read!=0)|(mem_write!=0))? r_or_pc_current_address : r;
    //read values from text file
    initial $readmemh("riscv_asm.mem", mem);
    initial begin
        //mem[64]=32'd17;
        //mem[65]=32'd9;
        //mem[66]=32'd25;
    end
    reg [31:0]read_data_out;
    
    always @(*) begin
       if(step) begin //compressed instruction encountered
          if (^pc_current_address) begin //compressed step (multiple of 6, the current compressed instruction is in upper half word)
             Instruction_out_reg = mem[pc_current_address >> 2][32-1:16];
          end
          else begin  //regular step (multiple of 4, the current compressed instruction is in lower half word)
             Instruction_out_reg = mem[pc_current_address >> 2][16-1:0];
          end
       end
       else begin 
          Instruction_out_reg = mem[pc_current_address >> 2];
       end
    end
    
    assign Instruction_out = Instruction_out_reg;
    
    ////////
    integer i; 
    always @(*) begin : MEM_READ_COMBINATIONAL 
          case(mem_read)  
             3'b000: read_data_out = read_data_out;                                                    //OFF
             3'b001: read_data_out = mem[(r[8-1:0] >> 2) + 64];                                               //LW
             3'b010: read_data_out = { {16{{mem[(r[8-1:0] >> 2) +64][15]}}}, mem[(r[8-1:0] >> 2) +64][15:0]};      //LH
             3'b011: read_data_out = { 16'd0, mem[(r[8-1:0] >> 2) +64][15:0]};                               //LHU 
             3'b100: read_data_out = { {24{{mem[(r[8-1:0] >> 2) +64][7]}}} , mem[(r[8-1:0] >> 2)+64][7:0]};       //LB 
             3'b101: read_data_out = { 24'd0 , mem[r[8-1:0] >> 2][7:0]+64};                               //LBU
          
             default : read_data_out = read_data_out;
          endcase
        end
    
        always @(negedge clk) begin : MEM_WRITE_SEQ 
          case(mem_write) 
            2'b00 : mem[(r[8-1:0] >> 2) +64] <= mem[(r[8-1:0] >> 2) +64]; 
            2'b01 : mem[(r[8-1:0] >> 2) +64] <= rs2; //SW
            2'b10 : mem[(r[8-1:0] >> 2) +64] <= {mem[(r[8-1:0] >> 2) +64][32-1:16] , rs2[15:0]}; //SH
            2'b11 : mem[(r[8-1:0] >> 2) +64] <= {mem[(r[8-1:0] >> 2) +64][32-1:8] , rs2[7:0]};   //SB
          endcase
        end
        assign Instruction_out = Instruction_out_reg;
endmodule

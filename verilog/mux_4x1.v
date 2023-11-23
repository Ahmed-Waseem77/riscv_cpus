
/* 
    RiscV32IMC Pipelined Processor 
    Copyright (C) 2023 Ahmed Waseem, Ahmed ElBarbary

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

*/ 

`timescale 1ns/10ps
module mux_4x1 #(parameter N = 32)(  input   [N-1:0] A_00, B_01, C_10, D_11,  
                                     input   [1:0]   sel,
                                     output  [N-1:0] sel_out);


assign sel_out = sel[1]   ? (sel[0] ? D_11 : C_10) : 
                            (sel[0] ? B_01 : A_00) ;


endmodule

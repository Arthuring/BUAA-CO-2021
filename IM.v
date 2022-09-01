`timescale 1ns / 1ps
`include "macro.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:54:02 11/11/2021 
// Design Name: 
// Module Name:    IM 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module IM(
    input [31:0] I,
    output [31:0] RD
    );

		reg [31: 0] IMm [0 : `IM_SIZE - 1 ];
		integer i;
		initial begin
			for (i = 0; i < `IM_SIZE; i = i + 1)begin
				IMm[i] = 32'b0;
			end
			$readmemh("code.txt",IMm);
		end
		assign RD = IMm[I[13:2]-12'hc00];
endmodule

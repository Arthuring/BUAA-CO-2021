`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:26:09 11/20/2021 
// Design Name: 
// Module Name:    CMP 
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
module CMP(
    input [31:0] CMP_RS,
    input [31:0] CMP_RT,
    output reg b_jump
    );
	 
	always@(*)begin
		if (CMP_RS == CMP_RT)begin
			b_jump = 1;
		end
		else begin
			b_jump = 0;
		end
	end

endmodule

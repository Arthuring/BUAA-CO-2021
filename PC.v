`timescale 1ns / 1ps
`include "macro.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:41:12 11/11/2021 
// Design Name: 
// Module Name:    PC 
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
module PC(
	input clk,
	input reset,
    input [31:0] DI,
    output [31:0] DO
    );

	reg [31:0] pc;
	initial begin
		pc = `PC_INI;
	end
	
	always @(posedge clk)begin
		if(reset == 1)begin
			pc <= `PC_INI;
		end
		else begin
			pc <= DI;
		end
	end
	assign DO = pc;
	
endmodule

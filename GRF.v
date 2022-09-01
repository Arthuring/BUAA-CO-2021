`timescale 1ns / 1ps
`include "macro.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:28:00 11/11/2021 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
    input clk,
    input reset,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input WE,
    input [31:0] WD,
	 input [31:0] PC,
    output [31:0] RD1,
    output [31:0] RD2
    );
	reg [31:0] GRFreg [31:1];
	integer i;
	initial begin
		for(i = 1; i < 32; i = i + 1)begin
			GRFreg[i] = 32'b0;
		end
	end
	
	always @(posedge clk) begin
		if(reset == 1)begin
			for(i = 1;i < 32; i = i+1)begin
				GRFreg[i] <= 32'b0;
			end
		end
		else begin
			if (WE == 1)begin
				//$display("@%h: $%d <= %h", PC, A3, WD);
				//$display("%d@%h: $%d <= %h", $time, PC, A3, WD);
				GRFreg[A3] <= WD;
			end
		end
	end
	
	assign RD1 = (A1 == 0)			? 32'b0	:
				 (A1 == A3) && WE 	? WD 	: 
				 GRFreg[A1];
	assign RD2 = (A2 == 0) 			? 32'b0 :
				 (A2 == A3) && WE	? WD	:
				  GRFreg[A2];
endmodule

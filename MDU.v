`timescale 1ns / 1ps
`include "macro.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:04:52 11/29/2021 
// Design Name: 
// Module Name:    MDU 
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
module MDU(
    input clk,
    input reset,
	input start,
    input [3:0] MDUOp,
    input [31:0] D1,
    input [31:0] D2,
	//input HIen,
	//input LOen,
    output Busy,
    output [31:0] HI_RD,
    output [31:0] LO_RD
    );
	reg [31:0] HI, LO,temp_HI,temp_LO;
	integer wait_time;
	initial begin
		HI = 32'd0;
		LO = 32'd0;
		wait_time = 0;
	end
	
	always @(posedge clk)begin
		if (reset) begin
			HI <= 32'd0;
			LO <= 32'd0;
			wait_time <= 0;
		end
		else begin
			if (start) begin
				if(MDUOp == `MULT)begin
					{temp_HI,temp_LO} <= $signed(D1) * $signed(D2); 
					wait_time <= 5;
				end
				else if (MDUOp == `MULTU)begin
					{temp_HI, temp_LO} <= D1 * D2;
					wait_time <= 5;
				end
				else if (MDUOp == `DIV)begin
					if(D2 != 0)begin
						temp_LO <= $signed(D1) / $signed(D2);
						temp_HI <= $signed(D1) % $signed(D2); 
					end
					else begin
						temp_LO <= 0;
						temp_HI <= 0;
					end
					wait_time <= 10;
				end
				else if (MDUOp == `DIVU)begin
					if(D2 != 0)begin
						temp_LO <= D1 / D2;
						temp_HI <= D1 % D2; 
					end
					else begin
						temp_LO <= 32'd0;
						temp_HI <= 32'd0;
					end
					wait_time <= 10;
				end
			end
			if (wait_time == 0)begin
				if (  MDUOp == `MTHI) begin
					HI <= D1;
				end
				else if ( MDUOp == `MTLO)begin
					LO <= D1;
				end
			end
			else if (wait_time == 1)begin
				wait_time <= 0;
				HI <= temp_HI;
				LO <= temp_LO;
			end
			else begin
				wait_time <= wait_time - 1;
			end
		end
	end
	
	assign  Busy = (wait_time > 0 ) ? 1 : 0;
	assign  HI_RD = (MDUOp == `MFHI) ? HI : 0;
	assign  LO_RD = (MDUOp == `MFLO) ? LO : 0;
	

endmodule

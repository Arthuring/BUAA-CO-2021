`timescale 1ns / 1ps
`include "macro.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:42:19 11/28/2021 
// Design Name: 
// Module Name:    BE 
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
module BE(
	input [1:0] Ad,
	input [`StType_WIDE-1:0] StType,
	input [31:0] Data,
	output reg [3:0] ByteEn,
	output reg [31:0] WrData
    );
	always @(*)begin
		if (StType == `SW)begin
			ByteEn = `Save_Word;
			WrData = Data;
		end
		else if (StType == `SH)begin
			if (Ad[1] == 0) begin
				ByteEn = `Save_Half_0;
				WrData[15:0] = Data[15:0];
				WrData[31:16] = 16'd0;
			end
			else if (Ad[1] == 1) begin
				ByteEn = `Save_Half_1;
				WrData[31:16] = Data[15:0];
				WrData[15:0] = 16'd0;
			end
			else ByteEn = 4'd0;
		end
		else if (StType == `SB )begin
			if (Ad == 2'b00) begin
				ByteEn = `Save_Byte_0;
				WrData[7:0] = Data[7:0];
				WrData[31:8] = 24'd0;
			end
			else if (Ad == 2'b01) begin
				ByteEn = `Save_Byte_1;
				WrData[15:8] = Data[7:0];
				WrData[7:0] = 8'd0;
				WrData[31:16] = 16'd0;
			end
			else if (Ad == 2'b10) begin
				ByteEn = `Save_Byte_2;
				WrData[23:16] = Data[7:0];
				WrData[15:0] = 16'd0;
				WrData[31:24] = 8'd0;
			end
			else if (Ad == 2'b11) begin
				ByteEn = `Save_Byte_3;
				WrData[31:24] = Data[7:0];
				WrData[23:0] = 24'b0;
			end
			else ByteEn = 4'd0;
		end
		else if (StType == `NOSAVE) begin
			ByteEn = `Save_No_Byte; 
		end
		else begin
			ByteEn  = `Save_No_Byte;
		end
	end
	
endmodule

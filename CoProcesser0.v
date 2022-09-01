`timescale 1ns / 1ps
`include "macro.v"
`define CP0_IM 			SR[15:10]//
`define CP0_EXL			SR[1] //0:Non-Interupting 1:Interupting 
`define CP0_IE				SR[0] //gloable Interupt Enable 1: Enable

`define CP0_BD 			Cause[31]
`define CP0_HWInt		Cause[15:10]//External Hardware Interupt 
`define CP0_ExcCode		Cause[6:2] //Exception Class


//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:15:57 12/10/2021 
// Design Name: 
// Module Name:    CoProcesser0 
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
module CoProcesser0(
	input [4:0] CP0_R_addr,
	input [4:0] CP0_W_addr,
	input BDIn,
	input [31:0] DIn,
	input [31:0] EPC_I,
	input [4:0] ExcCode,
	input [5:0] HWInt,
	input WE,
	input EXLSet,
	input EXLClr,
	input clk,
	input reset,
	
	output reg write_0x7f20,
	output IntReq,
	output [31:0] EPC_O,
	output [31:0] Dout
    );
		reg [31:0] SR;
		reg [31:0] Cause;
		reg [31:0] EPC;
		reg [31:0] PRId;
		
		//reg wirte_0x7f20;
		
		wire HWIntReq = ((|(HWInt & `CP0_IM)) & `CP0_IE & !`CP0_EXL);
		wire ExcReq = (|ExcCode) & !`CP0_EXL;
		assign IntReq = HWIntReq | ExcReq;
		
		initial begin
			SR = 0;
			Cause = 0;
			EPC = 0;
			PRId = 32'h47597565;
		end
		////////////////SR///////////////////////
		always @(posedge clk) begin
			if(reset)begin
				SR <= 32'd0;
				
			end
			else begin
				if(EXLClr) `CP0_EXL <= 1'b0;
				if(IntReq)begin
					`CP0_EXL <= 1'b1;
				end
				else if( WE && CP0_W_addr == `SR_Addr && !IntReq )begin
					SR <= DIn;
				end
			end
		end
		/////////////////Cause////////////////////
		always @(posedge clk) begin
			if (reset)begin
				Cause <= 32'd0;
			end
			else begin
				if (IntReq)begin
					`CP0_BD <= BDIn;
					`CP0_ExcCode <= (HWIntReq) ? 5'd0 : ExcCode;
					
				end
				`CP0_HWInt <= HWInt;
			end
		end
		///////////////EPC////////////////////////
		always @(posedge clk)begin
			if (reset)begin
				EPC <= 0;
			end
			else begin
				
				if (IntReq)begin
					EPC <= BDIn ? (EPC_I - 32'd4) : EPC_I;
				end
				else if(WE && CP0_W_addr == `EPC_Addr && !IntReq )begin
					EPC <= DIn;
				end
				
			end
		end
		assign EPC_O = EPC;
		////////////////////////////////////////////////
		always @(posedge clk)begin
			if(reset)begin
				write_0x7f20 <= 0;
			end
			else begin
				if( IntReq )begin
					if( HWIntReq && HWInt[2] == 1 && SR[12] == 1 )begin
						write_0x7f20 <= 1;
					end
					else begin
						write_0x7f20 <= 0;
					end
				end
				else begin
					write_0x7f20 <= 0;
				end
			end
		end
		////////////////////////////////////////////////////
		assign Dout =  (CP0_R_addr == `SR_Addr) 	 ? SR 	:
							(CP0_R_addr == `Cause_Addr) ? Cause :
							(CP0_R_addr == `EPC_Addr)	 ? EPC	:
							32'd0;
 
endmodule

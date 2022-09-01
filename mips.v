`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:55:04 11/11/2021 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );
	  
	wire [31:0] IM_D;
	wire C_WE;
	wire C_EXTOp;
	wire [2:0] C_NPCOp;
	wire [3:0] C_ALUOp;
	wire C_DMWr;
	wire [1:0] C_DMOp;
	wire C_IfSigned;
	wire [1:0] C_M1Sel;
	wire [1:0] C_M2Sel;
	wire [1:0] C_M3Sel;
	wire  C_M4Sel;
	//wire [31:0] D_PC;
	
	
	/*DASM Dasm(
    .pc(D_PC),
    .instr(IM_D),
    .imm_as_dec(0),
    .reg_name(1'b0),
    .asm()
	);*/
	 
	controlUnit ctrl(
		.Op(IM_D[31: 26]),
		.Func(IM_D[5:0]),
		.NPCOp(C_NPCOp),
		.WE(C_WE),
		.EXTOp(C_EXTOp),
		.ALUOp(C_ALUOp),
		.DMWr(C_DMWr),
		.DMOp(C_DMOp),
		.IfSigned(C_IfSigned),
		.M1Sel(C_M1Sel),
		.M2Sel(C_M2Sel),
		.M3Sel(C_M3Sel),
		.M4Sel(C_M4Sel)
	);
	DataPath dtpth(
		.clk(clk),
		.reset(reset),
		.NPCOp(C_NPCOp),
		.WE(C_WE),
		.EXTOp(C_EXTOp),
		.ALUOp(C_ALUOp),
		.DMWr(C_DMWr),
		.DMOp(C_DMOp),
		.IfSigned(C_IfSigned),
		.M1Sel(C_M1Sel),
		.M2Sel(C_M2Sel),
		.M3Sel(C_M3Sel),
		.M4Sel(C_M4Sel),
		.Instract(IM_D)
		//.PC(D_PC)
		
	);
endmodule

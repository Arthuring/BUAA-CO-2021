`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:33:49 11/11/2021 
// Design Name: 
// Module Name:    DataPath 
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
module DataPath(
    input clk,
    input reset,
	 
	///F///
	//output [31:0] F_instr,
	
	
	///D///
	output [31:0] D_Instr,
	
	///E///
	output [31:0] E_Instr,
	
	///M///
	output [31:0] M_Instr,
	
	///W///
	output [31:0] W_Instr,
	
    );
	//=====================FFFFFFFF=================
	
	wire [31:0] F_PC_DO;
	wire [31:0] F_Instr;
	 
	PC F_PC(
		.clk(clk),
		.reset(reset),
		.DI(),
		.DO(F_PC_DO),
		.WE()
	
	);
	
	IM F_IM(
		.I(F_PC_DO),
		.RD(F_Instr)
	);
	
	 
	//=====================FFFFFFFF=================
	
	IF_ID D_reg(
		.clk(clk),
		.reset(reset),
		.F_Instr(F_Instr),
		.F_PC4(),
		.D_Instr(),
		.D_PC4()
	);
	
	
	//=====================DDDDDDDD=================
	
	
	
	
	
	//=====================DDDDDDDD=================
	wire [31:0] PC_DO;
	wire [31:0] IM_RD;
	wire [31:0] GRF_RD1;
	wire [31:0] GRF_RD2;
	wire [31:0] EXT_Ext;
	wire [31:0] ALU_C;
	wire ALU_Zero;
	wire [31:0] DM_RD;
	wire [31:0] NPC_NPC;
	wire [31:0] NPC_PC4;
	wire [4:0] M1_O;
	wire [31:0] M2_O;
	wire [31:0] M3_O;
	wire [31:0] M4_O;
	
	/*DASM Dasm(
    .pc(PC_DO),
    .instr(IM_D),
    .imm_as_dec(0),
    .reg_name(1'b0),
    .asm()
	);*/
	 
	
	PC pc(
		.clk(clk),
		.reset(reset),
		.DI(NPC_NPC),
		.DO(PC_DO)
	);
	
	IM im(
		.I(PC_DO),
		.RD(IM_RD)
	);
	

	EXT ext(
		.Imm(IM_RD[15:0]),
		.EXTOp(EXTOp),
		.Ext(EXT_Ext)
	);

	
	NPC npc(
		.PC(PC_DO),
		.NPC(NPC_NPC),
		.NPCOp(NPCOp),
		.PC4(NPC_PC4),
		.Imm(IM_RD[25:0]),
		.RA(GRF_RD1),
		.zero(ALU_Zero)
	);
	
	GRF grf(
		.clk(clk),
		.reset(reset),
		.A1(IM_RD[25:21]),
		.A2(IM_RD[20:16]),
		.A3(M1_O),
		.WD(M2_O),
		.WE(WE),
		.RD1(GRF_RD1),
		.RD2(GRF_RD2),
		.PC(PC_DO)
	);
	
	ALU alu(
		.A(M4_O),
		.B(M3_O),
		.C(ALU_C),
		.ALUOp(ALUOp),
		.zero(ALU_Zero)
	);
	
	DM dm(
		.clk(clk),
		.reset(reset),
		.A(ALU_C),
		.WD(GRF_RD2),
		.RD(DM_RD),
		.DMWr(DMWr),
		.DMOp(DMOp),
		.IfSigned(IfSigned),
		.PC(PC_DO)
	);
	
	MUX_b2_32 M2(
		.I0(ALU_C),
		.I1(DM_RD),
		.I2(NPC_PC4),
		.I3({IM_RD[15:0],{16{1'b0}}}),
		.Op(M2Sel),
		.Out(M2_O)
	);
	
	MUX_b2_5 M1(
		.I0(IM_RD[15:11]),
		.I1(IM_RD[20:16]),
		.I2(5'h1f),
		.I3(),
		.Op(M1Sel),
		.Out(M1_O)
	);
	MUX_b2_32 M3(
		.I0(GRF_RD2),
		.I1(EXT_Ext),
		.I2(),
		.I3(),
		.Op(M3Sel),
		.Out(M3_O)
	);
	MUX_b1_32 M4(
		.I0(GRF_RD1),
		.I1({27'd0,IM_RD[10:6]}),
		.Op(M4Sel),
		.Out(M4_O)
	); 
	 
	assign Instract = IM_RD;
	//assign PC = PC_DO;
endmodule

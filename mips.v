`timescale 1ns / 1ps
`include "macro.v"
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
    input reset,
    input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata,
    output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3 :0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr
);
	///////////////////////DCLEAR===================
	//***FFF***
	wire [31:0] F_PC;
	wire [31:0] F_Instr;
	wire [31:0] F_NPC;
	wire [31:0] F_PC8;
	//***DDD***
	wire [31:0] D_Instr;
	wire [31:0] D_PC8;
	wire [31:0] D_PC;
	wire [`NPCOp_WIDE-1:0] D_NPCOp;
	//wire D_WE;
	wire [`EXTOp_WIDE-1:0] D_EXTOp;
	wire [`CMPOp_WIDE-1:0] D_CMPOp;
	wire D_b_jump;

	wire [4:0] D_rs_ad;
	wire [4:0] D_rt_ad;
	wire [31:0] D_MFRD1, D_MFRD2;
	wire [1:0] D_MFRD1Sel, D_MFRD2Sel;

	wire [31:0] D_GRF_RD1;
	wire [31:0] D_GRF_RD2;
	wire [31:0] D_EXT_EXT;

	
	//***EEE***
	wire [31:0] E_V1;
    wire [31:0] E_V2;
    wire [31:0] E_EXT;
    wire [31:0] E_PC8;
    wire [31:0] E_PC;
	wire [31:0] E_Instr;
	wire [31:0] E_MALUB_O;
	wire [31:0] E_MALUA;
	wire [`ALUOp_WIDE-1:0] E_ALUOp;
	//wire [1:0] E_MA3Sel;
	wire [`MALUASel_WIDE-1:0] E_MALUASel;
	wire [`MALUBSel_WIDE-1:0] E_MALUBSel;
	
	wire [31:0] E_MFRD1,E_MFRD2;
	wire [1:0] E_MFRD1Sel, E_MFRD2Sel;

	wire [31:0] E_MGRFWD;
	wire [1:0] E_MGRFWDSel; 

	wire [31:0] E_ALU_C;
	wire [4:0] E_MA3_O;
	wire E_MHILOSel;
	wire E_busy;
	wire E_b_jump;
	wire E_Ecndtn;
	
	//***MMM***
	wire [31:0] M_C;
    wire [31:0] M_V2;
    wire [31:0] M_PC;
    wire [31:0] M_PC8;
	wire [31:0] M_EXT;
    wire [4:0] M_A3;
    wire [31:0] M_Instr;
	wire [`DMOp_WIDE-1:0] M_DMOp;
	wire M_DMWr;
	wire [31:0] M_DM_RD;
	wire [2:0] M_MGRFWDSel;
	wire [31:0] M_MGRFWD;

	wire [31:0] M_MFV2;
	wire [1:0] M_MFV2Sel;
	wire M_b_jump;
	wire M_Mcndtn;
	wire M_Ecndtn;
	//***WWW***
	wire [31:0] W_C;
	wire [31:0] W_EXT;
    wire [31:0] W_DR;
    wire [31:0] W_PC;
    wire [31:0] W_PC8;
    wire [4:0] W_A3;
    wire [31:0] W_Instr;
	//wire [4:0] W_MA3;
	wire W_Mcndtn;
	wire W_Ecndtn;
	wire [31:0] W_MGRFWD_O;
	//wire W_WE;
	wire [`MGRFWDSel_WIDE-1:0] W_MGRFWDSel;
	wire W_b_jump;
	//wire [1:0] W_MA3Sel;
	/////////////////ForwardControl///////////////////////////
	ForwardControl FC(
		.D_Instr(D_Instr),
    	.E_Instr(E_Instr),
    	.M_Instr(M_Instr),
    	.W_Instr(W_Instr),
		
		.E_b_jump(E_b_jump),
		.M_b_jump(M_b_jump),
		.W_b_jump(W_b_jump),
		
		.E_Ecndtn(E_Ecndtn),
		.M_Ecndtn(M_Ecndtn),
		.W_Ecndtn(W_Ecndtn),
		
		.W_Mcndtn(W_Mcndtn),

    	.D_MFRD1Sel(D_MFRD1Sel),
    	.D_MFRD2Sel(D_MFRD2Sel),
    	.E_MFRD1Sel(E_MFRD1Sel),
    	.E_MFRD2Sel(E_MFRD2Sel),
    	.M_MFV2Sel(M_MFV2Sel)

	);
	/////////////////StallControl///////////////////////////
	wire stall;
	wire F_PC_WE, D_reg_WE, E_reg_reset;
	
	StallControl SC(
		.D_Instr(D_Instr),
		.E_Instr(E_Instr),
		.M_Instr(M_Instr),
		.W_Instr(W_Instr),
		.E_b_jump(E_b_jump),
		.M_b_jump(M_b_jump),
		.W_b_jump(W_b_jump),
		
		.E_Ecndtn(E_Ecndtn),
		.M_Ecndtn(M_Ecndtn),
		.W_Ecndtn(W_Ecndtn),
		
		.W_Mcndtn(W_Mcndtn),
		
		.Busy(E_busy),
		.stall(stall)
	);
	assign F_PC_WE = (stall == 0 ) ? 1 : 0;
	assign D_reg_WE = (stall == 0) ? 1 : 0;
	assign E_reg_reset = (stall == 0) ? 0 : 1;
	
	/////////////////To IM & DM////////////////////////////
	assign i_inst_addr = F_PC;
	assign F_Instr =  i_inst_rdata ;
	
	assign m_data_addr = M_C;
	assign m_inst_addr = M_PC;
   assign w_grf_we = 1;
   assign w_grf_addr = W_A3;
   assign w_grf_wdata = W_MGRFWD_O;
   assign w_inst_addr = W_PC;
	/////////////////DataPath&Control//////////////////////
	
//=====================FFFFFFFF=================================================================================
	
	
	PC F_pc(
		.clk(clk),
		.reset(reset),
		.DI(F_NPC),
		.DO(F_PC),
		.WE(F_PC_WE)
	
	);
	
//=====================FFFFFFFF===================================================================================
	
//=====================DDDDDDDD=====================================================================================
	
	

	NPC F_npc(
		.F_PC(F_PC),
		.D_PC(D_PC),
		.NPC(F_NPC),
		.Imm(D_Instr[25:0]),
		.PC8(F_PC8),
		.NPCOp(D_NPCOp),
		.b_jump(D_b_jump),
		.RA(D_MFRD1)
	);

	IF_ID D_reg(
		.clk(clk),
		.reset(reset),
		.F_Instr(F_Instr),
		.F_PC(F_PC),
		.F_PC8(F_PC8),
		.D_Instr(D_Instr),
		.D_PC8(D_PC8),
		.D_PC(D_PC),
		.WE(D_reg_WE),
		.likely(1'b0)
	);
	
	 
	
	
	CU D_CU(
		.Instr(D_Instr),
		//.WE(D_WE),
		.NPCOp(D_NPCOp),
		.EXTOp(D_EXTOp),
		.CMPOp(D_CMPOp)

	);
	
	GRF D_GRF(
		.clk(clk),
		.reset(reset),
		.A1(D_Instr[25:21]),
		.A2(D_Instr[20:16]),
		.A3(W_A3),
		.WD(W_MGRFWD_O),
		.WE(1'b1),
		.RD1(D_GRF_RD1),
		.RD2(D_GRF_RD2),
		.PC(W_PC)
	);

	CMP D_CMP(
		.CMP_RS(D_MFRD1),//**Forward
		.CMP_RT(D_MFRD2),//**Forward
		.b_jump(D_b_jump),
		.CMPOp(D_CMPOp)

	);
	EXT D_EXT(
		.Imm(D_Instr[15:0]),
		.EXTOp(D_EXTOp),
		.Ext(D_EXT_EXT)
	);

	//---Forward_to_D----
	assign D_MFRD1 = (D_MFRD1Sel == `E_TO_D )? E_MGRFWD :
					 (D_MFRD1Sel == `M_TO_D )? M_MGRFWD  :
					 D_GRF_RD1;	

	assign D_MFRD2 = (D_MFRD2Sel == `E_TO_D )? E_MGRFWD :
					 (D_MFRD2Sel == `M_TO_D )? M_MGRFWD  :
					 D_GRF_RD2;
	//=====================DDDDDDDD=====================================================================================
	
	
	//=====================EEEEEEEE=====================================================================================
	wire [31:0] E_MHILO;
	wire E_start;

	wire [3:0] E_MDUOp;
	wire [31:0] E_HI_RD;
	wire [31:0] E_LO_RD;

	ID_EX E_reg(
		.clk(clk),
		.reset(reset | E_reg_reset),
		.D_V1(D_MFRD1),//**Forward
   	 	.D_V2(D_MFRD2),//**Forward
    	.D_EXT(D_EXT_EXT),
    	.D_PC8(D_PC8),
    	.D_PC(D_PC),
		.D_Instr(D_Instr),
		.D_b_jump(D_b_jump),
	 
    	.E_V1(E_V1),
    	.E_V2(E_V2),
    	.E_EXT(E_EXT),
    	.E_PC8(E_PC8),
    	.E_PC(E_PC),
		.E_Instr(E_Instr),
		.E_b_jump(E_b_jump)
	);


	CU E_CU(
		.Instr(E_Instr),
		.ALUOp(E_ALUOp),
		.MALUASel(E_MALUASel),
		.MALUBSel(E_MALUBSel),
		//.MA3Sel(E_MA3Sel),
		.E_MGRFWDSel(E_MGRFWDSel),
		.start(E_start),
		.MHILOSel(E_MHILOSel),
		.MDUOp(E_MDUOp)
	);
	assign E_MALUA = (E_MALUASel == `MALUA_SHALT) ? {27'd0,E_Instr[10:6]} :
						  E_MFRD1;
	
	MUX_b2_32 E_MALUB(
		.I0(E_MFRD2),//**Forward
		.I1(E_EXT),
		.Op(E_MALUBSel),
		.Out(E_MALUB_O)
	);
	
	
	
	ALU E_ALU(
		.ALUOp(E_ALUOp),
		.A(E_MALUA),//**Forward
		.B(E_MALUB_O),//**Forward
		.C(E_ALU_C)
	);

	MDU E_MDU(
		.clk(clk),
		.reset(reset),
		.start(E_start),
		.MDUOp(E_MDUOp),
		.D1(E_MFRD1),
		.D2(E_MFRD2),
		.Busy(E_busy),
		.HI_RD(E_HI_RD),
		.LO_RD(E_LO_RD)

	);

	assign E_MHILO = (E_MHILOSel == `HI) ? E_HI_RD :
					 (E_MHILOSel == `LO) ? E_LO_RD :
					 0;
	/*MUX_b2_5 E_MA3(
		.I0(E_Instr[15:11]),
		.I1(E_Instr[20:16]),
		.I2(5'd31),
		.Op(E_MA3Sel),
		.Out(E_MA3_O)
	);*/
	//***Forward_by_E***
	assign E_MGRFWD = (E_MGRFWDSel == `E_PC8) ? E_PC + 32'd8 :
					  (E_MGRFWDSel == `E_EXT) ? E_EXT :
					  0;
	//***Forward_to_E***
	assign E_MFRD1 = (E_MFRD1Sel == `M_TO_E) ? M_MGRFWD :
					 (E_MFRD1Sel == `W_TO_E) ? W_MGRFWD_O :
					 E_V1;
	assign E_MFRD2 = (E_MFRD2Sel == `M_TO_E) ? M_MGRFWD	:
					 (E_MFRD2Sel == `W_TO_E) ? W_MGRFWD_O :
					 E_V2;
	//=====================EEEEEEEE=====================================================================================
	
	
	//=====================MMMMMMMM=====================================================================================
	wire [31:0] M_HILO;
	wire [`StType_WIDE-1:0] M_StType;
	wire [2:0] M_LdType;
	EX_MEM M_reg(
		.clk(clk),
		.reset(reset),
		.E_C(E_ALU_C),
		.E_V2(E_MFRD2),
		.E_PC(E_PC),
		.E_PC8(E_PC8),
		//.E_A3(E_MA3_O),
		.E_EXT(E_EXT),
		.E_Instr(E_Instr),
		.E_HILO(E_MHILO),
		.E_b_jump(E_b_jump),
		.E_Ecndtn(E_Ecndtn),

		.M_C(M_C),
		.M_V2(M_V2),
		.M_PC(M_PC),
		.M_PC8(M_PC8),
		//.M_A3(M_A3),
		.M_EXT(M_EXT),
		.M_Instr(M_Instr),
		.M_HILO(M_HILO),
		.M_b_jump(M_b_jump),
		.M_Ecndtn(M_Ecndtn)
	);
	

	
	CU M_CU(
		.Instr(M_Instr),
		.DMWr(M_DMWr),
		.DMOp(M_DMOp),
		.M_MGRFWDSel(M_MGRFWDSel),
		.StType(M_StType),
		.LdType(M_LdType),
		.Ecndtn(M_Ecndtn)
	);
	
	/*DM M_DM(
		.clk(clk),
		.reset(reset),
		.PC(M_PC),
		.A(M_C),
		.WD(M_MFV2),//forward
		.DMWr(M_DMWr),
		.DMOp(M_DMOp),
		.RD(M_DM_RD)
	);*/
	BE M_BE(
		.Ad(M_C[1:0]),
		.StType(M_StType),
		.Data(M_MFV2),
		.ByteEn(m_data_byteen),
		.WrData(m_data_wdata)
	);

	DBS M_DBS(
		.Ad(M_C[1:0]),
		.LdType(M_LdType),
		.RdData(m_data_rdata),
		.Data(M_DM_RD)
	);
	//***forward_by_M***
	assign M_MGRFWD = (M_MGRFWDSel == `M_C ) ? M_C :
					  (M_MGRFWDSel == `M_PC8 ) ? M_PC + 32'd8 :
					  (M_MGRFWDSel == `M_EXT) ? M_EXT :
					  (M_MGRFWDSel == `M_HILO) ? M_HILO :
					  0;
 
	//***forward_to_M***
	assign M_MFV2 = (M_MFV2Sel == `W_TO_M) ? W_MGRFWD_O :
					M_V2; 
	//=====================MMMMMMMM=====================================================================================
	
	
	//=====================WWWWWWWW=====================================================================================
	wire [31:0] W_HILO;
	MEM_WB W_reg(
		.clk(clk),
		.reset(reset),
    	.M_C(M_C),
    	.M_DR(M_DM_RD),
    	.M_PC(M_PC),
		.M_EXT(M_EXT),
    	.M_PC8(M_PC8),
    	//.M_A3(M_A3),
    	.M_Instr(M_Instr),	
	 	.M_HILO(M_HILO),
		.M_b_jump(M_b_jump),
		.M_Mcndtn(M_Mcndtn),
		.M_Ecndtn(M_Ecndtn),
		
    	.W_C(W_C),
    	.W_DR(W_DR),
    	.W_PC(W_PC),
		.W_EXT(W_EXT),
    	.W_PC8(W_PC8),
    	//.W_A3(W_A3),
    	.W_Instr(W_Instr),
		.W_HILO(W_HILO),
		.W_b_jump(W_b_jump),
		.W_Mcndtn(W_Mcndtn),
		.W_Ecndtn(W_Ecndtn)
	);

	CU W_CU(
		.Instr(W_Instr),
		//.WE(W_WE),
		.W_MGRFWDSel(W_MGRFWDSel),
		//.MA3Sel(W_MA3Sel)
		.write_reg(W_A3),
		.b_jump(W_b_jump),
		.Mcndtn(W_Mcndtn),
		.Ecndtn(W_Ecntdn)
	);
	
	/*MUX_b2_32 W_MGRFWD(
		.I0(W_C),
		.I1(W_DR),
		.I2(W_PC + 32'd8),
		.I3(W_EXT),
		.Op(W_MGRFWDSel),
		.Out(W_MGRFWD_O)
	);*/
	
	assign W_MGRFWD_O = (W_MGRFWDSel == `MGRFWDALU) ? W_C :
						(W_MGRFWDSel == `MGRFWDNPC) ? W_PC + 32'd8 :
						(W_MGRFWDSel == `MGRFWDDW) 	? W_DR	:
						(W_MGRFWDSel == `MGRFWDLui) ? W_EXT	:
						(W_MGRFWDSel == `MGRFWDHILO)? W_HILO:
						W_C;
	/*assign W_MA3 = (W_MA3Sel == `MA3Rd ) ? W_Instr[15:11] :
					   (W_MA3Sel == `MA3Rt)  ? W_Instr[20:16] :
						(W_MA3Sel == `MA3R31) ? 5'd31:
						5'd0;*/

	//=====================WWWWWWWW=====================================================================================

endmodule

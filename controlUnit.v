`timescale 1ns / 1ps
`include "macro.v"

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:59:47 11/11/2021 
// Design Name: 
// Module Name:    controlUnit 
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
module CU(
    //input [5:0] Op,
   // input [5:0] Func,
	 input [31:0] Instr,
	 input check,
	 //input Zero,
	 
	 //divide
	 output [4:0] rs_ad,
	 output [4:0] rt_ad,
	 output [4:0] rd_ad,
	 output [4:0] write_reg,
	 output [15:0] imm,
	 output [25:0] j_addr,
	 //class
	 output load,
	 output store,
	 output calc_r,
	 output calc_i,
	 output branch,
	 output jump,
	 output j_r,
	 output j_al,
	 output Lui,
	 output lh_so,
	 //control
	 output [`NPCOp_WIDE-1:0] NPCOp,
	 //output WE,
	 output [`EXTOp_WIDE-1:0] EXTOp,

	 output [`ALUOp_WIDE-1:0] ALUOp,
	 output [1:0] E_MGRFWDSel,

	 output DMWr,
	 output [`DMOp_WIDE-1:0] DMOp,
	 output IfSigned,
	 output [1:0] M_MGRFWDSel,
	 
	 //output [1:0] MA3Sel,
	 output [`MGRFWDSel_WIDE-1:0] W_MGRFWDSel,
	 output [`MALUBSel_WIDE-1:0] MALUBSel,
	 output [`MALUASel_WIDE-1:0] MALUASel
    );
	 
	 //divide
	wire [5:0] Op = Instr[31:26];
	wire [5:0] Func = Instr[5:0];
	assign rs_ad = Instr[25:21];
	assign rt_ad = Instr[20:16];
	assign rd_ad = Instr[15:11];
	assign imm = Instr[15:0];
	assign j_addr = Instr[25:0];

	 //decode
	wire addu	= (Op == 6'b000000) && (Func == 6'b100001);
	wire subu	= (Op == 6'b000000) && (Func == 6'b100011);
	wire ori		= (Op == 6'b001101);
	wire lw		= (Op == 6'b100011);
	wire sw		= (Op == 6'b101011);
	wire beq		= (Op == 6'b000100);
	wire jal		= (Op == 6'b000011);
	wire jr		= (Op == 6'b000000) && (Func == 6'b001000);
	wire slt		= (Op == 6'b000000) && (Func == 6'b101010);
	wire lui		= (Op == 6'b001111);
	wire lb		= (Op == 6'b100000);
	wire sb		= (Op == 6'b101000);
	wire lh		= (Op == 6'b100001);
	wire sh		= (Op == 6'b101001);
	wire sll		= (Op == 6'b000000) && (Func == 6'b000000);
	wire sllv	= (Op == 6'b000000) && (Func == 6'b000100);
	wire sltu	= (Op == 6'b000000) && (Func == 6'b101011);
	wire j		= (Op == 6'b000010);
	wire lhso 	= (Op == 6'b100111);
	
	//class
	assign load = ( lw | lb | lh );
	assign calc_r = ( addu | subu | sll | sllv | slt | sltu );
	assign calc_i = ( ori | lui );
	assign store  = ( sw | sh | sb );
	assign branch = ( beq );
	assign jump = ( jal | j );
	assign j_r = ( jr );
	assign Lui = (lui);
	assign j_al = (jal);
	assign lh_so = lhso;
	//control Info

	assign NPCOp	=	beq	? `BEQ:
							j		? `J	:
							jal	? `J	:
							jr		? `JR	:
							`PC4;
							
							
	//assign WE = calc_r | calc_i | jal | load ; 
	
	assign write_reg = (lhso) ? (check === 1'b0 ? 5'd31 : rt_ad):
							 ( calc_r ) 			? rd_ad :
							 ( calc_i | load )	? rt_ad :
							 (jal)			 		? 5'd31 :
							 5'd0;		 

	assign EXTOp 	=	ori	? `ZERO		:
							lw		? `SIGNED	:
							sw		? `SIGNED	:
							lb		? `SIGNED	:
							sb		? `SIGNED	:
							lh		? `SIGNED	:
							sh		? `SIGNED	:
							lui	? `EXT_LUI	:
							lhso	? `SIGNED	:
							2'b00;
							
	assign ALUOp	=	addu	? `ADD		:
							subu	? `SUB		:
							ori	? `OR			:
							lw		? `ADD		:
							sw		? `ADD		:
							slt	? `SLT		:
							lb		? `ADD		:
							sb		? `ADD		:
							lh		? `ADD		:
							sh		? `ADD		:
							sll	? `SLL		:
							sllv	? `SLL		:
							sltu	? `SLTU		:
							beq	? `SUB		:
							lhso	? `ADD		:
							4'd0;
		
	assign DMWr = sw | sb | sh ;
	assign DMOp 	=	( lw | sw )	? `WORD	:
							( lh | sh | lhso  )	? `HALF	:
							( lb | sb ) ? `BITE	:
							3'b000;
	assign IfSigned = ( lh | lb | lhso ) ? 1: 0;
	/*assign MA3Sel	= 	( addu | subu | slt | sll | sllv | sltu ) ? `MA3Rd :
							(ori | lw | lui | lb | lh  ) ? `MA3Rt	:
							(jal) ? `MA3R31 :
							2'b00;*/
	assign W_MGRFWDSel	= (lhso) ? (check == 1'b1 ? `MGRFWDLHSO : `MGRFWDNPC):
							( lw | lb |lh ) ? `MGRFWDDW :
							(jal) ? `MGRFWDNPC :
							(lui) ? `MGRFWDLui:
							`MGRFWDALU;
	assign MALUBSel	= ( ori | lw | sw | lb | sb | lh | sh | lhso ) ? `MALUBEXT:
							2'b00;
	assign MALUASel = (sll) ? `MALUA_SHALT :
							2'b00;
	assign M_MGRFWDSel = ( jal ) ? `M_PC8 :
						 (lui) ? `M_EXT :
						 `M_C;

	assign E_MGRFWDSel = (jal) ? `E_PC8 :
						(lui) ? `E_EXT :
						`E_NO_GEN;
	
endmodule

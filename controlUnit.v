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
	 //input Zero,
	 input b_jump,
	 input Mcndtn,
	 input Ecndtn,
	 //----------------------divide-------------------
	 output [4:0] rs_ad,
	 output [4:0] rt_ad,
	 output [4:0] rd_ad,
	 output [4:0] write_reg,
	 output [15:0] imm,
	 output [25:0] j_addr,
	 //--------------------class--------------------
	 output load,
	 output store,
	 output calc_r,
	 output calc_i,
	 output branch,
	 output branch_rs,
	 output branch_rt,
	 output jump,
	 output j_r,
	 output j_al,
	 output Lui,
	 output Shift,
	 output ShiftV,
	 output md,
	 output mt,
	 output mf,
	 //------------------control-----------------------
	 output [`NPCOp_WIDE-1:0] NPCOp,
	 //output WE,
	 output [`EXTOp_WIDE-1:0] EXTOp,
	 output [`CMPOp_WIDE-1:0] CMPOp, 
	 output [`ALUOp_WIDE-1:0] ALUOp,
	 output [1:0] E_MGRFWDSel,

	 output DMWr,
	 output [`DMOp_WIDE-1:0] DMOp,
	 output IfSigned,
	 output [2:0] M_MGRFWDSel,
	 
	 //output [1:0] MA3Sel,
	 output [`MGRFWDSel_WIDE-1:0] W_MGRFWDSel,
	 output [`MALUBSel_WIDE-1:0] MALUBSel,
	 output [`MALUASel_WIDE-1:0] MALUASel,
	 output [`StType_WIDE-1:0] StType,
	 output [2:0] LdType,
	 output start,
	 output HIen,
	 output LOen,
	 //output start,
	 output MHILOSel,
	 output [3:0] MDUOp
	
    );
	 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	 
	 ///////////////////////divide////////////////////////////////////////////////////////////////////////////////
	 
	wire [5:0] Op = Instr[31:26];
	wire [5:0] Func = Instr[5:0];
	assign rs_ad = Instr[25:21];
	assign rt_ad = Instr[20:16];
	assign rd_ad = Instr[15:11];
	assign imm = Instr[15:0];
	assign j_addr = Instr[25:0];

	////////////////////decode//////////////////////////////////////////////////////////////////////////////////
	
	 ///------calc_r------------------------------------------
	wire addu	= (Op == 6'b000000) && (Func == 6'b100001);
	wire subu	= (Op == 6'b000000) && (Func == 6'b100011);
	wire add		= (Op == 6'b000000) && (Func == 6'b100000);
	wire sub		= (Op == 6'b000000) && (Func == 6'b100010);
	wire sllv	= (Op == 6'b000000) && (Func == 6'b000100);
	wire srlv	= (Op == 6'b000000) && (Func == 6'b000110);
	wire srav	= (Op == 6'b000000) && (Func == 6'b000111);
	wire _and	= (Op == 6'b000000) && (Func == 6'b100100);
	wire _or		= (Op == 6'b000000) && (Func == 6'b100101);
	wire _xor	= (Op == 6'b000000) && (Func == 6'b100110);
	wire _nor	= (Op == 6'b000000) && (Func == 6'b100111);
	wire slt		= (Op == 6'b000000) && (Func == 6'b101010);
	wire sltu	= (Op == 6'b000000) && (Func == 6'b101011);
	
	wire sll		= (Op == 6'b000000) && (Func == 6'b000000);
	wire srl		= (Op == 6'b000000) && (Func == 6'b000010);
	wire sra		= (Op == 6'b000000) && (Func == 6'b000011);
	///------calc_i-------------------------------------------
	wire ori		= (Op == 6'b001101);
	wire lui		= (Op == 6'b001111);
	wire addi	= (Op == 6'b001000);
	wire addiu	= (Op == 6'b001001);
	wire andi	= (Op == 6'b001100);
	wire xori	= (Op == 6'b001110);
	wire slti	= (Op == 6'b001010);
	wire sltiu	= (Op == 6'b001011);
	///------st & ld-----------------------------------------
	wire lw		= (Op == 6'b100011);
	wire sw		= (Op == 6'b101011);
	wire lb		= (Op == 6'b100000);
	wire sb		= (Op == 6'b101000);
	wire lh		= (Op == 6'b100001);
	wire sh		= (Op == 6'b101001);
	wire lbu		= (Op == 6'b100100);
	wire lhu		= (Op == 6'b100101);
	///----------branch-------------------------------------
	wire beq		= (Op == 6'b000100);
	wire bne		= (Op == 6'b000101); 
	wire blez	= (Op == 6'b000110);
	wire bgtz	= (Op == 6'b000111);
	wire bltz	= (Op == 6'b000001) && (rt_ad == 5'b00000);
	wire bgez	= (Op == 6'b000001) && (rt_ad == 5'b00001);
	///-------------jump----------------------------------
	wire jal		= (Op == 6'b000011);
	wire jr		= (Op == 6'b000000) && (Func == 6'b001000);
	wire j		= (Op == 6'b000010);
	wire jalr 	= (Op == 6'b000000) && (Func == 6'b001001);
	///---------mdu------------------------------------------
	wire mult 	= (Op == 6'b000000) && (Func == 6'b011000);
	wire multu	= (Op == 6'b000000) && (Func == 6'b011001);
	wire div 	= (Op == 6'b000000) && (Func == 6'b011010);
	wire divu 	= (Op == 6'b000000) && (Func == 6'b011011);
	wire mthi 	= (Op == 6'b000000) && (Func == 6'b010001);
	wire mtlo	= (Op == 6'b000000) && (Func == 6'b010011);
	wire mfhi 	= (Op == 6'b000000) && (Func == 6'b010000);
	wire mflo 	= (Op == 6'b000000) && (Func == 6'b010010);
	
	////////////////////////////class//////////////////////////////////////////////////////////////////////////////////////////
	
	assign load = ( lw | lb | lh | lhu | lbu );
	assign calc_r = ( addu | subu |add | sub | sllv | srlv | srav | slt | sltu | _and | _or | _xor | _nor | sll  | srl | sra );
	assign calc_i = ( ori | lui | addi | addiu | andi | xori | slti | sltiu);
	assign store  = ( sw | sh | sb );
	assign branch = ( beq | bne | blez | bgtz | bltz | bgez );
	assign jump = ( jal | j );
	assign j_r = ( jr | jalr );
	assign Lui = (lui);
	assign j_al = ( jal | jalr );
	assign Shift = ( sll | srl | sra );
	assign md = ( mult | multu | div | divu);
	assign mt = (mthi | mtlo);
	assign mf = (mfhi | mflo);
	assign branch_rs = ( blez | bgtz | bltz | bgez );
	assign branch_rt = ( beq | bne );
	
	////////////////////////////control Info///////////////////////////////////////////////////////////////////////////////////////

	assign NPCOp	=	branch	? `BRNCH:
						jump	? `J	:
						j_r		? `JR	:
						`PC4;
							
							
	
	
	assign write_reg =		 ( calc_r | mf | jalr )	? rd_ad :
							 ( calc_i | load )	? rt_ad :
							 (jal)		?  5'd31 :
							 5'd0;		 

	assign EXTOp 	=	(ori | andi | xori )? `ZERO		:
							(load | store | slti | addi | addiu | sltiu ) ? `SIGNED :
							lui	? `EXT_LUI	:
							2'b00;
							
	assign CMPOp	=	beq		? `Eql 			:
						bne 	? `NEql			:
						blez	? `LesEqlZero	:
						bgtz	? `GrtZero		:
						bltz	? `LesZero		:
						bgez	? `GrtEqlZero	:
						0;					
	assign ALUOp	=		(_and | andi)	? `AND :
							(ori |_or ) 	? `OR	:
							(addu | add | addi | addiu)	? `ADD :
							(load | store) 	? `ADD :
							(subu | sub)	? `SUB :
							(slt |slti )	? `SLT :
							(sll | sllv)	? `SLL :
							(sltu | sltiu) 	? `SLTU	:
							(_xor | xori )	? `XOR :
							(_nor ) 		? `NOR :
							(srl | srlv) 	? `SRL :
							(sra | srav) 	? `SRA :
							4'd0;
		
	//assign DMWr = sw | sb | sh ;
	/*assign DMOp 	=	( lw | sw )	? `WORD	:
							( lh | sh )	? `HALF	:
							( lb | sb ) ? `BITE	:
							3'b000;*/
	assign IfSigned = ( lh | lb ) ? 1: 0;
	/*assign MA3Sel	= 	( addu | subu | slt | sll | sllv | sltu ) ? `MA3Rd :
							(ori | lw | lui | lb | lh  ) ? `MA3Rt	:
							(jal) ? `MA3R31 :
							2'b00;*/
	assign W_MGRFWDSel	= ( load ) ? `MGRFWDDW :
							(j_al) ? `MGRFWDNPC :
							(lui) ? `MGRFWDLui:
							(mf)  ? `MGRFWDHILO: 
							`MGRFWDALU;
	assign MALUBSel	= ( calc_i | load | store ) ? `MALUBEXT:
							2'b00;
	assign MALUASel = ( Shift ) ? `MALUA_SHALT :
							2'b00;
	assign M_MGRFWDSel = ( j_al ) ? `M_PC8 :
						 (lui) ? `M_EXT :
						 (mf) ? `M_HILO :
						 `M_C;

	assign E_MGRFWDSel = (j_al) ? `E_PC8 :
						(lui) ? `E_EXT :
						0;
	assign StType = (sw) ? `SW :
						 (sh) ? `SH :
						 (sb) ? `SB :
						 `NOSAVE;
	assign LdType = (lw) ? `NO_EXT :
					(lh) ? `SIGN_H_EXT :
					(lb) ? `SIGN_B_EXT :
					(lhu) ? `UNSIGN_H_EXT :
					(lbu) ? `UNSIGN_B_EXT :
					0;
	assign MDUOp = 	(mult) 	? `MULT 	:
				   	(multu) ? `MULTU	:
					(div)	? `DIV		:
					(divu)	? `DIVU     :
					(mfhi)  ? `MFHI		:
					(mflo)  ? `MFLO		:
					(mthi)	? `MTHI 	:
					(mtlo) 	? `MTLO		:
					0;	
	assign start = (md) ? 1'b1 : 1'b0;
	assign MHILOSel = (mflo) ? `LO :
					 (mfhi) ? `HI :
					 0;

endmodule

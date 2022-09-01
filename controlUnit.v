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
module controlUnit(
    input [5:0] Op,
    input [5:0] Func,
	 output [2:0] NPCOp,
	 output WE,
	 output EXTOp,
	 output [3:0] ALUOp,
	 output DMWr,
	 output [1:0] DMOp,
	 output IfSigned,
	 output [1:0] M1Sel,
	 output [1:0] M2Sel,
	 output [1:0] M3Sel,
	 output M4Sel
    );
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
	
	
	assign NPCOp	=	beq	? `BEQ:
							j		? `J	:
							jal	? `J	:
							jr		? `JR	:
							`PC4;
							
							
	assign WE = addu | subu | ori | lw | jal | slt | lui | lb | lh | sll | sllv | sltu ; 
	assign EXTOp 	=	ori	? `ZERO		:
							lw		? `SIGNED	:
							sw		? `SIGNED	:
							lb		? `SIGNED	:
							sb		? `SIGNED	:
							lh		? `SIGNED	:
							sh		? `SIGNED	:
							1'b0;
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
							4'd0;
		
	assign DMWr = sw | sb | sh ;
	assign DMOp 	=	( lw | sw )	? `WORD	:
							( lh | sh )	? `HALF	:
							( lb | sb ) ? `BITE	:
							2'b00;
	assign IfSigned = ( lh | lb ) ? 1: 0;
	assign M1Sel	= 	( addu | subu | slt | sll | sllv | sltu ) ? `M1Rd :
							(ori | lw | lui | lb | lh  ) ? `M1Rt	:
							(jal) ? `M1R31 :
							2'b00;
	assign M2Sel	= ( lw | lb |lh ) ? `M2DW :
							(jal) ? `M2NPC :
							(lui) ? `M2Lui:
							2'b00;
	assign M3Sel	= ( ori | lw | sw | lb | sb | lh | sh  ) ? `M3EXT:
							2'b00;
	assign M4Sel 	= (sll) ? `M4EXT :
							1'b0;
	 
	
endmodule

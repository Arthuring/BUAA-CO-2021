`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:49:39 11/11/2021 
// Design Name: 
// Module Name:    macro 
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
/////////////////////////////WIDE//////////////////////////////
`define ALUOp_WIDE			4
`define NPCOp_WIDE			3
`define EXTOp_WIDE			2

`define MALUBSel_WIDE		2
`define MALUASel_WIDE		2
`define DMOp_WIDE				4
`define StType_WIDE 			3
///////////ALU Options///////////////
`define AND         	4'b0000
`define OR          	4'b0001
`define ADD         	4'b0010
`define SUB         	4'b0011
`define SLT         	4'b0100
`define SLL         	4'b0101
`define SLTU        	4'b0110
`define XOR			  	4'b0111
`define NOR				4'b1000
`define SRL				4'b1001
`define SRA				4'b1010

///////////PC///////////////////////
`define PC_INI      32'h00003000

//////////IM////////////////////////
`define IM_SIZE     31'd4096

//////////NPC///////////////////////
`define PC4         3'b000
`define BRNCH         3'b001
`define J           3'b010
`define JR          3'b011

/////////EXT////////////////////////
`define ZERO        2'b00
`define SIGNED      2'b01
`define EXT_LUI     2'b10
//////////CMP///////////////////////
`define CMPOp_WIDE  4
`define Eql         4'b0000
`define Grt         4'b0001
`define Les         4'b0010
`define NEql        4'b0011
`define GrtEql      4'b0100
`define LesEql      4'b0101
`define EqlZero     4'b0110 
`define GrtEqlZero  4'b0111
`define LesEqlZero  4'b1000
`define GrtZero     4'b1001
`define LesZero     4'b1010
////////MA3Sel//////////////////////
`define MA3Rd       2'b00
`define MA3Rt       2'b01
`define MA3R31      2'b10
////////MGRFWDSel//////////////////////
`define MGRFWDSel_WIDE		3
`define MGRFWDALU	3'b000
`define MGRFWDDW	3'b001
`define MGRFWDNPC	3'b010
`define MGRFWDLui	3'b011
`define MGRFWDHILO  3'b100
////////MALUBSel//////////////////////
`define MALUBRD2	2'b00
`define MALUBEXT	2'b01
////////MALUASel//////////////////////
`define MALUARD1		2'b00
`define MALUA_SHALT	2'b01
///////////////DMOp//////////////////
`define WORD			3'b000
`define HALF			3'b001
`define BITE			3'b010
///////////////////FORWARD////////
`define E_TO_D      	2'b10
`define M_TO_D      	2'b01
`define M_TO_E      	2'b10
`define W_TO_E      	2'b01 
`define W_TO_M      	2'b01 
`define NoForward   	2'b00
////////////////M_MGRFWD//////////
`define M_PC8       	3'b001
`define M_C         	3'b000
`define M_EXT		  	3'b010
`define M_HILO          3'b100
///////////////E_MGRFWD///////////
`define E_PC8       	2'b01
`define E_EXT       	2'b10

///////////////BE/////////////////
`define Save_Word		4'b1111
`define Save_Half_0	4'b0011
`define Save_Half_1	4'b1100
`define Save_Byte_0	4'b0001
`define Save_Byte_1	4'b0010
`define Save_Byte_2	4'b0100
`define Save_Byte_3	4'b1000
`define Save_No_Byte	4'b0000

`define SW				3'b001
`define SH				3'b010
`define SB				3'b011
`define NOSAVE			3'b000
//////////////DBS/////////////////
`define NO_EXT			3'b000
`define UNSIGN_B_EXT	3'b001
`define SIGN_B_EXT	3'b010
`define UNSIGN_H_EXT	3'b011
`define SIGN_H_EXT	3'b100

///////////////MDU////////////////
`define MULT			4'b0000
`define MULTU			4'b0001
`define DIV				4'b0010
`define DIVU			4'b0011
`define MFHI			4'b0100
`define MFLO			4'b0101
`define MTHI			4'b0110
`define MTLO			4'b0111
////////////HILOSel/////////////
`define HI              1'b0
`define LO              1'b1
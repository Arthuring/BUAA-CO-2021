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
///////////ALU Options///////////////
`define AND 4'b0000
`define OR 4'b0001
`define ADD 4'b0010
`define SUB 4'b0011
`define SLT 4'b0100
`define SLL 4'b0101
`define SLTU 4'b0110

///////////PC///////////////////////
`define PC_INI 32'h00003000

//////////IM////////////////////////
`define IM_SIZE 1024

//////////NPC///////////////////////
`define PC4 3'b000
`define BEQ 3'b001
`define J 3'b010
`define JR 3'b011

/////////EXT////////////////////////
`define ZERO 1'b0
`define SIGNED 1'b1

////////M1Sel//////////////////////
`define M1Rd 2'b00
`define M1Rt 2'b01
`define M1R31 2'b10
////////M2Sel//////////////////////
`define M2ALU		2'b00
`define M2DW		2'b01
`define M2NPC		2'b10
`define M2Lui		2'b11
////////M3Sel//////////////////////
`define M3RD2		2'b00
`define M3EXT		2'b01
////////M4Sel//////////////////////
`define M4RD1		1'b0
`define M4EXT		1'b1
///////////////////////////////////
`define WORD		2'b00
`define HALF		2'b01
`define BITE		2'b10
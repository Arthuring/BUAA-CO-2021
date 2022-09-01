`timescale 1ns / 1ps
`include "macro.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:22:45 11/11/2021 
// Design Name: 
// Module Name:    NPC 
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
module NPC(
    input [31:0] F_PC,
	input [31:0] D_PC,
    output reg [31:0] NPC,
    input [25:0] Imm,
    output reg [31:0] PC8,
    input [2:0] NPCOp,
    input [31:0] RA,
    input b_jump
    );
	
	always @(*)begin
		case(NPCOp)
			`PC4:begin
				NPC = F_PC + 32'd4;
			end
			`BRNCH:begin
				if (b_jump == 0)begin
					NPC = F_PC + 32'd4;
				end
				else begin
					NPC = D_PC + 32'd4 + {{14{Imm[15]}},Imm[15:0] ,2'b00};
				end
			end
			`J:begin
				NPC = {D_PC[31:28],Imm,2'b00};
			end
			`JR:begin
				NPC = RA;
			end
			default begin
				NPC = F_PC + 32'd4;
			end
		endcase
		PC8 = F_PC + 32'd8;
	end
	
endmodule

`timescale 1ns / 1ps
`include "macro.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:59:28 11/11/2021 
// Design Name: 
// Module Name:    EXT 
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
module EXT(
    input [15:0] Imm,
    input [1:0] EXTOp,
    output [31:0] Ext
    );
	assign Ext = (EXTOp == `ZERO) ? {{16{1'b0}},Imm} :
					(EXTOp == `SIGNED) ? {{16{Imm[15]}},Imm} :
                    (EXTOp == `EXT_LUI) ? {Imm, {16{1'b0}}} :
					32'd0;

endmodule

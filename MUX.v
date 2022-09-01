`timescale 1ns / 1ps
`include "macro.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:06:04 11/11/2021 
// Design Name: 
// Module Name:    MUX 
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
module MUX_b1_32(
	input [31:0] I0,
	input [31:0] I1,
	input Op,
	output [31:0] Out
    );
assign Out = (Op == 0) ? I0 : I1;

endmodule

module MUX_b2_32(
	input [31:0] I0,
	input [31:0] I1,
	input [31:0] I2,
	input [31:0] I3,
	input [1:0] Op,
	output [31:0] Out
);
	assign Out = (Op == 2'b00) ? I0 :
					(Op == 2'b01) ? I1 :
					(Op == 2'b10) ? I2:
					(Op == 2'b11) ? I3 :
					32'b0;
endmodule 

module MUX_b2_5(
	input [4:0] I0,
	input [4:0] I1,
	input [4:0] I2,
	input [4:0] I3,
	input [1:0] Op,
	output [4:0] Out
);
	assign Out = (Op == 2'b00) ? I0 :
					(Op == 2'b01) ? I1 :
					(Op == 2'b10) ? I2:
					(Op == 2'b11) ? I3 :
					5'b0;
endmodule 
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:38:02 11/18/2021 
// Design Name: 
// Module Name:    ID_EX 
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
module ID_EX(
    input clk,
    input reset,
    input [31:0] D_V1,
    input [31:0] D_V2,
    input [31:0] D_EXT,
    input [31:0] D_PC8,
    input [31:0] D_PC,
	input [31:0] D_Instr,
	input D_b_jump,
	 
    output reg [31:0] E_V1,
    output reg [31:0] E_V2,
    output reg [31:0] E_EXT,
    output reg [31:0] E_PC8,
    output reg [31:0] E_PC,
	output reg [31:0] E_Instr,
	output reg E_b_jump
    );
    always @(posedge clk) begin
        if(reset)begin
            E_V1 <= 0;
            E_V2 <= 0;
            E_PC <= 0;
            E_PC8 <= 0;
            E_EXT  <= 0;
            E_Instr <= 0;
				E_b_jump <= 0;
        end
        else begin
            E_V1 <= D_V1;
            E_V2 <= D_V2;
            E_PC <= D_PC;
            E_PC8 <= D_PC8;
            E_EXT <= D_EXT;
            E_Instr <= D_Instr;
				E_b_jump <= D_b_jump;
        end
    end

endmodule

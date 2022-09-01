`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:45:58 11/19/2021 
// Design Name: 
// Module Name:    MEM_WB 
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
module MEM_WB(
    input clk,
    input reset,
    input [31:0] M_C,
    input [31:0] M_DR,
    input [31:0] M_PC,
    input [31:0] M_PC8,
    input [31:0] M_EXT,
    //input [4:0] M_A3,
    input [31:0] M_Instr,
	input M_check,
	 
    output reg [31:0] W_C,
    output reg [31:0] W_DR,
    output reg [31:0] W_PC,
    output reg [31:0] W_EXT,
    output reg [31:0] W_PC8,
   // output reg [4:0] W_A3,
    output reg [31:0] W_Instr,
	 output reg W_check
    );
    always @(posedge clk) begin
        if(reset)begin
            W_C     <= 0;
            W_DR    <= 0;
            W_PC    <= 0;
            W_PC8   <= 0;
            //W_A3    <= 0;
            W_Instr <= 0;
            W_EXT <= 0;
				W_check <= 0;
        end
        else begin
            W_C     <= M_C;
            W_DR    <= M_DR;
            W_PC    <= M_PC;
            W_PC8   <= M_PC8;
           // W_A3    <= M_A3;
            W_EXT   <= M_EXT;
            W_Instr <= M_Instr;
				W_check <= M_check;
        end
    end


endmodule

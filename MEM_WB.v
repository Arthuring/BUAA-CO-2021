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
    input [31:0] M_HILO,
	 input M_b_jump,
	 input M_Mcndtn,
	 input M_Ecndtn,
     input [31:0] M_CP0,
	 
    output reg [31:0] W_C,
    output reg [31:0] W_DR,
    output reg [31:0] W_PC,
    output reg [31:0] W_EXT,
    output reg [31:0] W_PC8,
   // output reg [4:0] W_A3,
    output reg [31:0] W_Instr,
    output reg [31:0] W_HILO,
    output reg [31:0] W_CP0,
	 output reg W_b_jump,
	 output reg W_Mcndtn,
	 output reg W_Ecndtn
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
            W_HILO <= 0;
				W_b_jump <= 0;
				W_Mcndtn <= 0;
				W_Ecndtn <= 0; 
                W_CP0 <= 0;
        end
        else begin
            W_C     <= M_C;
            W_DR    <= M_DR;
            W_PC    <= M_PC;
            W_PC8   <= M_PC8;
           // W_A3    <= M_A3;
            W_EXT   <= M_EXT;
            W_Instr <= M_Instr;
            W_HILO <= M_HILO;
				W_b_jump <= M_b_jump;
				W_Mcndtn <= M_Mcndtn;
				W_Ecndtn <= M_Ecndtn;
                W_CP0 <= M_CP0;
        end
    end


endmodule

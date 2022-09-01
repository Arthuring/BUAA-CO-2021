`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:42:35 11/19/2021 
// Design Name: 
// Module Name:    EX_MEM 
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
module EX_MEM(
    input clk,
    input reset,
    input [31:0] E_C,
    input [31:0] E_V2,
    input [31:0] E_PC,
    input [31:0] E_PC8,
    input [4:0] E_exc,
    //input [4:0] E_A3,
    input [31:0] E_EXT,
    input [31:0] E_Instr,
    input [31:0] E_HILO,	 
	 input E_b_jump,
	 input E_Ecndtn,
    input E_DM_Ov,
    input E_BD,
	 
    output reg [31:0] M_C,
    output reg [31:0] M_V2,
    output reg [31:0] M_PC,
    output reg [31:0] M_PC8,
    output reg [31:0] M_EXT,
    //output reg [4:0] M_A3, 
    output reg [31:0] M_Instr,
    output reg [31:0] M_HILO,
	 output reg M_b_jump,
	 output reg M_Ecndtn,
     output reg [4:0] M_exc,
     output reg M_DM_Ov,
     output reg M_BD
    );
    
    always @(posedge clk) begin
        if(reset)begin
            M_C <= 0;
            M_V2 <= 0;
            M_PC <= 0;
            M_PC8 <= 0;
           // M_A3  <= 0;
            M_EXT <= 0;
            M_Instr <= 0;
            M_HILO <= 0;
				M_b_jump <= 0;
				M_Ecndtn <= 0;
                M_exc <= 0;
                M_DM_Ov <= 0;
                M_BD <= 0;
        end
        else begin
            M_C <= E_C;
            M_V2 <= E_V2;
            M_PC <= E_PC;
            M_PC8 <= E_PC8;
            M_EXT <= E_EXT;
            //M_A3  <= E_A3;
            M_Instr <= E_Instr;
            M_HILO <= E_HILO;
				M_b_jump <= E_b_jump;
				M_Ecndtn <= E_Ecndtn;
                M_exc <= E_exc;
                M_DM_Ov <= E_DM_Ov;
                M_BD <= E_BD;
        end
    end


endmodule

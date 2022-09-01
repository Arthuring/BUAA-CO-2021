`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:34:16 11/18/2021 
// Design Name: 
// Module Name:    IF_ID 
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
module IF_ID(
    input clk,
    input reset,
    input WE,
    input [31:0] F_Instr,
	 input [31:0] F_PC,
    input [31:0] F_PC8,
	 input likely,
	 input [4:0] F_exc,
	 input F_BD,

    output reg [31:0] D_Instr,
    output reg [31:0] D_PC8,
	 output reg [31:0] D_PC,
	 output reg [4:0] D_exc,
	 output reg D_BD
    );
	always @(posedge clk) begin
        if(reset)begin
            D_PC8 <= 0;
            D_Instr <= 0;
			D_PC <= 0;
			D_exc <= 0;
			D_BD <= 0;
        end
        else begin
				if (WE)begin
					if(likely == 1)begin
						D_PC8 <= 0;
						D_Instr <= 0;
						D_PC <= 0;
						D_exc <= 0;
						D_BD <= 0;
					end
					else begin
						D_PC8 <= F_PC8;
						D_Instr <= F_Instr;
						D_PC <= F_PC;
						D_exc <= F_exc;
						D_BD <= F_BD;
					end
				end
        end
    end

	
	
	
endmodule

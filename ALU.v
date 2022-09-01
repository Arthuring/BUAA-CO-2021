`timescale 1ns / 1ps
`include "macro.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:46:10 11/11/2021 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUOp,
	input ALU_Arith_Overflow,
	input ALU_DM_Overflow,

	 output ALU_Ov,
     output DM_Ov,
    output reg [31:0] C
   // output reg zero
    );

always @(*)begin
	case(ALUOp)
		`AND:begin
			C = A & B;
			//zero = 0;
		end
        `OR:begin
            C = A | B;
				//zero = 0;
        end
        `ADD:begin
            C = A + B;
				//zero = 0;
        end
        `SUB:begin
            C = A - B;
				
        end
        `SLT:begin
            if ($signed(A) < $signed(B)) begin
                C = 32'd1;
            end
            else begin
                C = 32'd0;
            end
        end
        `SLL:begin
            C = B << A[4:0];
        end
		`SLTU:begin
            if(A < B)begin
                C = 32'd1;
            end
            else begin
                C = 32'd0;
            end
        end
        `XOR:begin
            C = A ^ B;
        end
        `NOR:begin
            C = ~ (A | B);
        end
        `SRL:begin
            C = B >> A[4:0];
        end
        `SRA:begin
            C = $signed(B) >>> A[4:0];
        end

	endcase
end

wire [32:0] Ext_A = {A[31], A}, Ext_B = {B[31], B};
wire [32:0] Ext_Add = Ext_A + Ext_B, Ext_Sub = Ext_A - Ext_B;

assign ALU_Ov = (ALU_Arith_Overflow) && (((ALUOp == `ADD) && (Ext_Add[32] != Ext_Add[31])) ||((ALUOp == `SUB)&&(Ext_Sub[32] != Ext_Sub[31])));
assign DM_Ov = (ALU_DM_Overflow) && (((ALUOp == `ADD) && (Ext_Add[32] != Ext_Add[31])) ||((ALUOp == `SUB)&&(Ext_Sub[32] != Ext_Sub[31])));
endmodule

`timescale 1ns / 1ps
`include "macro.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:26:09 11/20/2021 
// Design Name: 
// Module Name:    CMP 
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
module CMP(
    input [31:0] CMP_RS,
    input [31:0] CMP_RT,
	input [`CMPOp_WIDE-1:0] CMPOp,

    output reg b_jump
    );
	 
	always@(*)begin
		if(CMPOp == `Eql)begin
			if (CMP_RS == CMP_RT)begin
				b_jump = 1;
			end
			else begin
				b_jump = 0;
			end
		end
		else if (CMPOp == `NEql)begin
			if (CMP_RS != CMP_RT)begin
				b_jump = 1;
			end
			else begin
				b_jump = 0;
			end
		end
		else if (CMPOp == `LesEqlZero)begin
			if( $signed(CMP_RS) <= 0 )begin
			  b_jump = 1;
			end
			else begin
			  b_jump = 0;
			end
		end
		else if (CMPOp == `GrtZero)begin
		  	if ($signed(CMP_RS) > 0 )begin
				b_jump = 1;
			end
			else begin
				b_jump = 0;
			end
		end
		else if (CMPOp == `LesZero) begin
			if($signed(CMP_RS) < 0 )begin
				b_jump = 1;
			end
			else begin
				b_jump = 0;
			end

		end
		else if (CMPOp == `GrtEqlZero)begin
		  if($signed(CMP_RS) >= 0) begin
			b_jump = 1;
		  end
		  else begin
			b_jump = 0;
		  end
		end
	end

endmodule

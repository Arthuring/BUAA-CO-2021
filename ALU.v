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

	endcase
end

endmodule

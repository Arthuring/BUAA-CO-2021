`timescale 1ns / 1ps
`include "macro.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:36:58 11/11/2021 
// Design Name: 
// Module Name:    DM 
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
module DM(
    input clk,
    input reset,
    input [31:0] PC,
    input [31:0] A,
    input [31:0] WD,
    input DMWr,
	 input [2:0] DMOp,
	 input IfSigned,
    output reg [31:0] RD
    );
    reg [31:0] dm [0:3072];
    integer i;
	 //write
    always @(posedge clk)begin
        if(reset == 1)begin
            for(i = 0; i<3072;i = i + 1)begin
                dm[i] <= 32'b0;
            end

        end
        else begin
            if(DMWr == 1)begin
					if(DMOp == `WORD)begin
					//	$display("@%h: *%h <= %h", PC, A, WD);
						$display("%d@%h: *%h <= %h", $time, PC, A, WD);
						dm[A[13:2]] <= WD;
					end
					else if (DMOp == `HALF)begin
						case(A[1])
							0:dm[A[13:2]][15:0] <= WD[15:0];
							1:dm[A[13:2]][31:16] <= WD[15:0];
						endcase
						//$display("@%h: *%h <= %h", PC, A, dm[A[13:2]]);
						$display("%d@%h: *%h <= %h", $time, PC, A, dm[A[13:2]]);
					end
					else if (DMOp == `BITE) begin
						case(A[1:0]) 
							2'b00: dm[A[13:2]][7:0] <= WD[7:0];
							2'b01: dm[A[13:2]][15:8] <= WD[7:0];
							2'b10: dm[A[13:2]][23:16] <= WD[7:0];
							2'b11: dm[A[13:2]][31:24] <= WD[7:0];
						endcase
						//$display("@%h: *%h <= %h", PC, A, dm[A[13:2]]);
						$display("%d@%h: *%h <= %h", $time, PC, A, dm[A[13:2]]);
					end
            end
        end
    end
	 //read
    //assign RD = dm[A[11:2]];
	 always @(*)begin
		if (DMOp == `WORD) begin
			RD = dm[A[13:2]];
		end
		else if (DMOp == `HALF) begin
			case(A[1])
				0:begin
					RD[15:0] = dm[A[13:2]][15:0]; 
				end
				1:begin
					RD[15:0] = dm[A[13:2]][31:16];
				end
			endcase
			case(IfSigned) 
				0: RD[31:16] = 16'd0;
				1: RD[31:16] = {16{RD[15]}};
			endcase
		end
		else if (DMOp == `BITE)begin
			case(A[1:0])
				2'b00: RD[7:0] = dm[A[13:2]][7:0]; 
				2'b01: RD[7:0] = dm[A[13:2]][15:8]; 
				2'b10: RD[7:0] = dm[A[13:2]][23:16]; 
				2'b11: RD[7:0] = dm[A[13:2]][31:24]; 
			endcase
			case(IfSigned)
				0: RD[31:8] = 24'b0;
				1: RD[31:8] = {24{RD[7]}};
 			endcase
		end
	 end

endmodule

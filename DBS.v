`timescale 1ns / 1ps
`include "macro.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:34:04 11/28/2021 
// Design Name: 
// Module Name:    DBS 
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
module DBS(
    input [1:0] Ad,
    input [2:0] LdType,
    input [31:0] RdData,
    output reg [31:0] Data
    );
	always @(*)begin
		if(LdType == `NO_EXT)begin
            Data = RdData;
		end
        else if(LdType == `UNSIGN_H_EXT)begin
           if (Ad[1] == 0) Data = {16'b0, RdData[15:0]};
           else if (Ad[1] == 1) Data = {16'b0, RdData[31:16]};
           else Data = 32'd0; 
        end
        else if(LdType == `SIGN_H_EXT)begin
            if (Ad[1] == 0) Data = {{16{RdData[15]}}, RdData[15:0]};
            else if (Ad[1] == 1) Data = {{16{RdData[31]}}, RdData[31:16]};
            else Data = 32'd0;
        end
        else if (LdType == `UNSIGN_B_EXT) begin
            if(Ad == 2'b00)begin
                Data = {24'd0, RdData[7:0]};
            end
            else if (Ad == 2'b01)begin
                Data = {24'd0, RdData[15:8]};
            end
            else if (Ad == 2'b10)begin
                Data = {24'd0, RdData[23:16]};
            end
            else if (Ad == 2'b11)begin
                Data = {24'd0, RdData[31:24]};
            end
        end
        else if(LdType == `SIGN_B_EXT)begin
            if (Ad == 2'b00)begin
                Data = {{24{RdData[7]}},RdData[7:0]};
            end
            else if (Ad == 2'b01)begin
                Data = {{24{RdData[15]}},RdData[15:8]};
            end
            else if (Ad == 2'b10)begin
                Data = {{24{RdData[23]}},RdData[23:16]};
            end
            else if (Ad == 2'b11)begin
                Data = {{24{RdData[31]}},RdData[31:24]};
            end
        end
    end

endmodule

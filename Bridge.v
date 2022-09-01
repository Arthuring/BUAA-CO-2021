`timescale 1ns / 1ps
`include "macro.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:42:53 12/12/2021 
// Design Name: 
// Module Name:    Bridge 
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
module Bridge(
    input [31:0] PrAddr,
    input [3:0] ByteEn,
    input [31:0] Pr_WrData,//Data from procecer
    input [31:0] DM_RdData,
    input [31:0] Timer0_RdData,
    input [31:0] Timer1_RdData,
    output [31:0] DEV_Addr,
    output [31:0] DEV_WD,
    output [31:0] Pr_RdData,//Data to processer
    output WeTC0,
    output WeTC1,
    output [3:0] WeDM
    );
    wire HitDM = (PrAddr >= `MIN_DM && PrAddr <= `MAX_DM);
    wire HitTC0 = (PrAddr >= `MIN_TC0 && PrAddr <= `MAX_TC0);
    wire HitTC1 = (PrAddr >= `MIN_TC1 && PrAddr <= `MAX_TC1);
   

    assign Pr_RdData =  (HitDM)     ? DM_RdData :
                        (HitTC0)    ? Timer0_RdData :
                        (HitTC1)    ? Timer1_RdData :
                        32'd0; 

    assign  WeTC0 = (&ByteEn) & HitTC0;
    assign  WeTC1 = (&ByteEn) & HitTC1;    
    assign  WeDM  = HitDM ? ByteEn : 4'b0000;

    assign DEV_WD = Pr_WrData;
    assign DEV_Addr = PrAddr;
endmodule

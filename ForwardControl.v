`timescale 1ns / 1ps
`include "macro.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:34:52 11/19/2021 
// Design Name: 
// Module Name:    RiskControl 
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
module ForwardControl(
    input [31:0] D_Instr,
    input [31:0] E_Instr,
    input [31:0] M_Instr,
    input [31:0] W_Instr,

    output [1:0] D_MFRD1Sel,
    output [1:0] D_MFRD2Sel,
    output [1:0] E_MFRD1Sel,
    output [1:0] E_MFRD2Sel,
    output [1:0] M_MFV2Sel
    );
    //read_addr
    wire [4:0] D_rs_ad, D_rt_ad;
    wire [4:0] E_rs_ad, E_rt_ad;
    wire [4:0] M_rt_ad;
    //write_addr
    wire [4:0] E_A, M_A, W_A;


    CU d_f_cu(
        .Instr(D_Instr),
        .rs_ad(D_rs_ad),
        .rt_ad(D_rt_ad)
    );
    CU e_f_cu(
        .Instr(E_Instr),
        .write_reg(E_A),
        .rs_ad(E_rs_ad),
        .rt_ad(E_rt_ad)
    );
    CU m_f_cu(
        .Instr(M_Instr),
        .write_reg(M_A),
        
        .rt_ad(M_rt_ad)
    );
    CU w_f_cu(
        .Instr(W_Instr),
        .write_reg(W_A)
    );

    assign D_MFRD1Sel = (E_A != 5'b0 && D_rs_ad == E_A)    ? `E_TO_D   :
                        (M_A != 5'b0 && D_rs_ad == M_A)    ? `M_TO_D   :
                        `NoForward;
    assign D_MFRD2Sel = (E_A != 5'b0 && D_rt_ad == E_A)    ? `E_TO_D   :
                        (M_A != 5'b0 && D_rt_ad == M_A)    ? `M_TO_D   :
                        `NoForward;

    assign E_MFRD1Sel = (M_A != 5'b0 && E_rs_ad == M_A)    ? `M_TO_E   :
                        (W_A != 5'b0 && E_rs_ad == W_A)    ? `W_TO_E   :
                        `NoForward;
    assign E_MFRD2Sel = (M_A != 5'b0 && E_rt_ad == M_A)    ? `M_TO_E   :
                        (W_A != 5'b0 && E_rt_ad == W_A)    ? `W_TO_E   :
                        `NoForward;

    assign M_MFV2Sel = (W_A != 5'b0 && M_rt_ad == W_A)     ? `W_TO_M   :
                        `NoForward;
    

endmodule

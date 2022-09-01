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
	 input E_b_jump,
	 input M_b_jump,
	 input W_b_jump,
	 
	 input W_Mcndtn,
	 
	 input M_Ecndtn,
	 input W_Ecndtn,
	 input E_Ecndtn,
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
	 wire E_calc_r, E_calc_i, E_load,E_branch, E_j_r,E_store, E_Lui, E_jal, E_md, E_mf, E_mt, E_mfc0;
	 wire M_calc_r, M_calc_i, M_load,M_branch, M_j_r,M_store,M_Lui, M_jal, M_mfc0;
	 wire [2:0] D_Tuse_rs, D_Tuse_rt, E_Tnew, M_Tnew; 
	 
    CU d_f_cu(
        .Instr(D_Instr),
        .rs_ad(D_rs_ad),
        .rt_ad(D_rt_ad)
    );
    CU e_f_cu(
        .Instr(E_Instr),
        .write_reg(E_A),
        .rs_ad(E_rs_ad),
        .rt_ad(E_rt_ad),
		  .b_jump(E_b_jump),
		  
		  .calc_r(E_calc_r),
        .calc_i(E_calc_i),
        .load(E_load),
        .store(E_store),
        .branch(E_branch),
        .j_r(E_j_r),
        .j_al(E_jal),
        .Lui(E_Lui),
		   .mf(E_mf),
		  .md(E_md),
          .mfc0(E_mfc0)
    );
    CU m_f_cu(
        .Instr(M_Instr),
        .write_reg(M_A),
        
        .rt_ad(M_rt_ad),
		  .b_jump(M_b_jump),
		  .Ecndtn(M_Ecndtn),
		  .calc_r(M_calc_r),
        .calc_i(M_calc_i),
        .load(M_load),
        .store(M_store),
        .branch(M_branch),
        .j_r(M_j_r),
        .j_al(M_jal),
        .Lui(M_Lui),
        .mfc0(M_mfc0)
    );
    CU w_f_cu(
        .Instr(W_Instr),
        .write_reg(W_A),
		  .b_jump(W_b_jump),
		  .Ecndtn(M_Ecndtn),
		  .Mcndtn(W_Mcndtn)
    );
	
	assign E_Tnew = (E_Lui |E_jal ) ? 3'd0 :
                    ((E_calc_i & (!E_Lui)) | E_calc_r | E_mf ) ? 3'd1:
                    (E_load | E_mfc0) ? 3'd2:
                    3'd0;    
	 assign M_Tnew = (M_Lui |M_jal ) ? 3'd0 :
                    ((M_calc_i & (!M_Lui)) | M_calc_r ) ? 3'd0:
                    (M_load | M_mfc0) ? 3'd1:
                    3'd0; 
	
    assign D_MFRD1Sel = (E_A != 5'b0 && D_rs_ad == E_A && E_Tnew == 0)    ? `E_TO_D   :
                        (M_A != 5'b0 && D_rs_ad == M_A && M_Tnew == 0)    ? `M_TO_D   :
                        `NoForward;
    assign D_MFRD2Sel = (E_A != 5'b0 && D_rt_ad == E_A && E_Tnew == 0)    ? `E_TO_D   :
                        (M_A != 5'b0 && D_rt_ad == M_A && M_Tnew == 0)    ? `M_TO_D   :
                        `NoForward;

    assign E_MFRD1Sel = (M_A != 5'b0 && E_rs_ad == M_A && M_Tnew == 0)    ? `M_TO_E   :
                        (W_A != 5'b0 && E_rs_ad == W_A)    ? `W_TO_E   :
                        `NoForward;
    assign E_MFRD2Sel = (M_A != 5'b0 && E_rt_ad == M_A && M_Tnew == 0)    ? `M_TO_E   :
                        (W_A != 5'b0 && E_rt_ad == W_A)    ? `W_TO_E   :
                        `NoForward;

    assign M_MFV2Sel = (W_A != 5'b0 && M_rt_ad == W_A)     ? `W_TO_M   :
                        `NoForward;
    

endmodule

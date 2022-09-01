`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:49:07 11/22/2021 
// Design Name: 
// Module Name:    StallControl 
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
module StallControl(
    input [31:0] D_Instr,
    input [31:0] E_Instr,
    input [31:0] M_Instr,
    input [31:0] W_Instr,
	 input E_b_jump,
	 input M_b_jump,
	 input W_b_jump,
	 
	 input M_Ecndtn,
	 input W_Ecndtn,
	 input E_Ecndtn,
	 
	 input W_Mcndtn, 
	 
	 input Busy,
    output stall
    );
    wire [2:0] D_Tuse_rs, D_Tuse_rt, E_Tnew, M_Tnew; 
    wire D_calc_r, D_calc_i, D_load,D_branch, D_j_r,D_store,D_Shift, D_branch_rt;
    wire E_stall_rs,M_stall_rs,E_stall_rt, M_stall_rt;
    wire stall_rs, stall_rt, stall_MDU;
    wire [4:0] D_rs_ad, D_rt_ad, E_A, M_A;
	 wire D_md,D_mt,D_mf;
	 wire stall_new;


    CU d_s_cu(
        .Instr(D_Instr),
        .calc_r(D_calc_r),
        .calc_i(D_calc_i),
        .load(D_load),
        .store(D_store),
        .branch(D_branch),
		  .branch_rt(D_branch_rt),
		  .Shift(D_Shift),
        .j_r(D_j_r),
        .rs_ad(D_rs_ad),
        .rt_ad(D_rt_ad),
		  .md(D_md),
		  .mt(D_mt),
		  .mf(D_mf)
    );
    assign D_Tuse_rs = (D_branch | D_j_r ) ? 3'd0 :
                       ((D_calc_r & !D_Shift) | D_calc_i | D_load | D_store | D_mt | D_md ) ? 3'd1 :
                       3'd3;
    assign D_Tuse_rt = (D_branch_rt) ? 3'd0 :
                       (D_calc_r | D_md ) ? 3'd1 :
                       (D_store) ? 3'd2 :
                       3'd3;
							  
    wire E_calc_r, E_calc_i, E_load,E_branch, E_j_r,E_store, E_Lui, E_jal, E_md, E_mf, E_mt;
    CU e_s_cu(
        .Instr(E_Instr),
        .calc_r(E_calc_r),
        .calc_i(E_calc_i),
        .load(E_load),
        .store(E_store),
        .branch(E_branch),
        .j_r(E_j_r),
        .j_al(E_jal),
        .Lui(E_Lui),
        .write_reg(E_A),
		  .mf(E_mf),
		  .md(E_md),
		  .b_jump(E_b_jump)
    );
    assign E_Tnew = (E_Lui |E_jal ) ? 3'd0 :
                    ((E_calc_i & (!E_Lui)) | E_calc_r | E_mf ) ? 3'd1:
                    E_load ? 3'd2:
                    3'd0;    
 
    wire M_calc_r, M_calc_i, M_load,M_branch, M_j_r,M_store,M_Lui, M_jal;
   CU m_s_cu(
        .Instr(M_Instr),
        .calc_r(M_calc_r),
        .calc_i(M_calc_i),
        .load(M_load),
        .store(M_store),
        .branch(M_branch),
        .j_r(M_j_r),
        .j_al(M_jal),
        .Lui(M_Lui),
        .write_reg(M_A),
		  .Ecndtn(M_Ecndtn),
		  .b_jump(M_b_jump)
    );
    assign M_Tnew = (M_Lui |M_jal ) ? 3'd0 :
                    ((M_calc_i & (!M_Lui)) | M_calc_r ) ? 3'd0:
                    M_load ? 3'd1:
                    3'd0; 
						  
    assign E_stall_rs = (D_Tuse_rs < E_Tnew ) && (E_A != 5'b0 && D_rs_ad == E_A);
    assign M_stall_rs = (D_Tuse_rs < M_Tnew ) && (M_A != 5'b0 && D_rs_ad == M_A);

    assign E_stall_rt = (D_Tuse_rt < E_Tnew ) && (E_A != 5'b0 && D_rt_ad == E_A);
    assign M_stall_rt = (D_Tuse_rt < M_Tnew ) && (M_A != 5'b0 && D_rt_ad == M_A);

    assign stall_rs = E_stall_rs || M_stall_rs;
    assign stall_rt = E_stall_rt || M_stall_rt;
	 assign stall_MDU = ( Busy | E_md ) & (D_mf | D_md | D_mt);
	 //assign stall_new = (E_new && ((D_rs[0] == 0 && D_rs && D_rs_Tuse < E_Tnew) || (D_rt[0] == 0 && D_rt && D_rt_Tuse < E_Tnew) ));

    assign stall= stall_rs | stall_rt | stall_MDU;
    
	 
endmodule

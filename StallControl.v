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

    output stall
    );
    wire [2:0] D_Tuse_rs, D_Tuse_rt, E_Tnew, M_Tnew; 
    wire D_calc_r, D_calc_i, D_load,D_branch, D_j_r,D_store, D_lh_so;
    wire E_stall_rs,M_stall_rs,E_stall_rt, M_stall_rt;
    wire stall_rs, stall_rt;
    wire [4:0] D_rs_ad, D_rt_ad, E_A, M_A;



    CU d_s_cu(
        .Instr(D_Instr),
        .calc_r(D_calc_r),
        .calc_i(D_calc_i),
        .load(D_load),
        .store(D_store),
        .branch(D_branch),
        .j_r(D_j_r),
		  .lh_so(D_lh_so),
        .rs_ad(D_rs_ad),
        .rt_ad(D_rt_ad)
    );
    assign D_Tuse_rs = (D_branch | D_j_r) ? 3'd0 :
                       (D_calc_r | D_calc_i | D_load | D_store | D_lh_so ) ? 3'd1 :
                       3'd3;
    assign D_Tuse_rt = (D_branch) ? 3'd0 :
                       (D_calc_r) ? 3'd1 :
                       (D_store) ? 3'd2 :
                       3'd3;
							  
    wire E_calc_r, E_calc_i, E_load,E_branch, E_j_r,E_store, E_Lui, E_jal, E_lh_so;
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
		  .lh_so(E_lh_so),
        .write_reg(E_A)
    );
    assign E_Tnew = (E_Lui |E_jal ) ? 3'd0 :
                    ((E_calc_i & (!E_Lui)) | E_calc_r ) ? 3'd1:
                    (E_load | E_lh_so )? 3'd2:
                    3'd0;    
 
    wire M_calc_r, M_calc_i, M_load,M_branch, M_j_r,M_store,M_Lui, M_jal, M_lh_so;
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
		  .lh_so(M_lh_so),
        .write_reg(M_A)
    );
    assign M_Tnew = (M_Lui |M_jal ) ? 3'd0 :
                    ((M_calc_i & (!M_Lui)) | M_calc_r ) ? 3'd0:
                    (M_load | M_lh_so) ? 3'd1:
                    3'd0; 
						  
    assign E_stall_rs = (D_Tuse_rs < E_Tnew ) && (E_A != 5'b0 && ((E_lh_so)? (D_rs_ad == E_A || D_rs_ad == 5'd31):(D_rs_ad == E_A)));
    assign M_stall_rs = (D_Tuse_rs < M_Tnew ) && (M_A != 5'b0 && ((E_lh_so)? (D_rs_ad == M_A || D_rs_ad == 5'd31):(D_rs_ad == M_A)));

    assign E_stall_rt = (E_lh_so)? ((D_Tuse_rt < E_Tnew) && (E_A != 5'd0 && ((D_rt_ad == E_A) | (D_rt_ad == 5'd31)))):
								((D_Tuse_rt < E_Tnew ) && (E_A != 5'b0 && D_rt_ad == E_A));
    assign M_stall_rt = (M_lh_so)? ((D_Tuse_rt < M_Tnew) && (M_A != 5'd0 && ((D_rt_ad == M_A) | (D_rt_ad == 5'd31)))):
								(D_Tuse_rt < M_Tnew ) && (M_A != 5'b0 && D_rt_ad == M_A);

    assign stall_rs = E_stall_rs || M_stall_rs;
    assign stall_rt = E_stall_rt || M_stall_rt;

    assign stall= stall_rs || stall_rt;
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:54:36 12/10/2021 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,                       // ʱ���ź�
    input reset,                     // ͬ����λ�ź�
    input interrupt,                 // �ⲿ�ж��ź�
    output [31:0] macroscopic_pc,    // ���PC�������ģ�

    output [31:0] i_inst_addr,       // ȡָ PC
    input  [31:0] i_inst_rdata,      // i_inst_addr ��Ӧ�� 32 λָ��

    output [31:0] m_data_addr,       // ���ݴ洢����д����
    input  [31:0] m_data_rdata,      // m_data_addr ��Ӧ�� 32 λ����
    output [31:0] m_data_wdata,      // ���ݴ洢����д������
    output [3 :0] m_data_byteen,     // �ֽ�ʹ���ź�

    output [31:0] m_inst_addr,       // M ��PC

    output w_grf_we,                 // grf дʹ���ź�
    output [4 :0] w_grf_addr,        // grf ��д��Ĵ������
    output [31:0] w_grf_wdata,       // grf ��д������

    output [31:0] w_inst_addr        // W �� PC
);


	wire [31:0] M_PC;
    wire [31:0] bridge_rdata;
    wire [31:0] pro_dm_addr;
    wire [31:0] pro_dm_wdata;
    wire [3:0] pro_dm_byteEn;
	 wire TC0_IRQ, TC1_IRQ;
	 wire [31:0] bridge_addr;
    wire [31:0] bridge_wdata;
	 wire [3:0] bridge_byteEn;
    wire bridge_WeTC0;
    wire bridge_WeTC1;
    wire [3:0] bridge_WeDM;
    wire [31:0] TC0_rdata, TC1_rdata;
	 wire write_0x7f20;
 
	 assign m_inst_addr = M_PC;
	 //assign macroscopic_pc = M_PC;
	 assign m_data_addr = (write_0x7f20) ? (32'h7f20) : bridge_addr;
	 assign m_data_wdata = bridge_wdata;
	 assign m_data_byteen = (write_0x7f20) ? 4'b1111: bridge_byteEn;
	 
	Processer CPU(
        .clk(clk),
        .reset(reset),
        .i_inst_rdata(i_inst_rdata),
        .m_data_rdata(bridge_rdata),
        .HWInt({3'b000, interrupt, TC1_IRQ, TC0_IRQ}),

        .i_inst_addr(i_inst_addr),
        .m_data_addr(pro_dm_addr),
        .m_data_wdata(pro_dm_wdata),
        .m_data_byteen(pro_dm_byteEn),
        .m_inst_addr(M_PC),
        .w_grf_we(w_grf_we),
        .w_grf_addr(w_grf_addr),
        .w_grf_wdata(w_grf_wdata),
        .w_inst_addr(w_inst_addr),
		  .write_0x7f20(write_0x7f20),
		  .macroscopic_PC(macroscopic_pc)

    );
 

	Bridge bridge(
        .PrAddr(pro_dm_addr),
        .ByteEn(pro_dm_byteEn),
        .Pr_WrData(pro_dm_wdata),
        .DM_RdData(m_data_rdata),
        .Timer0_RdData(TC0_rdata),
        .Timer1_RdData(TC1_rdata),
        .DEV_Addr(bridge_addr),
        .DEV_WD(bridge_wdata),
        .Pr_RdData(bridge_rdata),
        .WeTC0(bridge_WeTC0),
        .WeTC1(bridge_WeTC1),
        .WeDM(bridge_byteEn)
    );

	TC Timer0(
        .clk(clk),
        .reset(reset),
        .Addr(bridge_addr[31:2]),
        .WE(bridge_WeTC0),
        .Din(bridge_wdata),
        .Dout(TC0_rdata),
        .IRQ(TC0_IRQ)
    );
	TC Timer1(
        .clk(clk),
        .reset(reset),
        .Addr(bridge_addr[31:2]),
        .WE(bridge_WeTC1),
        .Din(bridge_wdata),
        .Dout(TC1_rdata),
        .IRQ(TC1_IRQ)
    );
	

endmodule

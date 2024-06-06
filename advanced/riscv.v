 // addi, add, sub, and, or, xor , andi, ori, xori, sll, srl, beq, blt, jal

module riscv(

	input wire				 clk,
	input wire				 rst,         // high is reset
	
    // inst_mem
	input wire[31:0]         inst_i,
	output wire[31:0]        inst_addr_o,
	output wire              inst_ce_o,

    // data_mem
	input wire[31:0]         data_i,      // load data from data_mem
	output wire              data_we_o,
    output wire              data_ce_o,
	output wire[31:0]        data_addr_o,
	output wire[31:0]        data_o       // store data to  data_mem

);

wire				stall_w;
wire				if_flush_w;
wire	[31:0]		if_inst_w;
wire	[31:0]		if_pc_w;
wire				branch_w;
wire	[31:0]		pc_branch_w;
wire				jmp_w;
wire	[31:0]		pc_jmp_w;
wire	[4 :0]		id_rs1_w;
wire	[4 :0]		id_rs2_w;
wire	[31:0]		id_oprend1_w;
wire	[31:0]		id_oprend2_w;
wire	[63:0]		id_imm_w;
wire	[4 :0]		id_rd_w;
wire				id_memread_w;
wire				id_memtoreg_w;
wire				id_memwrite_w;
wire				id_regwrite_w;
wire				id_alusrc_w;
wire	[3 :0]		id_alu_ctrl_w;
wire	[4 :0]		ex_rd_w;
wire	[31:0]		ex_alu_rst_w;
wire	[31:0]		ex_mem_wdata_w;
wire				ex_memread_w;
wire				ex_memtoreg_w;
wire				ex_memwrite_w;
wire				ex_regwrite_w;
wire	[4 :0]		mem_rd_w;
wire	[31:0]		mem_mem_rdata_w;
wire	[31:0]		mem_alu_rst_w;
wire				mem_memtoreg_w;
wire				mem_regwrite_w;
wire	[31:0]		wb_wdata_w;
wire	[4 :0]		wb_rd_w;
wire				wb_regwrite_w;

hazard_detector x_hazard_detector(
	.branch_opcode(if_inst_w[6:0]),
	.rs1_i(if_inst_w[19:15]),
	.rs2_i(if_inst_w[24:20]),
	.id_rd_i(id_rd_w),
	.id_regwrite_i(id_regwrite_w), 
	.id_memread_i(id_memread_w),
	.ex_rd_i(ex_rd_w),
	.ex_regwrite_i(ex_regwrite_w),
	.ex_memread_i(ex_memread_w),
	.stall_o(stall_w)
);

inst_fetch x_inst_fetch(
	.clk(clk),
	.rst(rst),
	.pc_stall(stall_w),
	.if_stall(stall_w),
	.if_flush(if_flush_w),
	.branch(branch_w),
	.pc_branch_i(pc_branch_w),
	.branch_taken(branch_taken_w),
	.branch_pred_o(branch_pred_w),
	.jmp(jmp_w),
	.pc_jmp_i(pc_jmp_w),
	.inst_i(inst_i),
	.inst_addr_o(inst_addr_o),
	.inst_ce_o(inst_ce_o),
	.inst_o(if_inst_w),
	.pc_o(if_pc_w)
);

inst_decode x_inst_decode(
	.clk(clk),
	.rst(rst),
	.pc_i(if_pc_w),
	.inst_i(if_inst_w),
	.oprend1_o(id_oprend1_w),
	.oprend2_o(id_oprend2_w),
	.imm_o(id_imm_w),
	.rs1_o(id_rs1_w),
	.rs2_o(id_rs2_w),
	.rd_o(id_rd_w),
	.rd_i(wb_rd_w),
	.wdata_i(wb_wdata_w),
	.regwrite_i(wb_regwrite_w),
	// hazard io
	.stall_i(stall_w),
	
	
	// control io
	.if_flush_o(if_flush_w),
	.memread_o(id_memread_w),
	.memtoreg_o(id_memtoreg_w),
	.memwrite_o(id_memwrite_w),
	.regwrite_o(id_regwrite_w),
	.alusrc_o(id_alusrc_w),
	
	// aluop
	.alu_ctrl_o(id_alu_ctrl_w),

	// pc_branch
	.pc_branch_o(pc_branch_w),
	.branch_o(branch_w),
	.ex_rd_i(ex_rd_w),
	.ex_regwrite_i(ex_regwrite_w),
	.ex_oprend_i(ex_alu_rst_w),
	.mem_rd_i(mem_rd_w),
	.mem_regwrite_i(mem_regwrite_w),
	.mem_oprend_i(wb_wdata_w),
	.branch_taken_o(branch_taken_w),
	.branch_pred_i(branch_pred_w),
	
	// pc_jmp
	.pc_jmp_o(pc_jmp_w),
	.jmp_o(jmp_w)
);

execute x_execute(
	.clk(clk),
	.rst(rst),
	.oprend1_i(id_oprend1_w),
	.oprend2_i(id_oprend2_w),
	.ex_oprend_i(ex_alu_rst_w),
	.mem_oprend_i(wb_wdata_w),
	.mem_rd_i(mem_rd_w),
	.mem_regwrite_i(mem_regwrite_w),
	.imm_i(id_imm_w),
	.rs1_i(id_rs1_w),
	.rs2_i(id_rs2_w),
	.rd_o(ex_rd_w),
	.rd_i(id_rd_w),
	.alu_rst_o(ex_alu_rst_w),
	.mem_wdata_o(ex_mem_wdata_w),
	// control io
	.memread_i(id_memread_w),  // MEM
	.memtoreg_i(id_memtoreg_w), // WB
	.memwrite_i(id_memwrite_w), // MEM
	.regwrite_i(id_regwrite_w), // WB
	.alusrc_i(id_alusrc_w),   // EX
	.memread_o(ex_memread_w),
	.memtoreg_o(ex_memtoreg_w),
	.memwrite_o(ex_memwrite_w),
	.regwrite_o(ex_regwrite_w),
	
	// aluop
	.alu_ctrl_i(id_alu_ctrl_w)  // EX

);

mem x_mem(
	.clk(clk),
	.rst(rst),
	.rd_o(mem_rd_w),
	.rd_i(ex_rd_w),
	.alu_rst_i(ex_alu_rst_w),
	.mem_wdata_i(ex_mem_wdata_w), 
	
	.mem_rdata_o(mem_mem_rdata_w),
	.alu_rst_o(mem_alu_rst_w),
	
	// data_sram_io
	.data_i(data_i),
	.data_we_o(data_we_o),
    .data_ce_o(data_ce_o),
	.data_addr_o(data_addr_o),
	.data_o(data_o),
	
	// control io
	.memread_i(ex_memread_w),  // MEM
	.memtoreg_i(ex_memtoreg_w), // WB
	.memwrite_i(ex_memwrite_w), // MEM
	.regwrite_i(ex_regwrite_w), // WB
	
	.memtoreg_o(mem_memtoreg_w), // WB
	.regwrite_o(mem_regwrite_w)	// WB
	
);


writeback x_writeback(
	.clk(clk),
	.rst(rst),
	.rd_o(wb_rd_w),
	.rd_i(mem_rd_w),
	
	.mem_rdata_i(mem_mem_rdata_w),
	.alu_rst_i(mem_alu_rst_w),
	
	.wdata_o(wb_wdata_w),
	// control io
	.memtoreg_i(mem_memtoreg_w), // WB
	.regwrite_i(mem_regwrite_w), // WB
	.regwrite_o(wb_regwrite_w)
);

endmodule



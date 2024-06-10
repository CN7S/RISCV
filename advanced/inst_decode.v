module inst_decode(
	clk,
	rst,
	pc_i,
	inst_i,
	oprend1_o,
	oprend2_o,
	imm_o,
	rs1_o,
	rs2_o,
	rd_o,
	rd_i,
	wdata_i,
	regwrite_i,
	// hazard io
	stall_i,
	
	
	// control io
	if_flush_o,
	memread_o,
	memtoreg_o,
	memwrite_o,
	regwrite_o,
	alusrc_o,
	
	// aluop
	alu_ctrl_o,

	// pc_branch
	pc_branch_o,
	branch_o,
	branch_taken_o,
	branch_pred_i,
	
	ex_rd_i,
	mem_rd_i,
	ex_regwrite_i,
	mem_regwrite_i,
	ex_oprend_i,
	mem_oprend_i,
	
	// pc_jmp
	pc_jmp_o,
	jmp_o
	
	
);

input 				clk;
input				rst;
input	[31:0]		pc_i;
input	[31:0]		inst_i;
output	[31:0]		oprend1_o;
output	[31:0]		oprend2_o;
output	[63:0]		imm_o;
output	[4 :0]		rs1_o;
output	[4 :0]		rs2_o;
output	[4 :0]		rd_o;
input	[4 :0]		rd_i;
input	[31:0]		wdata_i;
input				regwrite_i;
input				stall_i;
output				if_flush_o;
output				branch_o;
output				memread_o;
output				memtoreg_o;
output	[3 :0]		alu_ctrl_o;
output				alusrc_o;
output				memwrite_o;
output				regwrite_o;
output	[31:0]		pc_branch_o;
output				branch_taken_o;
input				branch_pred_i;
input	[4 :0]		ex_rd_i;
input	[4 :0]		mem_rd_i;
input				ex_regwrite_i;
input				mem_regwrite_i;
input	[31:0]		ex_oprend_i;
input	[31:0]		mem_oprend_i;
output	[31:0]		pc_jmp_o;
output				jmp_o;

wire 				clk;
wire				rst;
wire	[31:0]		pc_i;
wire	[31:0]		inst_i;
reg		[31:0]		oprend1_o;
reg		[31:0]		oprend2_o;
reg		[63:0]		imm_o;
reg		[4 :0]		rs1_o;
reg		[4 :0]		rs2_o;
reg		[4 :0]		rd_o;
wire	[4 :0]		rd_i;
wire	[31:0]		wdata_i;
wire				regwrite_i;
wire				stall_i;
wire				if_flush_o;
wire				branch_o;
reg					memread_o;
reg					memtoreg_o;
reg					memwrite_o;
reg		[3 :0]		alu_ctrl_o;
reg					alusrc_o;
reg					regwrite_o;
wire	[31:0]		pc_branch_o;
wire				branch_taken_o;
wire				branch_pred_i;
wire	[4 :0]		ex_rd_i;
wire	[4 :0]		mem_rd_i;
wire				ex_regwrite_i;
wire				mem_regwrite_i;
wire	[31:0]		ex_oprend_i;
wire	[31:0]		mem_oprend_i;
wire	[31:0]		pc_jmp_o;
wire				jmp_o;



wire	[6 :0]		opcode;
wire	[4 :0]		rs1_w;
wire	[4 :0]		rs2_w;
wire	[4 :0]		rd_w;
wire	[2 :0]		func3;
wire	[6 :0]		func7;
wire 	[3 :0]		alu_func_w;

wire	[31:0]		oprend1_w;
wire	[31:0]		oprend2_w;
wire	[63:0]		imm_w;

wire				jal_w;
wire				memread_w;
wire				memtoreg_w;
wire	[1 :0]		aluop_w;
wire				memwrite_w;
wire				alusrc_w;
wire				regwrite_w;
wire	[3 :0]		alu_ctrl_w;

wire	[31:0]		rs1_data_w;
wire	[31:0]		rs2_data_w;

reg		[31:0]		fwd_data1_w;
reg		[31:0]		fwd_data2_w;
// compare
wire				zero;
wire				less;
wire	[1:0]		forward1_w;
wire	[1:0]		forward2_w;

reg		[31:0]		pc_i_neg_r;
reg					jal_neg_r;
reg		[4 :0]		rs1_neg_r;
reg		[4 :0]		rs2_neg_r;


wire				branch_op;

// decode inst
assign	opcode	=	inst_i[6 :0 ];
assign	rs1_w	=	inst_i[19:15];
assign	rs2_w	=	inst_i[24:20];
assign	rd_w	=	inst_i[11:7 ];
assign	func3	=	inst_i[14:12];
assign	func7	=	inst_i[31:25];
assign	alu_func_w	=	{func7[5], func3};
// decode inst

// branch

assign branch_o		=	branch_op & (branch_taken_o ^ branch_pred_i);
assign pc_branch_o	=	branch_taken_o ? ({imm_w[30:0],1'b0} + pc_i) : (pc_i + 4);
// branch


// jump
assign pc_jmp_o	=	{imm_w[30:0],1'b0} + pc_i;
assign jmp_o	=	jal_w;
// jump

assign if_flush_o	=	branch_o | jmp_o;


// fwd_data1_w
always@(*) begin
	case(forward1_w)
		2'b00: begin
			fwd_data1_w = rs1_data_w;
		end
		2'b01: begin
			fwd_data1_w = ex_oprend_i;
		end
		2'b10: begin
			fwd_data1_w = mem_oprend_i;
		end
		default: begin
			fwd_data1_w = 0;
		end
	endcase
end

// fwd_data2_w
always@(*) begin
	case(forward2_w)
		2'b00: begin
			fwd_data2_w = rs2_data_w;
		end
		2'b01: begin
			fwd_data2_w = ex_oprend_i;
		end
		2'b10: begin
			fwd_data2_w = mem_oprend_i;
		end
		default: begin
			fwd_data2_w = 0;
		end
	endcase
end

forwarding_unit x_forwarding_unit(
	.ex_rd_i(ex_rd_i),
	.ex_regwrite_i(ex_regwrite_i),
	.mem_rd_i(mem_rd_i),
	.mem_regwrite_i(mem_regwrite_i),
	.rs1_i(rs1_neg_r),
	.rs2_i(rs2_neg_r),
	.forward1_o(forward1_w),
	.forward2_o(forward2_w)
);

assign oprend1_w	=	jal_neg_r ? pc_i_neg_r : rs1_data_w;
assign oprend2_w	=	jal_neg_r ? 32'd4 : rs2_data_w;
reg_file x_reg_file(
	.clk(clk),
	.rst(rst),
	.en_write(regwrite_i),
	.raddr_1(rs1_neg_r),
	.raddr_2(rs2_neg_r),
	.waddr(rd_i),
	.wdata(wdata_i),
	.rdata_1(rs1_data_w),
	.rdata_2(rs2_data_w)
);

data_compare x_data_compare(
	.din_1(fwd_data1_w),
	.din_2(fwd_data2_w),
	.zero(zero),
	.less(less)
);


imm_gen x_imm_gen(
	.inst_i(inst_i),
	.imm_o(imm_w)
);


wire		flush_w;
core_control x_control(
	.inst_i(opcode),
	.stall_i(stall_i),
	.branch(branch_taken_o),
	.branch_op(branch_op),
	.memread(memread_w),
	.memtoreg(memtoreg_w),
	.jal(jal_w),
	.aluop(aluop_w),
	.memwrite(memwrite_w),
	.alusrc(alusrc_w),
	.regwrite(regwrite_w),
	
	.func(func3),
	.zero(zero),
	.less(less),
	.if_flush(flush_w)
);


alu_ctrl x_alu_ctrl(
	.alu_op(aluop_w),
	.func_op(alu_func_w),
	.alu_ctrl_o(alu_ctrl_w)
);

// output
always@(posedge clk or posedge rst) begin
	if(rst) begin
		// oprend1_o 	<=	0;
		// oprend2_o 	<=	0;
		rs1_o		<=	0;
		rs2_o		<=	0;
		rd_o		<=	0;
		imm_o		<=	0;
		alu_ctrl_o	<=	0;
		memread_o	<= 	0;
		memtoreg_o	<=	0;
		memwrite_o	<=	0;
		alusrc_o	<=	0;
		regwrite_o	<=	0;
	end
	else begin
		// oprend1_o	<=	oprend1_w;
		// oprend2_o	<=	oprend2_w;
		rs1_o		<=	rs1_w;
		rs2_o		<=	rs2_w;
		rd_o		<=	rd_w;
		imm_o		<=	imm_w;
		memread_o	<=	memread_w;  // MEM
		memtoreg_o	<=	memtoreg_w; // WB
		alu_ctrl_o	<=	alu_ctrl_w; // EX
		memwrite_o	<=	memwrite_w; // MEM
		alusrc_o	<=	alusrc_w;	// Fowarding
		regwrite_o	<=	regwrite_w; // WB
	end
end // output


// negedge clk for data hazard handle
always@(negedge clk or posedge rst) begin
	if(rst) begin
		pc_i_neg_r	<=	0;
		jal_neg_r	<=	0;
		rs1_neg_r	<=	0;
		rs2_neg_r	<=	0;
		oprend1_o 	<=	0;
		oprend2_o 	<=	0;
	end
	else begin
		pc_i_neg_r	<=	pc_i;
		jal_neg_r	<=	jal_w;
		rs1_neg_r	<=	rs1_w;
		rs2_neg_r	<=	rs2_w;
		oprend1_o	<=	oprend1_w;
		oprend2_o	<=	oprend2_w;
	end
end // negedge clk
endmodule
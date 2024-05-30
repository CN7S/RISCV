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

//  instance your module  below

reg [31:0] pc_r;

wire ctrl_branch_w;
wire ctrl_memread_w;
wire ctrl_memtoreg_w;
wire [1:0] ctrl_aluop_w;
wire ctrl_memwrite_w;
wire [1:0] ctrl_alusrc_w;
wire ctrl_regwrite_w;
wire [31:0] op1_data_w;
wire [31:0] op2_data_w;
reg [31:0] rd_data_w;
wire [63:0] imm_op_w;
reg [31:0] alu_op_1_w;
reg [31:0] alu_op_2_w;
wire alu_zero_w;
wire [31:0] alu_rslt_w;
wire [3:0] inst_func_w;
wire [3:0] alu_ctrl_w;
wire pc_branch_w;
wire [63:0] imm_branch_w;


core_control x_control(
	.inst_i(inst_i[6:0]),
	.branch(ctrl_branch_w),
	.memread(ctrl_memread_w),
	.memtoreg(ctrl_memtoreg_w),
	.jal(pc_jal_w),
	.jalr(pc_jalr_w),
	.aluop(ctrl_aluop_w),
	.memwrite(ctrl_memwrite_w),
	.alusrc(ctrl_alusrc_w),
	.regwrite(ctrl_regwrite_w)
);

reg_file x_reg_file(
	.clk(clk),
	.rst(rst),
	.en_write(ctrl_regwrite_w),
	.raddr_1(inst_i[19:15]),
	.raddr_2(inst_i[24:20]),
	.waddr(inst_i[11:7]),
	.wdata(rd_data_w),
	.rdata_1(op1_data_w),
	.rdata_2(op2_data_w)
);

imm_gen x_imm_gen(
	.inst_i(inst_i),
	.imm_o(imm_op_w)
);

core_alu x_alu(
	.ctrl(alu_ctrl_w),
	.oprend_1(alu_op_1_w),
	.oprend_2(alu_op_2_w),
	.zero(alu_zero_w),
	.alu_result(alu_rslt_w)
);

assign inst_func_w = {inst_i[30], inst_i[14:12]};
alu_ctrl x_alu_ctrl(
	.alu_op(ctrl_aluop_w),
	.func_op(inst_func_w),
	.alu_ctrl_o(alu_ctrl_w)
);

branch_ctrl x_branch_ctrl(
	.branch(ctrl_branch_w),
	.zero(alu_zero_w),
	.sign(alu_rslt_w[31]),
	.func(inst_i[14:12]),
	.branch_o(pc_branch_w)
);


// alu_op
always@(*) begin
	if(ctrl_alusrc_w == 2'b00) begin
		alu_op_1_w = op1_data_w;
		alu_op_2_w = op2_data_w;
	end
	else if(ctrl_alusrc_w == 2'b01)begin
		alu_op_1_w = op1_data_w;
		alu_op_2_w = imm_op_w[31:0];
	end
	else if(ctrl_alusrc_w == 2'b10)begin
		alu_op_1_w = pc_r;
		alu_op_2_w = 32'd4;
	end
	else begin
		alu_op_1_w = 32'b0;
		alu_op_2_w = 32'b0;
	end
end
// alu_op

// write back
always@(*) begin
	if(!ctrl_memtoreg_w) begin
		rd_data_w = alu_rslt_w;
	end
	else begin
		rd_data_w = data_i;
	end
end
// write back

// PC
assign imm_branch_w = {imm_op_w[62:0], 1'b0};
always@(posedge clk or posedge rst) begin
	if(rst) begin
		pc_r <= 32'b0;
	end
	else if(pc_branch_w) begin
		pc_r <= $signed(pc_r) + $signed(imm_branch_w);
	end
	else if(pc_jal_w) begin
		pc_r <= $signed(pc_r) + $signed(imm_branch_w);
	end
	else if(pc_jalr_w) begin
		pc_r <= $signed(imm_branch_w);
	end
	else begin
		pc_r <= $signed(pc_r) + $signed(4);
	end
end
// PC


// Inst_mem
assign inst_addr_o = pc_r;
assign inst_ce_o = 1'b1; // ????


// Data_mem
assign data_ce_o = ctrl_memread_w | ctrl_memwrite_w;
assign data_we_o = ctrl_memwrite_w;
assign data_addr_o = alu_rslt_w;
assign data_o = op2_data_w;


endmodule
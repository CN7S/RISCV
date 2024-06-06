`include "INST_OPCODE.v"
module core_control(
	input wire [6:0] inst_i,
	input wire		stall_i,
	output wire branch,
	output wire branch_op,
	output reg jal,
	output reg memread,
	output reg memtoreg,
	output reg [1:0] aluop,
	output reg memwrite,
	output reg alusrc,
	output reg regwrite,
	input wire [2:0] func,
	input wire zero,
	input wire less,
	output reg if_flush
);

// branch
wire branch_inst;
assign branch_inst = inst_i == `SBTYPE_INST_OPCODE;
assign branch_op = branch_inst;


branch_ctrl x_branch_ctrl(
	.branch(branch_inst),
	.zero(zero),
	.less(less),
	.func(func),
	.branch_o(branch)
);
// branch

// if_flush
always@(*) begin
	if(stall_i)	if_flush = 1'b0;
	else if(branch | jal) if_flush = 1'b1;
	else if_flush = 1'b0;
end // if_flush

// jal
always@(*) begin
	if(inst_i == `JTYPE_INST_OPCODE) jal = 1'b1;
	else jal = 1'b0;
end // jal

// memread
always@(*) begin
	if(stall_i)	memread = 1'b0;
	else if(inst_i == `LOAD_INST_OPCODE) memread = 1'b1;
	else memread = 1'b0;
end// memread

// memwrite
always@(*) begin
	if(stall_i)	memwrite = 1'b0;
	else if(inst_i == `STYPE_INST_OPCODE) memwrite = 1'b1;
	else memwrite = 1'b0;
end // memwrite

// aluop
always@(*) begin
	if(stall_i)	aluop = 2'b0;
	else if(inst_i == `RTYPE_INST_OPCODE) aluop = `R_ALUOP;
	else if(inst_i == `SBTYPE_INST_OPCODE) aluop = `B_ALUOP;
	else if(inst_i == `LOAD_INST_OPCODE) aluop = `LSJ_ALUOP;
	else if(inst_i == `STYPE_INST_OPCODE) aluop = `LSJ_ALUOP;
	else if(inst_i == `JALR_INST_OPCODE) aluop = `LSJ_ALUOP;
	else if(inst_i == `JTYPE_INST_OPCODE) aluop = `LSJ_ALUOP;
	else if(inst_i == `ITYPE_INST_OPCODE) aluop = `I_ALUOP;
end // aluop

// alusrc
always@(*) begin
	if(stall_i)	alusrc = 1'b0;
	else if(inst_i == `RTYPE_INST_OPCODE) alusrc = 1'b0;
	else if(inst_i == `LOAD_INST_OPCODE) alusrc = 1'b1;
	else if(inst_i == `STYPE_INST_OPCODE) alusrc = 1'b1;
	else if(inst_i == `ITYPE_INST_OPCODE) alusrc = 1'b1;
	else if(inst_i == `SBTYPE_INST_OPCODE) alusrc = 1'b0;
	else alusrc = 1'b0;
end
// alusrc

// memtoreg
always@(*) begin
	if(stall_i)	memtoreg = 1'b0;
	else if(inst_i == `LOAD_INST_OPCODE) memtoreg = 1'b1;
	else memtoreg = 1'b0;
end
// memtoreg

// regwrite
always@(*) begin
	if(stall_i)	regwrite = 1'b0;
	else if(inst_i == `RTYPE_INST_OPCODE) regwrite = 1'b1;
	else if(inst_i == `ITYPE_INST_OPCODE) regwrite = 1'b1;
	else if(inst_i == `LOAD_INST_OPCODE) regwrite = 1'b1;
	else if(inst_i == `JALR_INST_OPCODE) regwrite = 1'b1;
	else if(inst_i == `JTYPE_INST_OPCODE) regwrite = 1'b1;
	else regwrite = 1'b0;
end
// regwrite


endmodule
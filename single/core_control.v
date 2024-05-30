`include "INST_OPCODE.v"
module core_control(
	input wire [6:0] inst_i,
	output reg branch,
	output reg jal,
	output reg jalr,
	output reg memread,
	output reg memtoreg,
	output reg [1:0] aluop,
	output reg memwrite,
	output reg [1:0] alusrc,
	output reg regwrite
);


// branch
always@(*) begin
	if(inst_i == `SBTYPE_INST_OPCODE) branch = 1'b1;
	else branch = 1'b0;
end // branch

// jal
always@(*) begin
	if(inst_i == `JTYPE_INST_OPCODE) jal = 1'b1;
	else jal = 1'b0;
end // jal

// jalr
always@(*) begin
	if(inst_i == `JALR_INST_OPCODE) jalr = 1'b1;
	else jalr = 1'b0;
end // jalr

// memread
always@(*) begin
	if(inst_i == `LOAD_INST_OPCODE) memread = 1'b1;
	else memread = 1'b0;
end// memread

// memwrite
always@(*) begin
	if(inst_i == `STYPE_INST_OPCODE) memwrite = 1'b1;
	else memwrite = 1'b0;
end // memwrite

// aluop
always@(*) begin
	if(inst_i == `RTYPE_INST_OPCODE) aluop = `R_ALUOP;
	else if(inst_i == `SBTYPE_INST_OPCODE) aluop = `B_ALUOP;
	else if(inst_i == `LOAD_INST_OPCODE) aluop = `LSJ_ALUOP;
	else if(inst_i == `STYPE_INST_OPCODE) aluop = `LSJ_ALUOP;
	else if(inst_i == `JALR_INST_OPCODE) aluop = `LSJ_ALUOP;
	else if(inst_i == `JTYPE_INST_OPCODE) aluop = `LSJ_ALUOP;
	else if(inst_i == `ITYPE_INST_OPCODE) aluop = `I_ALUOP;
end // aluop

// alusrc
always@(*) begin
	if(inst_i == `RTYPE_INST_OPCODE) alusrc = 2'b0;
	else if(inst_i == `LOAD_INST_OPCODE) alusrc = 2'b1;
	else if(inst_i == `STYPE_INST_OPCODE) alusrc = 2'b1;
	else if(inst_i == `ITYPE_INST_OPCODE) alusrc = 2'b1;
	else if(inst_i == `SBTYPE_INST_OPCODE) alusrc = 2'b0;
	else if(inst_i == `JALR_INST_OPCODE) alusrc = 2'b10;
	else if(inst_i == `JTYPE_INST_OPCODE) alusrc = 2'b10;
	else alusrc = 2'b0;
end
// alusrc

// memtoreg
always@(*) begin
	if(inst_i == `LOAD_INST_OPCODE) memtoreg = 1'b1;
	else memtoreg = 1'b0;
end
// memtoreg

// regwrite
always@(*) begin
	if(inst_i == `RTYPE_INST_OPCODE) regwrite = 1'b1;
	else if(inst_i == `ITYPE_INST_OPCODE) regwrite = 1'b1;
	else if(inst_i == `LOAD_INST_OPCODE) regwrite = 1'b1;
	else if(inst_i == `JALR_INST_OPCODE) regwrite = 1'b1;
	else if(inst_i == `JTYPE_INST_OPCODE) regwrite = 1'b1;
	else regwrite = 1'b0;
end
// regwrite


endmodule
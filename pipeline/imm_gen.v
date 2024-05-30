`include "INST_OPCODE.v"
module imm_gen(
	input wire [31:0] inst_i,
	output reg [63:0] imm_o
);

wire [63:0] imm_Itype_w;
wire [63:0] imm_Stype_w;
wire [63:0] imm_SBtype_w;
wire [63:0] imm_Utype_w;
wire [63:0] imm_Jtype_w;
wire [6:0] opcode_w;
reg itype_w;
reg stype_w;
reg sbtype_w;
reg utype_w;
reg jtype_w;


assign opcode_w = inst_i[6:0];

assign imm_Itype_w = $signed(inst_i[31:20]);
assign imm_Stype_w = $signed({inst_i[31:25], inst_i[11:7]});
assign imm_SBtype_w = $signed({inst_i[31], 
							inst_i[7], 
							inst_i[30:25], 
							inst_i[11:8]});
							
assign imm_Jtype_w = $signed({inst_i[31],
							inst_i[19:12],
							inst_i[20],
							inst_i[30:21]});
							
assign imm_Utype_w = $signed({inst_i[31:12], 12'b0});


// itype
always@(*) begin
	if(opcode_w == `ITYPE_INST_OPCODE) itype_w = 1'b1;
	else if(opcode_w == `LOAD_INST_OPCODE) itype_w = 1'b1;
	else if(opcode_w == `JALR_INST_OPCODE) itype_w = 1'b1;
	else	itype_w = 1'b0;
end // itype


// stype
always@(*) begin
	if(opcode_w == `STYPE_INST_OPCODE) stype_w = 1'b1;
	else	stype_w = 1'b0;
end // stype

// sbtype
always@(*) begin
	if(opcode_w == `SBTYPE_INST_OPCODE) sbtype_w = 1'b1;
	else	sbtype_w = 1'b0;
end // sbtype

// utype
always@(*) begin
	if(opcode_w == `UTYPE_INST_OPCODE) utype_w = 1'b1;
	else	utype_w = 1'b0;
end // utype

// jtype
always@(*) begin
	if(opcode_w == `JTYPE_INST_OPCODE) jtype_w = 1'b1;
	else	jtype_w = 1'b0;
end // jtype

// imm_o
always@(*) begin
	if(itype_w) begin
		imm_o = imm_Itype_w;
	end
	else if(sbtype_w) begin
		imm_o = imm_SBtype_w;
	end
	else if(stype_w) begin
		imm_o = imm_Stype_w;
	end
	else if(jtype_w) begin
		imm_o = imm_Jtype_w;
	end
	else if(utype_w) begin
		imm_o = imm_Utype_w;
	end
	else begin
		imm_o = 64'b0;
	end
end // imm_o

endmodule
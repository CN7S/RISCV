// add, sub, and, or, xor, sll, srl
`include "INST_OPCODE.v"
module core_alu(
	input wire [3:0] ctrl,
	input wire [31:0] oprend_1,
	input wire [31:0] oprend_2,
	output reg zero,
	output reg [31:0] alu_result
);

wire [31:0] alu_add;
wire [31:0] alu_sub;
wire [31:0] alu_and;
wire [31:0] alu_or;
wire [31:0] alu_xor;
wire [31:0] alu_sll;
wire [31:0] alu_srl;

// add
assign alu_add = $signed(oprend_1) + $signed(oprend_2);
// sub
assign alu_sub = $signed(oprend_1) - $signed(oprend_2);
// and
assign alu_and = oprend_1 & oprend_2;
// or
assign alu_or = oprend_1 | oprend_2;
// xor
assign alu_xor = oprend_1 ^ oprend_2;
// sll

barrel_sll x_sll(
	.shamt(oprend_2[4:0]),
	.data_i(oprend_1),
	.data_o(alu_sll)
);

// assign alu_sll = oprend_1; // {oprend_1[31-oprend_2:0], {oprend_2{1'b0}}};
// srl

barrel_srl x_srl(
	.shamt(oprend_2[4:0]),
	.data_i(oprend_1),
	.data_o(alu_srl)
);
// assign alu_srl = oprend_1; // {{oprend_2{1'b0}}, oprend_1[31:oprend_2]};


// zero
always@(*) begin
	if(ctrl == `ALU_SUB_OPCODE && !alu_sub) zero = 1'b1;
	else zero = 1'b0;
end // zero

always@(*) begin
	if(ctrl == `ALU_ADD_OPCODE) alu_result = alu_add;
	else if(ctrl == `ALU_SUB_OPCODE) alu_result = alu_sub;
	else if(ctrl == `ALU_AND_OPCODE) alu_result = alu_and;
	else if(ctrl == `ALU_OR_OPCODE) alu_result = alu_or;
	else if(ctrl == `ALU_XOR_OPCODE) alu_result = alu_xor;
	else if(ctrl == `ALU_SLL_OPCODE) alu_result = alu_sll;
	else if(ctrl == `ALU_SRL_OPCODE) alu_result = alu_srl;
	else alu_result = 32'b0;
end

endmodule

module barrel_sll(
	input wire [4:0] shamt,
	input wire [31:0] data_i,
	output wire [31:0] data_o
);

wire [31:0] data_sll_1;
wire [31:0] data_sll_2;
wire [31:0] data_sll_4;
wire [31:0] data_sll_8;
wire [31:0] data_sll_16;

assign data_sll_1 = !shamt[0] ? data_i : (data_i << 1);
assign data_sll_2 = !shamt[1] ? data_sll_1 : (data_sll_1 << 2);
assign data_sll_4 = !shamt[2] ? data_sll_2 : (data_sll_2 << 4);
assign data_sll_8 = !shamt[3] ? data_sll_4 : (data_sll_4 << 8);
assign data_sll_16 = !shamt[4] ? data_sll_8 : (data_sll_8 << 16);
assign data_o = data_sll_16;
endmodule


module barrel_srl(
	input wire [4:0] shamt,
	input wire [31:0] data_i,
	output wire [31:0] data_o
);

wire [31:0] data_srl_1;
wire [31:0] data_srl_2;
wire [31:0] data_srl_4;
wire [31:0] data_srl_8;
wire [31:0] data_srl_16;

assign data_srl_1 = !shamt[0] ? data_i : (data_i >> 1);
assign data_srl_2 = !shamt[1] ? data_srl_1 : (data_srl_1 >> 2);
assign data_srl_4 = !shamt[2] ? data_srl_2 : (data_srl_2 >> 4);
assign data_srl_8 = !shamt[3] ? data_srl_4 : (data_srl_4 >> 8);
assign data_srl_16 = !shamt[4] ? data_srl_8 : (data_srl_8 >> 16);
assign data_o = data_srl_16;

endmodule
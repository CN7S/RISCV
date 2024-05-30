`include "INST_OPCODE.v"
module alu_ctrl(
	input wire [1:0] alu_op,
	input wire [3:0] func_op,
	output reg [3:0] alu_ctrl_o
);

always@(*) begin
	if(alu_op == `LSJ_ALUOP) alu_ctrl_o = `ALU_ADD_OPCODE;
	else if(alu_op == `B_ALUOP) alu_ctrl_o = `ALU_SUB_OPCODE;
	else if(alu_op == `R_ALUOP) begin
		if(func_op == `FUNC_ADD) alu_ctrl_o = `ALU_ADD_OPCODE;
		else if(func_op == `FUNC_SUB) alu_ctrl_o = `ALU_SUB_OPCODE;
		else if(func_op == `FUNC_SLL) alu_ctrl_o = `ALU_SLL_OPCODE;
		else if(func_op == `FUNC_SRL) alu_ctrl_o = `ALU_SRL_OPCODE;
		else if(func_op == `FUNC_AND) alu_ctrl_o = `ALU_AND_OPCODE;
		else if(func_op == `FUNC_OR) alu_ctrl_o = `ALU_OR_OPCODE;
		else if(func_op == `FUNC_XOR) alu_ctrl_o = `ALU_XOR_OPCODE;
		else alu_ctrl_o = 4'b0;
	end
	else if(alu_op == `I_ALUOP) begin
		if(func_op[2:0] == `FUNC_ADDI) alu_ctrl_o = `ALU_ADD_OPCODE;
		else if(func_op[2:0] == `FUNC_ANDI) alu_ctrl_o = `ALU_AND_OPCODE;
		else if(func_op[2:0] == `FUNC_ORI) alu_ctrl_o = `ALU_OR_OPCODE;
		else if(func_op[2:0] == `FUNC_XORI) alu_ctrl_o = `ALU_XOR_OPCODE;
		else alu_ctrl_o = 4'b0;
	end
	else alu_ctrl_o = 4'b0;
end

endmodule
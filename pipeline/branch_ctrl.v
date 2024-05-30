`include "INST_OPCODE.v"
module branch_ctrl(
	input wire branch,
	input wire zero,
	input wire less,
	input wire [2:0] func,
	output reg branch_o
);

always@(*) begin
	if(branch && func == `FUNC_BEQ && zero) branch_o = 1'b1;
	else if(branch && func == `FUNC_BLT && less) branch_o = 1'b1;
	else branch_o = 1'b0;
end

endmodule
`include "INST_OPCODE.v"
module branch_ctrl(
	input wire branch,
	input wire zero,
	input wire sign,
	input wire [2:0] func,
	output reg branch_o
);

always@(*) begin
	if(func == `FUNC_BEQ && zero) branch_o = 1'b1;
	else if(func == `FUNC_BLT && sign) branch_o = 1'b1;
	else branch_o = 1'b0;
end

endmodule
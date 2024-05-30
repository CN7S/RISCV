`include "INST_OPCODE.v"
module inst_fetch(
	clk,
	rst,
	pc_stall,
	if_stall,
	if_flush,
	branch,
	pc_branch_i,
	jmp,
	pc_jmp_i,
	inst_i,
	inst_addr_o,
	inst_ce_o,
	inst_o,
	pc_o
);

input 			clk;
input 			rst;
input 			pc_stall;
input 			if_stall;
input			if_flush;
input			branch;
input	[31:0]	pc_branch_i;
input			jmp;
input	[31:0]	pc_jmp_i;
input	[31:0]	inst_i;
output	[31:0]	inst_addr_o;
output			inst_ce_o;
output 	[31:0]	inst_o;
output 	[31:0]	pc_o;


wire 			clk;
wire			rst;
wire			pc_stall;
wire			if_stall;
wire			if_flush;
wire			branch;
wire	[31:0]	pc_branch_i;
wire	[31:0]	inst_i;
wire	[31:0]	inst_addr_o;
wire			inst_ce_o;
reg		[31:0]	inst_o;
reg		[31:0]	pc_o;


reg 	[31:0]	pc_r;
wire 	[31:0]	next_pc_w;

assign next_pc_w = jmp ? pc_jmp_i : (branch ? pc_branch_i : (pc_r + 4));

// pc_r
always@(posedge clk or posedge rst) begin
	if(rst) begin
		pc_r <= 32'b0;
	end
	else if(pc_stall) begin
		pc_r <= pc_r;
	end
	else begin
		pc_r <= next_pc_w;
	end
end // pc_r

// inst_o
always@(posedge clk or posedge rst) begin
	if(rst) begin
		inst_o <= 32'b0;
	end
	else if(if_stall) begin
		inst_o <= inst_o;
	end
	else if(if_flush) begin
		inst_o <= `INST_FLUSH;
	end
	else begin
		inst_o <= inst_i;
	end
end //inst_o


// inst_mem
assign inst_addr_o 	= 	pc_r;
assign inst_ce_o 	= 	1'b1;
// inst_mem

// pc_o
always@(posedge clk or posedge rst) begin
	if(rst) begin
		pc_o <= 32'b0;
	end
	else if(if_stall) begin
		pc_o <= pc_o;
	end
	else if(if_flush) begin
		pc_o <= 32'b0;
	end
	else begin
		pc_o <= pc_r;
	end
end // pc_o


endmodule
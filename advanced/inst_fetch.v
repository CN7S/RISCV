`include "INST_OPCODE.v"
module inst_fetch(
	clk,
	rst,
	pc_stall,
	if_stall,
	if_flush,
	branch,
	branch_taken,
	pc_branch_i,
	jmp,
	pc_jmp_i,
	inst_i,
	inst_addr_o,
	inst_ce_o,
	inst_o,
	branch_pred_o,
	pc_o
);

input 			clk;
input 			rst;
input 			pc_stall;
input 			if_stall;
input			if_flush;
input			branch;
input			branch_taken;
input	[31:0]	pc_branch_i;
input			jmp;
input	[31:0]	pc_jmp_i;
input	[31:0]	inst_i;
output	[31:0]	inst_addr_o;
output			inst_ce_o;
output 	[31:0]	inst_o;
output			branch_pred_o;
output 	[31:0]	pc_o;


wire 			clk;
wire			rst;
wire			pc_stall;
wire			if_stall;
wire			if_flush;
wire			branch;
wire			branch_taken;
wire	[31:0]	pc_branch_i;
wire	[31:0]	inst_i;
wire	[31:0]	inst_addr_o;
wire			inst_ce_o;
reg		[31:0]	inst_o;
reg				branch_pred_o;
reg		[31:0]	pc_o;


reg 	[31:0]	pc_r;
wire 	[31:0]	next_pc_w;

wire	[63:0]	cache_data;
wire			cache_hit;
wire			branch_pred;
wire	[31:0]	pred_pc;


assign next_pc_w = jmp ? pc_jmp_i : (branch ? pc_branch_i : pred_pc);


// branch predict cache

reg		[63:0]	bcache [0:3]; // 63 T/NT 62:32 addr 31:0 nxt_addr

assign cache_data = bcache[pc_r[3:2]];
assign cache_hit = cache_data[62:35] == pc_r[31:4];
assign branch_pred = cache_hit ? cache_data[63] : 0;
assign pred_pc = branch_pred ? cache_data[31:0] : (pc_r + 4);

// if branch : pc cache maintain

always@(posedge clk or posedge rst) begin
	if(rst) begin
		bcache[0]	<=	0;
		bcache[1]	<=	0;
		bcache[2]	<=	0;
		bcache[3]	<=	0;
	end
	else if(branch) begin
		bcache[pc_o[3:2]] <= {branch_taken, pc_o[31:4], 3'b0, pc_branch_i};
	end
	else begin
		bcache[0]	<=	bcache[0];
		bcache[1]	<=	bcache[1];
		bcache[2]	<=	bcache[2];
		bcache[3]	<=	bcache[3];	
	end
end


// branch_pred_o
always@(posedge clk or posedge rst) begin
	if(rst) begin
		branch_pred_o <= 32'b0;
	end
	else if(if_stall) begin
		branch_pred_o <= branch_pred_o;
	end
	else if(if_flush) begin
		branch_pred_o <= 0;
	end
	else begin
		branch_pred_o <= branch_pred;
	end
end // branch_pred_o

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
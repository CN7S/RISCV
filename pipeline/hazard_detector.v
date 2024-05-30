`include "INST_OPCODE.v"
module hazard_detector(
	branch_opcode,
	id_regwrite_i, 
	id_memread_i,
	rs1_i,
	rs2_i,
	id_rd_i,
	ex_rd_i,
	ex_regwrite_i,
	mem_rd_i,
	mem_regwrite_i,
	stall_o
);
input	[6:0]	branch_opcode;
input			id_regwrite_i;
input			id_memread_i;
input	[4:0]	rs1_i;
input	[4:0]	rs2_i;
input	[4:0]	id_rd_i;
input	[4:0]	ex_rd_i;
input			ex_regwrite_i;
input	[4:0]	mem_rd_i;
input			mem_regwrite_i;
output			stall_o;


wire	[6:0]	branch_opcode;
wire			id_regwrite_i;
wire			id_memread_i;
wire	[4:0]	rs1_i;
wire	[4:0]	rs2_i;
wire	[4:0]	id_rd_i;
wire	[4:0]	ex_rd_i;
wire			ex_regwrite_i;
wire	[4:0]	mem_rd_i;
wire			mem_regwrite_i;
wire			stall_o;


wire			branch;
wire			rs_hazard;
wire			load_hazard;

assign branch = branch_opcode == `SBTYPE_OPCODE;
assign rs_hazard  = rs1_i == id_rd_i | rs2_i == id_rd_i;
assign load_hazard = id_memread_i & id_regwrite_i;
assign branch_id_hazard = id_regwrite_i & (rs1_i == id_rd_i | rs2_i == id_rd_i);
assign branch_ex_hazard = ex_regwrite_i & (rs1_i == ex_rd_i | rs2_i == ex_rd_i);
assign branch_mem_hazard = mem_regwrite_i & (rs1_i == mem_rd_i | rs2_i == mem_rd_i);
assign branch_hazard = branch_ex_hazard | branch_id_hazard | branch_mem_hazard;
assign stall_o = branch ? branch_hazard : (rs_hazard & load_hazard);


endmodule
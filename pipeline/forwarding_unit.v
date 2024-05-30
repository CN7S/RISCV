module forwarding_unit(
	ex_rd_i,
	ex_regwrite_i,
	mem_rd_i,
	mem_regwrite_i,
	rs1_i,
	rs2_i,
	forward1_o,
	forward2_o
);

input	[4:0]	ex_rd_i;
input	[4:0]	mem_rd_i;
input			ex_regwrite_i;
input			mem_regwrite_i;
input	[4:0]	rs1_i;
input	[4:0]	rs2_i;
output	[1:0]	forward1_o;
output	[1:0]	forward2_o;
wire	[4:0]	ex_rd_i;
wire	[4:0]	mem_rd_i;
wire			ex_regwrite_i;
wire			mem_regwrite_i;
wire	[4:0]	rs1_i;
wire	[4:0]	rs2_i;
reg		[1:0]	forward1_o;
reg		[1:0]	forward2_o;


// forward1_o
always@(*) begin
	if(rs1_i != 0 && rs1_i == ex_rd_i && ex_regwrite_i) forward1_o = 2'b01;
	else if(rs1_i != 0 && rs1_i == mem_rd_i && mem_regwrite_i) forward1_o = 2'b10;
	else	forward1_o = 0;
end

// forward2_o
always@(*) begin
	if(rs2_i != 0 && rs2_i == ex_rd_i && ex_regwrite_i) forward2_o = 2'b01;
	else if(rs2_i != 0 && rs2_i == mem_rd_i && mem_regwrite_i) forward2_o = 2'b10;
	else	forward2_o = 0;
end
endmodule
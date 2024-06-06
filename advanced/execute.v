module execute(
	clk,
	rst,
	oprend1_i,
	oprend2_i,
	ex_oprend_i,
	mem_oprend_i,
	mem_rd_i,
	mem_regwrite_i,
	imm_i,
	rs1_i,
	rs2_i,
	rd_o,
	rd_i,
	alu_rst_o,
	mem_wdata_o,
	// control io
	memread_i,  // MEM
	memtoreg_i, // WB
	memwrite_i, // MEM
	regwrite_i, // WB
	alusrc_i,   // EX
	memread_o,
	memtoreg_o,
	memwrite_o,
	regwrite_o,
	
	// aluop
	alu_ctrl_i  // EX

);
input			clk;
input			rst;
input	[31:0]	oprend1_i;
input	[31:0]	oprend2_i;
input	[31:0]	ex_oprend_i;
input	[31:0]	mem_oprend_i;
input	[4 :0]	mem_rd_i;
input			mem_regwrite_i;
input	[63:0]	imm_i;
input	[4 :0]	rs1_i;
input	[4 :0]	rs2_i;
output	[4 :0]	rd_o;
input	[4 :0]	rd_i;
output	[31:0]	alu_rst_o;
output	[31:0]	mem_wdata_o;
input			memread_i;
input			memtoreg_i;
input			memwrite_i;
input			regwrite_i;
input			alusrc_i;
output			memread_o;
output			memtoreg_o;
output			memwrite_o;
output			regwrite_o;
input	[3 :0]	alu_ctrl_i;


wire			clk;
wire			rst;
wire	[31:0]	oprend1_i;
wire	[31:0]	oprend2_i;
wire	[31:0]	ex_oprend_i;
wire	[31:0]	mem_oprend_i;
wire	[4 :0]	mem_rd_i;
wire			mem_regwrite_i;
wire	[63:0]	imm_i;
wire	[4 :0]	rs1_i;
wire	[4 :0]	rs2_i;
reg		[4 :0]	rd_o;
wire	[4 :0]	rd_i;
reg		[31:0]	alu_rst_o;
reg		[31:0]	mem_wdata_o;
wire			memread_i;
wire			memtoreg_i;
wire			memwrite_i;
wire			regwrite_i;
wire			alusrc_i;
reg				memread_o;
reg				memtoreg_o;
reg				memwrite_o;
reg				regwrite_o;
wire	[3 :0]	alu_ctrl_i;

reg		[31:0]	alu_op_1_w;
reg		[31:0]	alu_op_2_w;
reg		[31:0]	alu_oprend2_w;
wire	[31:0]	alu_rslt_w;
wire	[1:0]	forward1_w;
wire	[1:0]	forward2_w;

forwarding_unit x_forwarding_unit(
	.ex_rd_i(rd_o),
	.ex_regwrite_i(regwrite_o),
	.mem_rd_i(mem_rd_i),
	.mem_regwrite_i(mem_regwrite_i),
	.rs1_i(rs1_i),
	.rs2_i(rs2_i),
	.forward1_o(forward1_w),
	.forward2_o(forward2_w)
);


// alu_op_1_w
always@(*) begin
	case(forward1_w)
		2'b00: begin
			alu_op_1_w = oprend1_i;
		end
		2'b01: begin
			alu_op_1_w = ex_oprend_i;
		end
		2'b10: begin
			alu_op_1_w = mem_oprend_i;
		end
		default: begin
			alu_op_1_w = 0;
		end
	endcase
end

// alu_oprend2_w
always@(*) begin
	case(forward2_w)
		2'b00: begin
			alu_oprend2_w = oprend2_i;
		end
		2'b01: begin
			alu_oprend2_w = ex_oprend_i;
		end
		2'b10: begin
			alu_oprend2_w = mem_oprend_i;
		end
		default: begin
			alu_oprend2_w = 0;
		end
	endcase
end

// alu_op_2_w
always@(*) begin
	if(alusrc_i) 	alu_op_2_w = imm_i[31:0];
	else begin
					alu_op_2_w = alu_oprend2_w;
	end
end

core_alu x_alu(
	.ctrl(alu_ctrl_i),
	.oprend_1(alu_op_1_w),
	.oprend_2(alu_op_2_w),
	.alu_result(alu_rslt_w)
);


always@(posedge clk or posedge rst) begin
	if(rst) begin
		memread_o	<=	0;
		memtoreg_o	<=	0;
		memwrite_o	<=	0;
		regwrite_o	<=	0;
		alu_rst_o	<=	0;
		mem_wdata_o	<=	0;
		rd_o		<=	0;
	end
	else begin
		memread_o	<=	memread_i;
		memtoreg_o	<=	memtoreg_i;
		memwrite_o	<=	memwrite_i;
		regwrite_o	<=	regwrite_i;
		alu_rst_o	<=	alu_rslt_w;
		mem_wdata_o	<=	alu_oprend2_w;
		rd_o		<=	rd_i;
	end
end


endmodule
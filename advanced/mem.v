module mem(
	clk,
	rst,
	rd_o,
	rd_i,
	alu_rst_i,
	mem_wdata_i, 
	
	mem_rdata_o,
	alu_rst_o,
	
	// data_sram_io
	data_i,
	data_we_o,
    data_ce_o,
	data_addr_o,
	data_o,
	
	// control io
	memread_i,  // MEM
	memtoreg_i, // WB
	memwrite_i, // MEM
	regwrite_i, // WB
	
	memtoreg_o, // WB
	regwrite_o	// WB
	
);
input			clk;
input			rst;
input	[31:0]	rd_i;
output	[31:0]	rd_o;
input	[31:0]	alu_rst_i;
input	[31:0]	mem_wdata_i;
output	[31:0]	mem_rdata_o;
output	[31:0]	alu_rst_o;
input	[31:0]	data_i;
output			data_ce_o;
output			data_we_o;
output	[31:0]	data_addr_o;
output	[31:0]	data_o;
input			memread_i;
input			memwrite_i;
input			regwrite_i;
input			memtoreg_i;
output			memtoreg_o;
output			regwrite_o;

wire			clk;
wire			rst;
wire	[4 :0]	rd_i;
reg		[4 :0]	rd_o;
wire	[31:0]	alu_rst_i;
wire	[31:0]	mem_wdata_i;
reg		[31:0]	mem_rdata_o;
reg		[31:0]	alu_rst_o;
wire	[31:0]	data_i;
wire			data_ce_o;
wire			data_we_o;
wire	[31:0]	data_addr_o;
wire	[31:0]	data_o;
wire			memread_i;
wire			memwrite_i;
wire			regwrite_i;
wire			memtoreg_i;
reg				memtoreg_o;
reg				regwrite_o;


wire	[31:0]	alu_rst_w;
wire	[31:0]	mem_rdata_w;
wire	[4 :0]	rd_w;
wire			memtoreg_w;
wire			regwrite_w;


assign	data_we_o 	=	memwrite_i;
assign	data_ce_o 	=	memread_i || memwrite_i;
assign	data_addr_o =	alu_rst_i;
assign	data_o		=	mem_wdata_i;
assign	alu_rst_w	=	alu_rst_i;
assign	mem_rdata_w	=	data_i;
assign	rd_w		=	rd_i;
assign	memtoreg_w	=	memtoreg_i;
assign	regwrite_w	=	regwrite_i;

always@(posedge clk or posedge rst) begin
	if(rst) begin
		memtoreg_o	<=	0;
		regwrite_o	<=	0;
		alu_rst_o	<=	0;
		mem_rdata_o	<=	0;
		rd_o		<=	0;
	end
	else begin
		memtoreg_o	<=	memtoreg_w;
		regwrite_o	<=	regwrite_w;
		rd_o		<=	rd_w;
		alu_rst_o	<=	alu_rst_w;
		mem_rdata_o	<=	mem_rdata_w;
	end
end


endmodule
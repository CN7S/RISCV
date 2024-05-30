module writeback(
	clk,
	rst,
	rd_o,
	rd_i,
	
	mem_rdata_i,
	alu_rst_i,
	
	wdata_o,
	// control io
	memtoreg_i, // WB
	regwrite_i, // WB
	regwrite_o
);

input			clk;
input			rst;
input	[4 :0]	rd_i;
output	[4 :0]	rd_o;
output	[31:0]	wdata_o;
input	[31:0]	mem_rdata_i;
input	[31:0]	alu_rst_i;
input			memtoreg_i;
input			regwrite_i;
output			regwrite_o;

wire			clk;
wire			rst;
wire	[4 :0]	rd_i;
wire	[4 :0]	rd_o;
wire	[31:0]	wdata_o;
wire	[31:0]	mem_rdata_i;
wire	[31:0]	alu_rst_i;
wire			memtoreg_i;
wire			regwrite_i;
wire			regwrite_o;

wire	[4 :0]	rd_w;
wire	[31:0]	wdata_w;

assign 	rd_o	=	rd_i;
assign	wdata_o	=	memtoreg_i ? mem_rdata_i : alu_rst_i;
assign	regwrite_o	=	regwrite_i;

endmodule
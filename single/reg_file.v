module reg_file(
	input wire clk,
	input wire rst,
	input wire en_write,
	input wire [4:0] raddr_1,
	input wire [4:0] raddr_2,
	input wire [4:0] waddr,
	input reg [31:0] wdata,
	output reg [31:0] rdata_1,
	output reg [31:0] rdata_2
);


integer i;

reg [31:0] file_r [0:31];

always@(posedge clk or posedge rst) begin
	if(rst) begin
		for(i = 0; i < 32; i = i+1) begin
			file_r[i] <= 32'b0;
		end
	end
	else if(en_write) begin
		file_r[waddr] <= wdata;
	end
end


// rdata
always@(*) begin
	rdata_1 = file_r[raddr_1];
	rdata_2 = file_r[raddr_2];
end


endmodule
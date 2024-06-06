module data_compare(
	din_1,
	din_2,
	zero,
	less
);
input	[31:0]		din_1;
input	[31:0]		din_2;
output				zero;
output				less;

wire	[31:0]		din_1;
wire	[31:0]		din_2;
wire				zero;
wire				less;


assign zero	=	din_1 == din_2;
assign less	=	din_1 < din_2;



endmodule
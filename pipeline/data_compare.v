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


/*
wire	d8g_1;
wire	d8g_2;
wire	d8g_3;
wire	d8g_4;


wire	d8l_1;
wire	d8l_2;
wire	d8l_3;
wire	d8l_4;

wire [3:0] d8g;
wire [3:0] d8l;

assign d8g_1 = din_1[7:0] > din_2[7:0];
assign d8g_2 = din_1[15:8] > din_2[15:8];
assign d8g_3 = din_1[23:16] > din_2[23:16];
assign d8g_4 = din_1[31:24] > din_2[31:24];
assign d8l_1 = din_1[7:0] < din_2[7:0];
assign d8l_2 = din_1[15:8] < din_2[15:8];
assign d8l_3 = din_1[23:16] < din_2[23:16];
assign d8l_4 = din_1[31:24] < din_2[31:24];

assign d8g = {d8g_4, d8g_3, d8g_2, d8g_1};
assign d8l = {d8l_4, d8l_3, d8l_2, d8l_1};
assign zero = d8g == d8l;
assign less = d8g < d8l;
*/
assign zero	=	din_1 == din_2;
assign less	=	din_1 < din_2;



endmodule
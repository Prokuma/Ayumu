module MEM(
	input CLK_MEM,
	input [7:0] REG_A,
	input [7:0] ADDR,
	input [1:0] MODE,
	input MEM_WRITE,
	output reg [7:0]  Q
);

reg [7:0] MEM [255:0];

always @(posedge CLK_MEM) begin
	if (MODE == 2'b11) 
		if (MEM_WRITE)
			MEM[ADDR] <= REG_A;
		else
			Q <= MEM[ADDR];
	else
		Q <= ADDR;
end

integer i;
initial begin
	for (i=0; i < 255; i=i+1)
		MEM[i] = 0;
end
endmodule
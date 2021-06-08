module PC(
	input CLK_FT,
	input [15:0] NEXT,
	output reg [15:0] ADDR
);

always @(posedge CLK_FT) begin
	ADDR <= NEXT;
end

endmodule
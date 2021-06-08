module TIMER_INT(
	input CLK_WB,
	input [7:0] REG_INT,
	output reg INT_FLAG
);

reg [5:0] TIMER_COUNT;
reg [10:0] CNT;
assign CLK_TIMER = CNT == 10'd999;

always @(posedge CLK_WB) begin
	if (REG_INT[0] & (REG_INT[7:2] == TIMER_COUNT) & CLK_TIMER) begin
		INT_FLAG <= 1;
		TIMER_COUNT <= 6'b0;
	end
	else if (CLK_TIMER) begin
		TIMER_COUNT <= TIMER_COUNT + 6'b1;
	end
	else
		INT_FLAG <= 0;
		
	if (CNT == 10'd999)
		CNT <= 10'd0;
	else
		CNT <= CNT + 10'd1;
end

endmodule
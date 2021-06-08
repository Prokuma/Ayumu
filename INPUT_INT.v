module INPUT_INT(
	input CLK,
	input [7:0] INPUT,
	input [3:0] INT_NO,
	input [7:0] REG_INT,
	output reg INT_FLAG
);

reg [7:0] PREV_INPUT;

always @(posedge CLK) begin
	if (REG_INT[1:0] == 2'b01) begin
		if (((PREV_INPUT[0] == 0) & (INPUT[0] == 1)) | 
				((PREV_INPUT[1] == 0) & (INPUT[1] == 1)) | 
				((PREV_INPUT[2] == 0) & (INPUT[2] == 1)) | 
				((PREV_INPUT[3] == 0) & (INPUT[3] == 1)) | 
				((PREV_INPUT[4] == 0) & (INPUT[4] == 1)) | 
				((PREV_INPUT[5] == 0) & (INPUT[5] == 1)) | 
				((PREV_INPUT[6] == 0) & (INPUT[6] == 1)) | 
				((PREV_INPUT[7] == 0) & (INPUT[7] == 1))) begin
			INT_FLAG <= 1;
		end
		else
			INT_FLAG <= 0;
	end
	else if (REG_INT[1:0] == 2'b11) begin
		if (((PREV_INPUT[0] == 1) & (INPUT[0] == 0)) | 
				((PREV_INPUT[1] == 1) & (INPUT[1] == 0)) | 
				((PREV_INPUT[2] == 1) & (INPUT[2] == 0)) | 
				((PREV_INPUT[3] == 1) & (INPUT[3] == 0)) | 
				((PREV_INPUT[4] == 1) & (INPUT[4] == 0)) | 
				((PREV_INPUT[5] == 1) & (INPUT[5] == 0)) | 
				((PREV_INPUT[6] == 1) & (INPUT[6] == 0)) | 
				((PREV_INPUT[7] == 1) & (INPUT[7] == 0))) begin
			INT_FLAG <= 1;
		end
		else
			INT_FLAG <= 0;
	end
	else
		INT_FLAG <= 0;
	PREV_INPUT <= INPUT;
end

endmodule
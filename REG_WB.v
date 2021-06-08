module REG_WB(
	input CLK_WB,
	input REG_WRITE,
	input F_FLAG,
	input INOUT_FLAG,
	input [7:0] INT_FLAG_OUT,
	input [15:0] PC,
	input [4:0] REG_A_ADDR,
	input [1:0] MODE,
	input [1:0] JUMP_MODE,
	input [1:0] REG_O_TYPE,
	input [7:0] DATA,
	input [31:0] INPUT,
	output reg [15:0] NEXT,
	output [127:0] REG_R_OUT,
	output [63:0] REG_IO_OUT,
	output [63:0] REG_INT_FLAG_OUT,
	output INT_PROCESS
);

reg [7:0]  REG_R  [15:0];
reg [7:0]  REG_IO [7:0];
reg [23:0] REG_INT [7:0];

wire [7:0] REG_IO_WIRE [7:0];

reg INT_FLAG;
reg [15:0] INT_PREV_PC;
assign INT_PROCESS = INT_FLAG;

assign REG_R_OUT[7:0] = REG_R[0];
assign REG_R_OUT[15:8] = REG_R[1];
assign REG_R_OUT[23:16] = REG_R[2];
assign REG_R_OUT[31:24] = REG_R[3];
assign REG_R_OUT[39:32] = REG_R[4];
assign REG_R_OUT[47:40] = REG_R[5];
assign REG_R_OUT[55:48] = REG_R[6];
assign REG_R_OUT[63:56] = REG_R[7];
assign REG_R_OUT[71:64] = REG_R[8];
assign REG_R_OUT[79:72] = REG_R[9];
assign REG_R_OUT[87:80] = REG_R[10];
assign REG_R_OUT[95:88] = REG_R[11];
assign REG_R_OUT[103:96] = REG_R[12];
assign REG_R_OUT[111:104] = REG_R[13];
assign REG_R_OUT[119:112] = REG_R[14];
assign REG_R_OUT[127:120] = REG_R[15];

assign REG_IO_OUT[7:0] = REG_IO[0];
assign REG_IO_OUT[15:8] = REG_IO[1];
assign REG_IO_OUT[23:16] = REG_IO[2];
assign REG_IO_OUT[31:24] = REG_IO[3];
assign REG_IO_OUT[39:32] = REG_IO[4];
assign REG_IO_OUT[47:40] = REG_IO[5];
assign REG_IO_OUT[55:48] = REG_IO[6];
assign REG_IO_OUT[63:56] = REG_IO[7];

assign REG_INT_FLAG_OUT[7:0] = REG_INT[0][23:16];
assign REG_INT_FLAG_OUT[15:8] = REG_INT[1][23:16];
assign REG_INT_FLAG_OUT[23:16] = REG_INT[2][23:16];
assign REG_INT_FLAG_OUT[31:24] = REG_INT[3][23:16];
assign REG_INT_FLAG_OUT[39:32] = REG_INT[4][23:16];
assign REG_INT_FLAG_OUT[47:40] = REG_INT[5][23:16];
assign REG_INT_FLAG_OUT[55:48] = REG_INT[6][23:16];
assign REG_INT_FLAG_OUT[63:56] = REG_INT[7][23:16];

always @(posedge CLK_WB) begin
	if ((INT_FLAG_OUT != 8'b0)& !INT_FLAG) begin
		INT_FLAG <= 1;
		if (INT_FLAG_OUT[0])
			NEXT <= REG_INT[0][15:0];
		else if (INT_FLAG_OUT[1])
			NEXT <= REG_INT[1][15:0];
		else if (INT_FLAG_OUT[2])
			NEXT <= REG_INT[2][15:0];
		else if (INT_FLAG_OUT[3])
			NEXT <= REG_INT[3][15:0];
		else if (INT_FLAG_OUT[4])
			NEXT <= REG_INT[4][15:0];
		else if (INT_FLAG_OUT[5])
			NEXT <= REG_INT[5][15:0];
		else if (INT_FLAG_OUT[6])
			NEXT <= REG_INT[6][15:0];
		else if (INT_FLAG_OUT[7])
			NEXT <= REG_INT[7][15:0];
		INT_PREV_PC <= PC;
	end
	else if (REG_WRITE) begin
		case (MODE)
			2'b00: REG_R[REG_A_ADDR] <= DATA;
			2'b10: begin
				REG_IO[4] = INPUT[7:0];
				REG_IO[5] = INPUT[15:8];
				REG_IO[6] = INPUT[23:16];
				REG_IO[7] = INPUT[31:24];
				case (REG_O_TYPE)
					2'b00: begin
						if (INOUT_FLAG)
							REG_R[REG_A_ADDR] <= REG_IO[DATA[3:0]];
						else
							REG_IO[DATA[3:0]] <= REG_R[REG_A_ADDR];
					end
					2'b01: begin
						if (REG_A_ADDR == 4'd0) begin
							REG_INT[DATA[3:0]][15:8] <= REG_R[12];
							REG_INT[DATA[3:0]][7:0] <= REG_R[13];
						end
						else begin
							REG_INT[DATA[3:0]][15:8] <= REG_R[14];
							REG_INT[DATA[3:0]][7:0] <= REG_R[15];
						end
					end
					2'b10: REG_INT[DATA[3:0]][23:16] <= REG_R[REG_A_ADDR];
				endcase
			end
		endcase
		NEXT <= PC + 16'b1;
	end
	else if (!REG_WRITE & MODE == 2'b11) begin
		NEXT <= PC + 16'b1;
	end
	else begin
		case (JUMP_MODE)
			2'b00: begin
				NEXT[15:8] <= REG_R[REG_A_ADDR];
				NEXT[7:0] <= REG_R[DATA[3:0]];
			end
			2'b01: begin
				if (F_FLAG) begin
					NEXT[15:8] <= REG_R[REG_A_ADDR];
					NEXT[7:0] <= REG_R[DATA[3:0]];
				end
			end
			2'b10: begin
				NEXT <= INT_PREV_PC;
				INT_FLAG <= 0;
			end
		endcase
	end
end

endmodule
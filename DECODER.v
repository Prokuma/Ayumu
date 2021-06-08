module DECODER(
	input [15:0] COMMAND,
	output reg [3:0] CAL,
	output reg [1:0] MODE,
	output reg [7:0] IM,
	output reg [3:0] REG_A,
	output reg [3:0] REG_B,
	output reg [3:0] REG_O,
	output reg [1:0] REG_O_TYPE,
	output reg [1:0] JUMP_MODE,
	output reg REG_WRITE,
	output reg [1:0] SEL, //01 = SEL_OUTREG, 10 = SEL_IM, 11 = SEL_JMP
	output reg MEM_WRITE,
	output reg INOUT_FLAG
);

always @* begin
	if (COMMAND[15] == 1) begin
		CAL[3] <= 1'b0;
		CAL[2:0] <= COMMAND[14:12];
		MODE <= 2'b00;
		IM <= COMMAND[7:0];
		REG_A <= COMMAND[11:8];
		SEL <= 2'b10;
		REG_WRITE <= 1;
	end
	else if (COMMAND[14] == 1) begin
		CAL <= COMMAND[13:10];
		if (COMMAND[9:8] == 2'b00) begin
			MODE <= 2'b00;
			REG_A <= COMMAND[7:4];
			REG_B <= COMMAND[3:0];
			SEL <= 2'b00;
			REG_WRITE <= 1;
		end
		else if (COMMAND[9:8] == 2'b01) begin
			MODE <= 2'b01;
			REG_A <= COMMAND[7:4];
			REG_B <= COMMAND[3:0];
			SEL <= 2'b00;
			REG_WRITE <= 0;
		end
		else if (COMMAND[9:8] == 2'b10) begin
			MODE <= 2'b10;
			REG_O_TYPE <= COMMAND[13:12];
			INOUT_FLAG <= COMMAND[11];
			REG_O <= COMMAND[7:4];
			REG_A <= COMMAND[3:0];
			SEL <= 2'b01;
			REG_WRITE <= 1;
		end
		else if (COMMAND[9:8] == 2'b11) begin
			MODE <= 2'b11;
			REG_A <= COMMAND[7:4];
			REG_B <= COMMAND[3:0];
			SEL <= 2'b00;
			REG_WRITE <= COMMAND[10];
			MEM_WRITE <= ~COMMAND[10];
		end
	end
	else if (COMMAND[12] == 1) begin
		if (COMMAND[7:4] == 4'b0000) begin
			CAL <= 4'b0000;
			MODE <= 2'b10;
			SEL <= 2'b11;
			JUMP_MODE <= COMMAND[9:8];
			if (COMMAND[3:0] == 4'b0000) begin
				REG_A <= 4'd12;
				REG_B <= 4'd13;
			end
			else begin
				REG_A <= 4'd14;
				REG_B <= 4'd15;
			end
			REG_WRITE <= 0;
		end
		else if (COMMAND[7:4] == 4'b0001) begin
			CAL <= 4'b1011;
			MODE <= 2'b00;
			REG_A <= COMMAND[3:0];
			IM <= 8'b00000000;
			SEL <= 2'b10;
			REG_WRITE <= 1;
		end
		else if (COMMAND[7:4] == 4'b0010) begin
			CAL <= 4'b0000;
			MODE <= 2'b10;
			REG_O_TYPE <= 2'b10;
			REG_O <= COMMAND[3:0];
			SEL <= 2'b01;
			REG_WRITE <= 0;
			JUMP_MODE <= 2'b10;
		end
	end
end
endmodule
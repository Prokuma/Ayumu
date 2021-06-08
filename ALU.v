module ALU(
	input CLK_EX,
	input [7:0] IN_A,
	input [7:0] IN_B,
	input [3:0] CAL,
	input [1:0] MODE,
	input C_IN,
	input F_IN,
	output [7:0] OUT,
	output C_OUT,
	output reg F_OUT
);

reg [8:0] RESULT;

assign C_OUT = RESULT[8];
assign OUT = RESULT[7:0];

always @(posedge CLK_EX) begin
	case (MODE) 
		2'b00: begin
			case (CAL)
				4'b0000: RESULT <= IN_A + IN_B; 
				4'b0001: RESULT <= IN_A - IN_B; 
				4'b0010: RESULT <= $signed(IN_A) * $signed(IN_B);
				4'b0011: RESULT <= IN_A << IN_B; 
				4'b0100: RESULT <= IN_A >> IN_B;
				4'b0101: RESULT <= IN_A & IN_B;
				4'b0110: RESULT <= IN_A | IN_B;
				4'b0111: RESULT <= IN_A ^ IN_B;
				4'b1000: RESULT <= $unsigned(IN_A) * $unsigned(IN_B);
				4'b1001: RESULT <= IN_A + IN_B + C_IN;
				4'b1010: RESULT <= IN_A - IN_B - C_IN;
				4'b1011: RESULT <= ~IN_A;
				default: RESULT <=  9'b000000000;
			endcase
			F_OUT <= 0;
		end
		2'b01: begin
			case (CAL)
				4'b0000: F_OUT <= IN_A == IN_B;
				4'b0001: F_OUT <= IN_A != IN_B;
				4'b0010: F_OUT <= IN_A < IN_B;
				4'b0011: F_OUT <= IN_A > IN_B;
				4'b0100: F_OUT <= IN_A <= IN_B;
				4'b0101: F_OUT <= IN_A >= IN_B;
				default: F_OUT <= 0;
			endcase
			RESULT <= 9'b000000000;
		end
		2'b10: begin
			F_OUT <= 0;
			RESULT <= IN_A;
		end
		2'b11: begin
			F_OUT <= 0;
			RESULT <= IN_A;
		end
	endcase
end

endmodule
module REG_DC (
	input CLK_DC,
	input [127:0] REG_R ,
	input [63:0] REG_IO,
	input [1:0] SEL,
	input [1:0] REG_O_TYPE,
	input [3:0] REG_A_ADDR,
	input [3:0] REG_B_ADDR,
	input [3:0] REG_O_ADDR,
	input [7:0] IM,
	output reg [7:0] REG_A,
	output reg [7:0] REG_B
 );
 
 reg [7:0] REG_A_VALUE;
 reg [7:0] REG_B_VALUE;
 
 always @(posedge CLK_DC) begin
	case (REG_A_ADDR) 
		4'd0: REG_A_VALUE = REG_R[7:0];
		4'd1: REG_A_VALUE = REG_R[15:8];
		4'd2: REG_A_VALUE = REG_R[23:16];
		4'd3: REG_A_VALUE = REG_R[31:24];
		4'd4: REG_A_VALUE = REG_R[39:32];
		4'd5: REG_A_VALUE = REG_R[47:40];
		4'd6: REG_A_VALUE = REG_R[55:48];
		4'd7: REG_A_VALUE = REG_R[63:56];
		4'd8: REG_A_VALUE = REG_R[71:64];
		4'd9: REG_A_VALUE = REG_R[79:72];
		4'd10: REG_A_VALUE = REG_R[87:80];
		4'd11: REG_A_VALUE = REG_R[95:88];
		4'd12: REG_A_VALUE = REG_R[103:96];
		4'd13: REG_A_VALUE = REG_R[111:104];
		4'd14: REG_A_VALUE = REG_R[119:112];
		4'd15: REG_A_VALUE = REG_R[127:120];
	endcase
	case (REG_B_ADDR) 
		4'd0: REG_B_VALUE = REG_R[7:0];
		4'd1: REG_B_VALUE = REG_R[15:8];
		4'd2: REG_B_VALUE = REG_R[23:16];
		4'd3: REG_B_VALUE = REG_R[31:24];
		4'd4: REG_B_VALUE = REG_R[39:32];
		4'd5: REG_B_VALUE = REG_R[47:40];
		4'd6: REG_B_VALUE = REG_R[55:48];
		4'd7: REG_B_VALUE = REG_R[63:56];
		4'd8: REG_B_VALUE = REG_R[71:64];
		4'd9: REG_B_VALUE = REG_R[79:72];
		4'd10: REG_B_VALUE = REG_R[87:80];
		4'd11: REG_B_VALUE = REG_R[95:88];
		4'd12: REG_B_VALUE = REG_R[103:96];
		4'd13: REG_B_VALUE = REG_R[111:104];
		4'd14: REG_B_VALUE = REG_R[119:112];
		4'd15: REG_B_VALUE = REG_R[127:120];
	endcase
	case (SEL)
		2'b00: begin
			REG_A <= REG_A_VALUE;
			REG_B <= REG_B_VALUE;
		end
		2'b01: begin
			case (REG_O_TYPE)
				2'b00: begin
					REG_A <= REG_O_ADDR;
					REG_B <= 8'd0;
				end
				2'b01: begin
					REG_A <= REG_O_ADDR;
					REG_B <= 8'd0;
				end
				2'b10: begin
					REG_A <= REG_O_ADDR;
					REG_B <= 8'd0;
				end
			endcase
		end
		2'b10: begin
			REG_A <= REG_A_VALUE;
			REG_B <= IM;
		end
		2'b11:begin
			REG_A[7:4] <= 4'b0000;
			REG_A[3:0] <= REG_B_ADDR;
			REG_B <= 8'd0;
		end
	endcase	
 end
 
 endmodule
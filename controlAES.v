// Overall AES Implementation
// Purpose: AES control code, moving data from step to step and round to round
// Specifics: Taking overall input from hash function, distributing keys between rounds,
//	calling subBytes, shiftRows, mixColumns, and addRoundKey modules each round,
//	moving 128-bit data between modules and rounds.
//	Input: clk, rst, 128-bit in, encdec
//	Output: en_out, sent, 128-bit out
// rst - build in auto-update, normally active low, if receive high for one clock cycle, 
//	 then take and process new data, throw out old.
// encdec - choose whether encrypting or decrypting

module controlAES(clk, rst, in, key, en_out, out);
input clk, rst, encdec;
input [7:0] in[15:0];
input [7:0] key[31:0];
output en_out, sent;
output reg [7:0] out[15:0];

reg [7:0] sr[15:0];
reg mode;
integer count;
	
always@(posedge clk, rst)
	begin
		if(rst) begin
			count  <= 0;
			en_out <= 1'b1;
			// go-to next state;
		end else begin
			if (count == 0) begin
				sr <= in;
				key <= keyExpansion step_key(clk, rst, in, key);
			end
			if (encdec) begin
				// Encryption
				if(count == 0) begin
					addRoundKey step4_init(clk, rst, in, key[count], out);
				end
				if(count < 13) begin
					subBytes step1(clk, rst, in, out);
					shiftRows step2(clk, rst, in, out);
					mixColumns step3(clk, rst, in, out);
					addRoundKey step4(clk, rst, in, out);
					count <= count + 1;
				end else if (count == 13) begin
					subBytes step1_final(clk, rst, in, out);
					shiftRows step2_final(clk, rst, in, out);
					addRoundKey step4_final(clk, rst, in, key[count], out);
					count <= 0;
				end else begin
					count <= 0;
					sr <= in;
				end
			end else 
				// Decryption
				if(count == 0) begin
					invAddRoundKey invstep4_init(clk, rst, in, key[15 - count], out);
				end
				if(count < 13) begin
					invSubBytes invstep1(clk, rst, in, out);
					inShiftRows invstep2(clk, rst, in, out);
					invMixColumns invstep3(clk, rst, in, out);
					invAddRoundKey invstep4(clk, rst, in, out);
					count <= count + 1;
				end else if (count == 13) begin
					invSubBytes invstep1_final(clk, rst, in, out);
					invShiftRows invstep2_final(clk, rst, in, out);
					invAddRoundKey invstep4_final(clk, rst, in, key[15 - count], out);
					count <= 0;
				end else begin
					count <= 0;
					sr <= in;
			end	
		end
	end
endmodule

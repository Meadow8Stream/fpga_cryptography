// Overall AES Implementation
// Purpose: AES control code, moving data from step to step and round to round
// Specifics: Taking overall input from hash function, distributing keys between rounds,
//	calling subBytes, shiftRows, mixColumns, and addRoundKey modules each round,
//	moving 128-bit data between modules and rounds.
//	Input: clk, rst, 128-bit in, encdec
//	Output: en_out, 128-bit out
// rst - build in auto-update, normally active low, if receive high for one clock cycle, 
//	 then take and process new data, throw out old.
// encdec - choose whether encrypting or decrypting

module controlAES(clk, rst, in, en_out, out);
input clk, rst, encdec;
input [7:0] in[15:0];
output en_out;
output reg [7:0] out[15:0];

always@(posedge clk, rst)
	begin
		if (encdec) begin
			// do encryption
		end else 
			// do decryption
		end
	end
endmodule

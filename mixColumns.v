// AES Verilog -> FPGA
// mixColumns step
// 

module mixColumns(clk, rst, in, out);
input clk;
input rst;

input 	   [7:0] data_in[15:0];			// input represented as 16 bytes
output reg [7:0] data_out[15:0];			// output represented as 16 bytes

wire[7:0] sr_gf1[15:0];				// will hold original input or galois x2 multiplication
wire[7:0] sr_gf2[15:0];				// will hold galois x2 multiplication
wire[7:0] sr_gf3[15:0];				// will hold galois x3 multiplication
	
reg [8:0] loop;
	
generate
	for (loop = 0; loop <= 15; loop = loop + 1) begin
		assign sr_gf1[loop] = data_in[loop];
		assign sr_gf2[loop] = data_in[0][7] ? ((data_in[loop] << 1) ^ 8'h1b) : (data_in[loop] << 1);
		assign sr_gf3[loop] = sr_gf2[loop] ^ data_in[loop];
	end
endgenerate	
	
assign data_out[0] = sr_gf2[0] ^ sr_gf3[1] ^ sr_gf1[2] ^ sr_gf1[3];
assign data_out[1] = sr_gf1[0] ^ sr_gf2[1] ^ sr_gf3[2] ^ sr_gf1[3];
assign data_out[2] = sr_gf1[0] ^ sr_gf1[1] ^ sr_gf2[2] ^ sr_gf3[3];
assign data_out[3] = sr_gf3[0] ^ sr_gf1[1] ^ sr_gf1[2] ^ sr_gf2[3];

assign data_out[4] = sr_gf2[4] ^ sr_gf3[5] ^ sr_gf1[6] ^ sr_gf1[7];
assign data_out[5] = sr_gf1[4] ^ sr_gf2[5] ^ sr_gf3[6] ^ sr_gf1[7];
assign data_out[6] = sr_gf1[4] ^ sr_gf1[5] ^ sr_gf2[6] ^ sr_gf3[7];
assign data_out[7] = sr_gf3[4] ^ sr_gf1[5] ^ sr_gf1[6] ^ sr_gf2[7];

assign data_out[8] = sr_gf2[8] ^ sr_gf3[9] ^ sr_gf1[10] ^ sr_gf1[11];
assign data_out[9] = sr_gf1[8] ^ sr_gf2[9] ^ sr_gf3[10] ^ sr_gf1[11];
assign data_out[10] = sr_gf1[8] ^ sr_gf1[9] ^ sr_gf2[10] ^ sr_gf3[11];
assign data_out[11] = sr_gf3[8] ^ sr_gf1[9] ^ sr_gf1[10] ^ sr_gf2[11];

assign data_out[12] = sr_gf2[12] ^ sr_gf3[13] ^ sr_gf1[14] ^ sr_gf1[15];
assign data_out[13] = sr_gf1[12] ^ sr_gf2[13] ^ sr_gf3[14] ^ sr_gf1[15];
assign data_out[14] = sr_gf1[12] ^ sr_gf1[13] ^ sr_gf2[14] ^ sr_gf3[15];
assign data_out[15] = sr_gf3[12] ^ sr_gf1[13] ^ sr_gf1[14] ^ sr_gf2[15];
	
// or possibly simpler
/*
reg [8:0] count;
generate
	for (count = 0; count < 15; count = count + 4) begin
		assign data_out[count + 0] = sr_gf2[count] ^ sr_gf3[count + 1] ^ sr_gf1[count + 2] ^ sr_gf1[count + 3];
		assign data_out[count + 1] = sr_gf1[count] ^ sr_gf2[count + 1] ^ sr_gf3[count + 2] ^ sr_gf1[count + 3];
		assign data_out[count + 2] = sr_gf1[count] ^ sr_gf1[count + 1] ^ sr_gf2[count + 2] ^ sr_gf3[count + 3];
		assign data_out[count + 3] = sr_gf3[count] ^ sr_gf1[count + 1] ^ sr_gf1[count + 2] ^ sr_gf2[count + 3];	
	end
endgenerate
*/
endmodule

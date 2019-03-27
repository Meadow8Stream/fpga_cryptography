// AES Verilog -> FPGA
// mixColumns step
// 

module mixColumns(clk, rst, in, out);
input clk;
input rst;

input 	   [7:0] in[15:0];			// input represented as 16 bytes
output reg [7:0] out[15:0];		// output represented as 16 bytes

wire two_GF;
wire three_GF;
assign two_GF	= 8'b00000010;
assign three_GF = 8'b00000011;

always@(posedge clk, rst)
	// word "times" in comments means galois field multiplication using (2^8)
	begin
		if (~rst) begin
			// mixing of columns
			
		end
		end	

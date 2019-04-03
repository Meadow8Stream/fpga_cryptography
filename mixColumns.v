// AES Verilog -> FPGA
// mixColumns step
// 

module mixColumns(clk, rst, in, out);
input clk;
input rst;

input 	   [7:0] in[15:0];			// input represented as 16 bytes
output reg [7:0] out[15:0];			// output represented as 16 bytes

wire two_GF;
wire three_GF;
assign two_GF	= 8'b00000010;
assign three_GF = 8'b00000011;

always@(posedge clk, rst)
	// word "times" in comments means galois field multiplication using (2^8)
	// symbol "+" means xor
	begin
		if (~rst) begin
			// mixing of columns
			// row 1 calculations:
			// two times the current byte + three times the byte to the right +
			// two bytes to the right + three bytes to the right
			out[0] <= multGF(two_GF, in[0]) ^ multGF(three_GF, in[1]) ^ in[2] ^ in[3];
			out[1] <= multGF(two_GF, in[1]) ^ multGF(three_GF, in[1]) ^ in[2] ^ in[3];
			out[2] <= multGF(two_GF, in[2]) ^ multGF(three_GF, in[1]) ^ in[2] ^ in[3];
			out[3] <= multGF(two_GF, in[3]) ^ multGF(three_GF, in[1]) ^ in[2] ^ in[3];
			
			// row 2 calculations:
			//
			
		end
	end

task multGF;
	// I/O + variables
	input rst, gf_en;
	input [7:0] a;
	input [7:0] b;
	output reg [7:0] p;
	
	reg carry;
	reg [3:0] count = 4'b0000;
	reg [7:0] p_irr = 8'b00011011;
	
	always@(posedge clk) begin
		if (~rst) begin
			count <= 4'0000;
			p <= 8'00000000;
		end else if (gf_en == 1) begin
			count <= 4'b0000;
			p <= 8'b00000000;
			gf_en <= 0;
		end else if (count < 4'b1000) begin
			// peasant's algorithm
		end
	end
endtask
	
endmodule

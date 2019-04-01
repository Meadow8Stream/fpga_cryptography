// AES Verilog -> FPGA
// invMixColumns step
// 

module mixColumns(clk, rst, in, out);
input clk;
input rst;

input 	   [7:0] in[15:0];			// input represented as 16 bytes
output reg [7:0] out[15:0];		// output represented as 16 bytes

wire two_GF;
wire three_GF;
assign nine_GF	= 8'b00001001;
assign b_GF     = 8'b00001011;
assign d_GF     = 8'b00001101;
assign e_GF     = 8'b00001110;

always@(posedge clk, rst)
	// word "times" in comments means galois field multiplication using (2^8)
	begin
		if (~rst) begin
			// mixing of columns
		end
	end

task multGFBasic;
	// I/O + variables
	input [7:0] a;
	input [7:0] b;
	output reg [7:0] p;
	
	integer carry;
	integer count;

	
	integer p_irr;
	p_irr <= 8'b00011011;
	always@(posedge clk) begin
		if (count == 0) begin
			p <= 8'b00000000;
			p_irr <= 8'b00011011;
		end else if begin
			// peasant's algorithm
		end
	end
endtask
	
endmodule

// module: Galois Field multiplication using the peasant's algorithm
//
module multGF(clk, a, b, gf_en, p);
  // variables and I/O
  input clk;
  input gf_en;
  input [7:0] a;
  input [7:0] b;
  output reg [7:0] p;
  
  reg carry;
  reg [7:0] a_tmp;
  reg [7:0] b_tmp;
  
  reg [4:0] p_irr = 5'b11011;
  
  always@(posedge clk) begin
  	if(~gf_en) begin
    		p <= 8'b00000000;
		a_tmp <= a;
		b_tmp <= b;

		// peasant's algorithm
		// bit 1
		if (b_tmp[0]) begin
			p <= p ^ a_tmp;
		end
		b_tmp <= b_tmp >> 1;
		carry <= a_tmp[0];
		a_tmp <= a_tmp << 1;
		if(carry) begin
			a_tmp <= a_tmp ^ p_irr;
		end
	end
end

endmodule

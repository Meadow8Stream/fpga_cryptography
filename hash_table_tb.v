
`timescale 1 ns / 1 ps
module TestBench;
				   	  		   
	reg [7:0] val;
	reg clock, reset;
	wire [8:0] flag;	
		
	//module
		HashTree HashTree(
		.clock(clock),
		.reset(reset),
		.val(val),
		.flag(flag)
		);  
		
	initial begin
	clock = 0;
	flag = 0;
	val = 8'b01000000;	
	reset = 0;
	end
	
	always begin
		#1 clock = ~clock;
	end
	
	//always
	//	#4 reset = ~reset;
	
	
endmodule

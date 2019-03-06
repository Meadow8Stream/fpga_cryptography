

`timescale 1 ns / 1 ps

module testbench;  
	
	
	reg clock, reset;
	wire Y;
	
	test UUT (	
		.reset(reset),
		.Y(Y),
		.clock(clock)
	);	 
		
	initial begin 
	clock = 0; 
		forever begin
			#10 clock = ~clock;
	end end		
	
	initial begin 
	reset = 0; 
		forever begin
			#100 reset = 1;
	end end
		
endmodule

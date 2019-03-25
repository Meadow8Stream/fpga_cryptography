

`timescale 1 ns / 1 ps

module hash_tb;  
	
	
	reg clock, reset, data;
	wire Y;
	
	hash UUT (		 
		.clock(clock),
		.reset(reset),		   
		.Y(Y)//,	  
		//.data(data)
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



`timescale 1 ns / 1 ps

module hash_tb;  
	
	parameter SIZE = 63; //size of data - 1 = 64 - 1 = 63 (TEST)
	
	
	reg clock, reset, hash_en;
	reg  [SIZE:0] data, bit_length;
	wire Y;	
	
	//reg  [SIZE:0] data = 64'h6869207468657265; //data message	
	
	hash UUT (		 
		.clock(clock),
		.reset(reset),
		.hash_en(hash_en), 	  
		.data(data),
		.bit_length(bit_length)
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
	
	initial begin 
	hash_en = 0;
	data <= {SIZE+1{1'b0}};
	bit_length <= {SIZE+1{1'b0}}; 
	
	#1000 data <= 64'h6869207468657265;
	#1000 bit_length <= 64'h0000000000000040;
	#1000 hash_en = 1;
	#20 hash_en = 0; 
	#1000 data <= 64'h6D6F757365706164;
	#1000 bit_length <= 64'h0000000000000040;
	#6000 hash_en = 1;
	#20 hash_en = 0;
	#6000 hash_en = 1;
	#20 hash_en = 0;
	end	
		
endmodule

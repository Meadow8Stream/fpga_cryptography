//-----------------------------------------------------------------------------
//
// Title       : outputSPI
// Author      : Caleb Ellington
//
//-----------------------------------------------------------------------------
// 		
// Purpose: To take Hash Table output and turn it into an SPI signal
// Specifics: 
//	Data line output
// 	Enable line to say when talking
//	Send clock to inplement symmetric clocks
//
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ps

//{module {outputSPI}}
module outputSPI (in, rst, clk, out, en_out, clk_out);
	input [7:0] in;
	input rst;
	input clk;
	output reg out;
	output reg en_out;
	output reg clk_out;
	
	// internal variables
	reg [7:0] sr;					// index 7 = msb	  
	integer i;
	integer counter;
	
	// initialize variables
	counter = 0;
	assign clk_out = clk;
	
	always@(posedge clk, rst)
	begin
		clk_out <= clk;
		
		// pull out down
		out <= 1'b0;
		sr <= 8'b00000000;
		
		if (~rst) 
		begin
			counter <= 1'b0;
			out <= 1'b0;   
			en_out <= 1'b0;
			
		end
		
		else	
		begin
			sr <= in;

			// send enable
			en_out <= 1'b1;	
			
			// construct signal
			// Implement/Alter to make: sending a 1 is high for one clock cycle, low for one clock cycle
			//			    sending a 0 is low for one clock cycle, high for one clock cycle.
			if (counter == 0) begin    
				out <= sr[0];
				counter <= counter + 1;
			end	else if (counter == 1) begin	
				out <= sr[1];
				counter <= counter + 1;
			end else if (counter == 2) begin
				out <= sr[2];
				counter <= counter + 1;	 
			end else if (counter == 3) begin
				out <= sr[3];
				counter <= counter + 1;
			end	else if (counter == 4) begin
				out <= sr[4];
				counter <= counter + 1;
			end else if (counter == 5) begin
				out <= sr[5];
				counter <= counter + 1;
			end else if (counter == 6) begin
				out <= sr[6];
				counter <= counter + 1;
			end else if (counter == 7) begin
				out <= sr[7];
				counter <= 0;
			end
			
		end	 
	end
endmodule

task sendOne;
input clk;
	
endtask

task sendZero
input clk;	
endtask

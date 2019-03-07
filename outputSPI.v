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
				counter <= counter + 1;
				if (sr[0]) begin
					sendOne(clk, rst);
				end else begin
					sendZero(clk, rst);
				end
			end else if (counter == 1) begin	
				counter <= counter + 1;
				if (sr[1]) begin
					sendOne(clk, rst);
				end else begin
					sendZero(clk, rst);
				end
			end else if (counter == 2) begin
				counter <= counter + 1;	
				if(sr[2]) begin
					sendOne(clk, rst);
				end else begin
					sendZero(clk, rst);
				end
			end else if (counter == 3) begin
				counter <= counter + 1;
				if(sr[3]) begin
					sendOne(clk, rst);
				end else begin
					sendZero(clk, rst);
				end
			end else if (counter == 4) begin
				counter <= counter + 1;
				if(sr[4]) begin
					sendOne(clk, rst);
				end else begin
					sendZero(clk, rst);
				end
			end else if (counter == 5) begin
				counter <= counter + 1;
				if(sr[5]) begin
					sendOne(clk, rst);
				end else begin
					sendZero(clk, rst);
				end
			end else if (counter == 6) begin
				counter <= counter + 1;
				if(sr[6]) begin
					sendOne(clk, rst);
				end else begin
					sendZero(clk, rst);
				end
			end else if (counter == 7) begin
				counter <= 0;
				if(sr[7]) begin
					sendOne(clk, rst);
				end else begin
					sendZero(clk, rst);
				end
			end
			
		end	 
	end

task sendOne;
input clk;
input rst;
reg clk_one;

always@(posedge clk)
	begin
	if (~rst)
		clk_one <= 1'b0;
	else begin
		clk_one = ~clk_one;
		out <= clk_one;
	end	
endtask

task sendZero
input clk;
input rst;
reg clk_zero;

always@(posedge clk)
	begin
	if (~rst)
		clk_zero <= 1'b0;
	else begin
		clk_zero = ~clk_zero
		out <= ~clk_zero;
	end
endtask

endmodule

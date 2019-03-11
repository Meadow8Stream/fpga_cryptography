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
module outputSPI (in, rst, clk, out, en_out, clk_out, sent);
	input [7:0] in;
	input rst;
	input clk;
	output reg out;
	output reg en_out;
	output reg clk_out;
	output reg sent;
	
	// internal variables
	reg [7:0] sr;					// index 7 = msb	  
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
		
		if (rst) 
		begin
			counter <= 1'b0;
			out <= 1'b0;   
			en_out <= 1'b0;
			
		end
		
		else	
		begin
			if (counter == 0) begin
				// if counter == 0, then a byte is not in the process of being sent
				// thus shift register can take a new value and start a new transmission.
				sr <= in;
				
				// when sent is 0, then outputSPI is transmitting and not accepting
				// new data to be sent
				// when sent is 1, then outputSPI has finished transmitting/ready for 
				// new data to be sent
				// should connect to hash tables
				sent <= 1'b0;
			end

			// send enable
			en_out <= 1'b1;	
			
			// construct signal
			// Implement/Alter to make: sending a 1 is high for one clock cycle, low for one clock cycle
			//			    sending a 0 is low for one clock cycle, high for one clock cycle.
			if (counter == 0) begin    
				counter <= counter + 1;
				if (sr[0]) begin
					sendOne;
				end else begin
					sendZero;
				end
			end else if (counter == 1) begin	
				counter <= counter + 1;
				if (sr[1]) begin
					sendOne;
				end else begin
					sendZero;
				end
			end else if (counter == 2) begin
				counter <= counter + 1;	
				if(sr[2]) begin
					sendOne;
				end else begin
					sendZero;
				end
			end else if (counter == 3) begin
				counter <= counter + 1;
				if(sr[3]) begin
					sendOne;
				end else begin
					sendZero;
				end
			end else if (counter == 4) begin
				counter <= counter + 1;
				if(sr[4]) begin
					sendOne;
				end else begin
					sendZero;
				end
			end else if (counter == 5) begin
				counter <= counter + 1;
				if(sr[5]) begin
					sendOne;
				end else begin
					sendZero;
				end
			end else if (counter == 6) begin
				counter <= counter + 1;
				if(sr[6]) begin
					sendOne;
				end else begin
					sendZero;
				end
			end else if (counter == 7) begin
				counter <= 0;
				if(sr[7]) begin
					sendOne;
				end else begin
					sendZero;
				end
				en_out <= 1'b0;
				sent <= 1'b1;
			end
			
		end	 
	end

task sendOne;
	integer i;
	
	always@(posedge clk)
	begin
		if (~rst) begin
			for (i = 0; i<3; i=i+i) begin
				if (i == 0) begin
					out <= 1'b1;
				end else if (i == 1) begin
					out <= 1'b0;
				end else if (i == 2) begin
					out <= 1'b0;
				end
			end
		end
	end
endtask

task sendZero
	integer i;

	always@(posedge clk)
	begin
		if (~rst) begin
			for (i = 0; i<3; i=i+i) begin
				if (i == 0) begin
					out <= 1'b1;
				end else if (i == 1) begin
					out <= 1'b1;
				end else if (i == 2) begin
					out <= 1'b0;
				end
			end
		end
	end
endtask

endmodule

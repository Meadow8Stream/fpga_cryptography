//-----------------------------------------------------------------------------
//
// Title       : outputSPI
// Author      : Caleb Ellington
//
//-----------------------------------------------------------------------------
// 		
// Purpose: To send data using an SPI signal
// Specifics: 
//	Data line output
// 	Enable line to say when talking
//	Send clock to inplement symmetric clocks
//
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ps

//{module {outputSPI}}
module outputSPI (in, rst, en, clk, out, en_out, clk_out, sent);
	input [7:0] in;
	input rst;
	input en;
	input clk;
	output reg out;
	output reg en_out;
	output reg clk_out;
	output reg sent;
	
	// internal variables
	reg [7:0] sr;					// index 7 = msb	  
	reg [3:0] counter1;
	reg [1:0] counter2;
	
	// initialize variables	 
	initial begin 
		clk_out = clk;
	end	
		
	always@(posedge clk, rst)
	begin
		// when sent is 0, then outputSPI is transmitting and not accepting
		// new data to be sent
		// when sent is 1, then outputSPI has finished transmitting/ready for 
		// new data to be sent
		sent <= 1'b0;
		if (rst) begin
			counter1 <= 4'b0000;
			counter2 <= 2'b00;
			out 	 <= 1'b0;   
			en_out   <= 1'b1;
			sent 	 <= 1'b1;  
			sr 	 <= 8'b00000000;
		end else if (en) begin
			counter1 <= 4'b0000;
			counter2 <= 2'b00;
			out 	 <= 1'b0;   
			en_out   <= 1'b1;
			sent 	 <= 1'b1; 
			sr 	 <= 8'b00000000;
		end else begin   
			// if counter == 0, then a byte is not in the process of being sent
			// thus shift register can chamber a new value and start a new transmission.
			if(counter1 == 2'b00) begin
				sr <= in;
			end
			// send enable
			en_out <= 1'b0;	
			
			// construct signal
			// Basically calling the correct send task to put the proper bit on the SPI line
			if(counter1 < 8) begin
				if(counter2 == 2'b00) begin	 
					counter1 <= counter1 + 4'b0001;
					en_out 	 <= 1'b0;
					out 	 <= 1'b1;
					counter2 <= 2'b01;
				end else if (counter2 == 2'b01) begin  
					en_out   <= 1'b0;
					out	 <= sr[0];
					sr 	 <= sr >> 1;
					counter2 <= 2'b10;
				end else if (counter2 == 2'b10) begin
					en_out   <= 1'b0;
					out 	 <= 1'b0;
					counter2 <= 2'b00;
				end
			end else begin	  
				out 		 <= 1'b0;
				counter1 	 <= 4'b0000;
				sent 		 <= 1'b1;
			end
		end
	end
endmodule

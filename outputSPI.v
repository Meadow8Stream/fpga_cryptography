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
module outputSPI (in, en, clk, out, en_out, clk_out);
input in[7:0];
input en;
input clk;
output reg out;
output reg en_out;
output reg clk_out;

reg sr[7:0];					// index 7 = msb
	
always@(posedge clk)
	begin
		if (en) 
		begin
			sr <= in;

			// create and send sync'ed clock
			#10 clk_out <= clk;

			// send enable
			en_out <= en;	
			
			// construct signal
			#1 out <= sr[0];
			#1 out <= sr[1];
			#1 out <= sr[2];
			#1 out <= sr[3];
			#1 out <= sr[4];
			#1 out <= sr[5];
			#1 out <= sr[6];
			#1 out <= sr[7];
			
		end
		else
		begin
			sr <= 8'b00000000;
		end
	end
endmodule

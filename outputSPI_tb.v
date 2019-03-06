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
module outputSPI ();
input in[7:0];
input en;
input clk;
output out;
output en_out;
output clk_out;

	reg sr[7:0];					// index 0 = msb
	
always(posedge clk)
	begin
		if (en) 
			begin
				sr <= in;
				
				// create and send sync'ed clock
				$10 clk_out <= clk;
				
				// send enable
				en_out <= en;	
				// construct signal
				out <= sr;
			end
			else
			begin
				sr <= 0;
			end
	end
endmodule

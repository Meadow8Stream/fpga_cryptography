//-----------------------------------------------------------------------------
//
// Title       : outputSPI_tb
// Author      : Caleb Ellington
//
//-----------------------------------------------------------------------------
// 		
// Purpose: To test outputSPI
// 		Specifics: send 2+ bytes one after the other to observe output
//
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ps

module outputSPI_tb;
reg clk, en;
reg [7:0]in;

wire [3:0]out
wire clk_out, en_out;

outputSPI UUT (
.clk (clk)
.en (en)
.in (in)
.out (out)
.clk_out (clk_out)
.en_out (en_out)
);				

always
	#10 clk = ~clk;
	#5 en <= 1'b1;
	#1 in <= 8'b00000000;
	#1 in <= 8'b00000001;
	#1 in <= 8'b00000010;
	#1 in <= 8'b00000011;
	
	initial begin
		$display("\t\ttime,\tclk,\ten,\tin,\tout"); 
		$monitor("%d,\t%b,\t%b,\t%b,\t%d",$time, clk,en,in,out);
	end

endmodule

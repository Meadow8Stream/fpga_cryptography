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
reg clk, rst;
reg [7:0]in;

reg out;
reg sent;
wire clk_out, en_out;

outputSPI UUT (
.clk (clk)
.rst (rst)
.in (in)
.out (out)
.clk_out (clk_out)
.en_out (en_out)
.sent (sent)
);				

always
	begin
	#1 clk = ~clk;
	#5 rst <= 1'b1;
	end
	
initial
	begin
	#1 in <= 8'b00000000;
	end
	end
initial begin
	$display("\t\ttime,\tclk,\ten,\tin,\tout"); 
	$monitor("%d,\t%b,\t%b,\t%b,\t%d",$time, clk,en,in,out);
	end

endmodule

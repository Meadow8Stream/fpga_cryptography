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
initial begin
	clk <= 1'b0;
	rst <= 1'b0;
	in <= 8'b11111111;
	
always
	begin
	#1 clk = ~clk;
	end
	
always begin
	for (i = 0; i < 256; i = i + 1) begin
		in <= in + 8'b00000001;
	end
end
	
initial begin
	$display("\t\ttime,\tclk,\ten,\tin,\tout"); 
	$monitor("%d,\t%b,\t%b,\t%b,\t%d",$time, clk,en,in,out);
	end

endmodule

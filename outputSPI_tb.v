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
reg clk, rst, en;
reg [7:0]in;

reg out;
reg sent;
wire clk_out, en_out;  
integer i;

outputSPI UUT (
.clk 		(clk),
.rst 		(rst),	
.en  		(en),
.in  		(in),
.out 	 	(out),
.clk_out 	(clk_out),
.en_out 	(en_out),
.sent 		(sent)
);		

initial 
begin
	clk = 1'b0;
	rst = 1'b1;
	en = 1'b1;
	in = 8'b00000000; 
	i = 0;
end

always
begin
	#1 clk <= ~clk;
end	

initial
begin	  
	#5 rst <= 1'b0;
	en <= 1'b0;	  
	in <= 8'b00000001; 	
	#50 in <= 8'b00000010
end
	
initial 
begin
	$display("\t\ttime,\tclk,\trst,\ten,\tin,\tout"); 
	$monitor("%d,\t%b,\t%b,\t%b,\t%b,\t%d",$time, clk,rst,en,in,out);
end

endmodule

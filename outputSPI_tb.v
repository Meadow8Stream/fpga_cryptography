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
	rst = 1'b0;
	in = 8'b11111111; 
	i <= 0;
end

always
	begin
	#1 clk <= ~clk;
end
	
always
	begin 
	if (i < 5) begin
		in <= in + 8'b00000001;
		i <= i + 1;
	end else begin
		i <= 0;
	end
end
	
initial begin
	$display("\t\ttime,\tclk,\trst,\tin,\tout"); 
	$monitor("%d,\t%b,\t%b,\t%b,\t%d",$time, clk,rst,in,out);
end

endmodule

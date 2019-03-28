
//-----------------------------------------------------------------------------
//`timescale 1 ns / 1 ps
//{{ Section below this comment is automatically maintained
//   and may be overwritten
//{module {HashTree}}
module HashTree (clock,reset,val,flag);
input reg [7:0] val;
input reg clock, reset;
output wire [8:0] flag;	
integer i 1'b0;
integer j 1'b0;
// -- Enter your statements here -- //	   
//input
/*initial begin  
	[15:0][15:0]
*/
always@(posedge clock)
for(i=0;i<256;i=i+1)begin
	for(j=0;j<256;j=j+1)begin
		if (val == b[i][j])begin
			flag[i][j]=1;			  
		end
	end
end	  

endmodule

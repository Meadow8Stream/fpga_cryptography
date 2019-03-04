% Serial Parallel Interface Verilog Implementation
% Caleb Ellington
%
% Purpose: To take Hash Table output and turn it into an SPI signal
% Specifics: 
%	Data line output
% 	Enable line to say when talking
%	Send clock to inplement symmetric clocks

module outputSPI (in, out, en, clk);
input in[7:0];
output out;
output en;
output clk;



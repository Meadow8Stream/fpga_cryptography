/* Please create a parsing program that can take in a 16 byte stream of 1s and 0s, 
store the stream as one 16 byte register of data, and compare this data to presored data.
For now, please use constants for the prestored data that you may randomly chose just for testing purposes.*/

module parse(input clk, input end_of_sequence, input in_data);
  reg[127:0] pdata;
  output [127:0] result;

//store 16 byte stream

always @(posedge clk) begin
  pdata <= {pdata[126:0, in_data};
end

always @(posedge clk) begin
  if(end_of_sequence ) begin
    result <= pdata;
  end
end

//Compare data to prestored data

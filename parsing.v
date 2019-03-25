/* Please create a parsing program that can take in a 16 byte stream of 1s and 0s, 
store the stream as one 16 byte register of data, and compare this data to presored data.
For now, please use constants for the prestored data that you may randomly chose just for testing purposes.*/

module parse(input clk, input end_of_sequence, input info);
  reg[127:0] pdata;
  output [127:0] result;
  
  
//store 16 byte stream

always @(posedge clk) begin
  case(info)
      2'b00 : pdata <= pdata; 
      2'b01 : pdata <={pdata[126:0, 1};
      2'b10 : pdata <={pdata[126:0, 0};
    default:
  endcase 
  pdata <= {pdata[126:0, in_data};
end

always @(posedge clk) begin
  if(end_of_sequence) begin
    result <= pdata;
  end
end

//Compare data to prestored data


module test (
	clock,
	reset,
	Y);
	
	input clock, reset;
	output Y;  
	
	parameter RESET_ACTIVE = 1'b0; //active high
	parameter SIZE = 3;
	parameter IDLE = 3'b000, STATE_1 = 3'b001, STATE_2 = 3'b010;
	
	reg [SIZE-1:0] current_state;  
	reg [SIZE-1:0] next_state;
	
	
	always@(posedge clock, posedge reset) //sequential process
		begin : sequential_process		
		if (reset == RESET_ACTIVE)
				current_state <= IDLE;
			else if (clock == 1'b1)
				current_state <= next_state;	   
		end	
		
	always@(next_state,current_state) //combinational process
		begin : combinational_process	 
			case(current_state)	
				IDLE:
				begin 
					next_state <= STATE_1;	
				end		
					
				STATE_1: 
				begin
					next_state <= STATE_2;
				end	  
				
				STATE_2: 
				begin
					next_state <= IDLE;
				end
			endcase
		end
			
		
		
endmodule
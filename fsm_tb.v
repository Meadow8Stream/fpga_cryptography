

`timescale 1 ns / 1 ps

module fsm_tb;  
	
	
	reg clock, reset, info, SPIin, spi_en, spi_clk, start;
	
	reg [2:0] spi_sel = 3'b000;
	
	reg [7:0] value;	 
	reg [7:0] bit_count = 8'h00; //$urandom; 
							 
	
	fsm UUT (	
		.reset(reset),		   
		.SPIin(SPIin),	
		.clock(clock),
		.spi_clk(spi_clk),
		.spi_en(spi_en)
	);	  
	
	
	
	initial begin 
	clock = 0; 
		forever begin
			#10 clock = ~clock;
	end end		
	
	initial begin 
	reset = 0; 
		forever begin
			#100 reset = 1;
	end end		
	
	
	always begin  
		#1000
		if (bit_count >= 7) 
			begin
				start <= 1'b0;
				bit_count <= 8'b00;	
				value <= $urandom;
			end	
		else start <= 1'b1;
	end
	
	assign spi_clock = clock;
	
	always @ (posedge clock) begin  
	SPIin <= 1'b0;
	spi_en <= 1'b0;	

	if (clock && start) begin
			if (spi_sel == 3'b000) begin 	  
				SPIin <= 1'b1;
				spi_en <= 1'b1;	  
				spi_sel <= 3'b001;		
			end else if (spi_sel == 3'b001) begin	
				SPIin <= value[7];
				value <= {value[6:0], value[7]};
				spi_en <= 1'b1;	
				spi_sel <= 3'b010;
			end else if (spi_sel == 3'b010) begin 	
				SPIin <= 1'b0;
				spi_en <= 1'b1;	 
				spi_sel <= 3'b000;	
				bit_count <= bit_count + 1;
				
			end
		end	
	end	
		
endmodule

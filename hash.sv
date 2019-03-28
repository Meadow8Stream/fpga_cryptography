module hash (
	clock,
	reset, 
	hash_en,
	bit_length,
	data);
	
	// INPUTs and OUTPUTs
	parameter SIZE = 63; //size of data - 1 = 64 - 1 = 63 (TEST)
	input clock, reset, hash_en; 	  
	input reg [SIZE:0] data, bit_length;

	reg [255:0] output_hash;  

	// TOP LEVEL CONTROL VARIABLES
	reg [2:0] control_selector; //IDLE 3'b000, PADDING 3'b001, PRE_PROC 3'b010, COMPRESS 3'b011, 
	reg padding_finished, pre_processing_finished, compression_finished; 
	reg [7:0] i, j, z, x, y, pad_count, index_0; //for loop variables
		
	// VARIABLES FOR DATA PADDING
	reg [SIZE+1:0] pre_0;
	reg [511:0] pre_1, m;

	// VARIABLES FOR PRE-PROCESSING
	reg [31:0] little_sigma_0, little_sigma_1;
	reg [31:0] w[63:0];

	// VARIABLES FOR COMPRESSION FUNCTION
	reg [31:0] ch, maj, sigma_0, sigma_1;	  
	reg [31:0] temp_1, temp_2;																			  
	reg [31:0] H[7:0];																													   
	reg [31:0] a, b, c, d, e, f, g, h, h_prev;
	reg [1:0] select; //to time updating variables correctly
				 	


	always@(posedge clock, reset) 
	begin : top_level		
		if(~reset) //active low
			control_selector <= {3'b000}; 
		else if (clock == 1'b1)	begin		   
			
			if (hash_en) begin
				control_selector <= 3'b001; //start padding
			end else if (padding_finished) begin
				control_selector <= 3'b010; //start pre_processing 		
			end else if (pre_processing_finished) begin
				control_selector <= 3'b011; //start compression 	
			end else if (compression_finished) begin
				control_selector <= 3'b000; //return to IDLE 	
			end
				
		end	
	end

	

	always@(posedge clock, reset)
	begin : data_padding		
		if(~reset) begin //active low
			pre_0 <= {9{1'b0}};	
			pre_1 <= {512{1'b0}};  
			m <= {512{1'b0}}; 
			pad_count <= {8{1'b0}};
			padding_finished <= 1'b0;
		end else if (clock == 1'b1) begin 
			padding_finished <= 1'b0;
			if (control_selector == 3'b001) begin  
				if (pad_count < 4) begin	
					pre_0 <= {data, 1'b1}; //concatenate 1
					pre_1 <= {pre_0, {9'd448 - (SIZE + 2'd2){1'b0}}}; //concatenate (448 - (SIZE+2)) 0's	   
					m <= {pre_1, bit_length}; //concatenate 64 bit length of data) 	
					pad_count <= pad_count + 1;
				end else begin	
					pad_count <= {8{1'b0}};
					padding_finished <= 1'b1;
				end	

			end	

		end	
	end
		
				
	
	always@(posedge clock, reset)
	begin : pre_processing		
		if(~reset) begin
			for (i=0; i<64; i=i+1) w[i] <= {32{1'b0}}; //sets all values of 2-D array to zero, w is 64 arrays that are 32 bits wide	
			little_sigma_0 <= {32{1'b0}};
			little_sigma_1 <= {32{1'b0}};
			z <= {8{1'b0}};	 									 		
			pre_processing_finished <= 1'b0;
		end else if (clock) begin 
			pre_processing_finished <= 1'b0;
			if (control_selector == 3'b010) begin	
				
				if (z <= 15) begin	
					w[z] <= m[511:480]; //places 32 bits of m into w 
					m <= {m[479:0], m[511:480]}; // shifts message values over	  
					z <= z + 1;
				end else if (z < 65) begin 
					little_sigma_0 <= {w[(z - 15)][6:0], w[z - 15][31:7]} ^ {w[z - 15][17:0], w[z - 15][31:18]} ^ (w[z - 15] >> 3);  
					little_sigma_1 <= {w[z - 2][16:0], w[z - 2][31:17]} ^ {w[z - 2][18:0], w[z - 2][31:19]} ^ (w[z - 2] >> 10);	 
					if (z > 16) w[z-1] <= w[z - 17] + little_sigma_0 + w[z - 8] + little_sigma_1;
					z <= z + 1;
				end else begin   
					pre_processing_finished <= 1'b1;
				end end		  	
			else if (control_selector == 3'b001) begin
				for (i=0; i<64; i=i+1) w[i] <= {32{1'b0}}; 
		  		z <= 0;	
			end
		end	
	end 
			
		
	
	always@(posedge clock, reset)
	begin : compression_function		
		if (~reset) begin //active high reset
			select <= 2'b00;
			output_hash <= {512{1'b0}};
			index_0 <= {8{1'b0}};
			ch <= {32{1'b0}};
			maj <= {32{1'b0}};
			sigma_0 <= {32{1'b0}};
			sigma_1 <= {32{1'b0}};
			temp_1 <= {32{1'b0}};									 
			temp_2 <= {32{1'b0}};
			a <= {32{1'b0}};		
			b <= {32{1'b0}};
			c <= {32{1'b0}};
			d <= {32{1'b0}};
			e <= {32{1'b0}};
			f <= {32{1'b0}};
			g <= {32{1'b0}};
			h <= {32{1'b0}};
			h_prev <= {32{1'b0}};
			compression_finished <= 1'b0;  
			for (x=0; x<8; x=x+1) H[x] <= 0; 		

		end else if (clock) begin  	
			compression_finished <= 1'b0;  	
			if (control_selector != 3'b011) begin //to initialize a, b, c, etc...
				index_0 <= {8{1'b0}};
				for (x=0; x<8; x=x+1) H[x] <= H_init[x];
				//for (y=0; y<8; y=y+1) begin	  							
				a <= H_init[0];		
				b <= H_init[1];
				c <= H_init[2];
				d <= H_init[3];
				e <= H_init[4];
				f <= H_init[5];
				g <= H_init[6];
				h <= H_init[7];
				h_prev <= H_init[7];
				ch <= (e & f) ^ (~e & g);  
				maj <= (a & b) ^ (a & c) ^ (b & c);
				sigma_0 <= {a[1:0], a[31:2]} ^ {a[12:0], a[31:13]} ^ {a[21:0], a[31:22]};
				sigma_1 <= {e[5:0], e[31:6]} ^ {e[10:0], e[31:11]} ^ {e[24:0], e[31:25]};		
				 
			end else if (control_selector == 3'b011) begin	  
				h_prev <= h;
				if (index_0 < 64) begin
					if (select == 2'b00) begin
					temp_1 <= h_prev + sigma_1 + ch + k[index_0] + w[index_0]; //temp_1 <= h + sigma_1 + ch + k[index_0] + w[index_0];
					temp_2 <= sigma_0 + maj;
					select <= 2'b01;
					end else if (select == 2'b01) begin
					h <= g;
					g <= f;
					f <= e;
					e <= d + temp_1;
					d <= c;
					c <= b;
					b <= a;
					a <= temp_1 + temp_2; 
					select <= 2'b10;
					end else if (select == 2'b10) begin
					ch <= (e & f) ^ (~e & g);  
					maj <= (a & b) ^ (a & c) ^ (b & c);
					sigma_0 <= {a[1:0], a[31:2]} ^ {a[12:0], a[31:13]} ^ {a[21:0], a[31:22]};
					sigma_1 <= {e[5:0], e[31:6]} ^ {e[10:0], e[31:11]} ^ {e[24:0], e[31:25]};
					index_0 <= index_0 + 1;	
					select <= 2'b00;
					end 

				end else if (index_0 == 64) begin
					H[0] <= a + H_init[0];
					H[1] <= b + H_init[1];
					H[2] <= c + H_init[2];
					H[3] <= d + H_init[3];
					H[4] <= e + H_init[4];
					H[5] <= f + H_init[5];
					H[6] <= g + H_init[6];
					H[7] <= h + H_init[7];	
					index_0 <= index_0 + 1;
				end else begin	
					output_hash <= {{{{{{{H[0], H[1]}, H[2]}, H[3]}, H[4]}, H[5]}, H[6]}, H[7]};	 
					compression_finished <= 1'b1;
				end  					 		
			end 
		end
	 end	

	
	
endmodule

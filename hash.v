
// SHA-256 algorithm		














/*

^	bitwise XOR
&	bitwise AND
|		bitwise OR
~		bitwise compliment
+		mod 2^32 addition
R^n		>>		right shift by n bits
S^n		right rotation by n bits   



six logical functions used:
Ch(x, y, z)= (x & y) ^ (~x & z)
Maj(x, y, z)=(x & y) ^ (x & z) ^ (y & z)

Sigma_0(x) = S^2(x) ^ S^13(x) ^ S^22(x)
Sigma_1(x) = S^6(x) ^ S^11(x) ^ S^25(x)
little_sigma_0(x) = S^7(x) ^ S^18(x) ^ R^3(x)
little_sigma_1(x) = S^17(x) ^ S^19(x) ^ R^10(x)	  

parameter ADDR_WIDTH = 8 ;
parameter RAM_DEPTH = 1 << ADDR_WIDTH;

s0 := (w[i-15] rightrotate 7) xor (w[i-15] rightrotate 18) xor (w[i-15] rightshift 3)
s1 := (w[i-2] rightrotate 17) xor (w[i-2] rightrotate 19) xor (w[i-2] rightshift 10)
w[i] := w[i-16] + s0 + w[i-7] + s1


																										  
A_out[15:0] = {A_in[0], A_in[15:1]}; // performs right rotate: 0,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1
*/



`include "constants.v"

module hash (
	clock,
	reset, 
	//data,
	Y);
	
	parameter SIZE = 127; //size of data - 1 
	
	input clock, reset; //, data; should be an input later
	output Y;  	
			   
	reg [SIZE-1:0] initial_padding;  
	reg [SIZE-1:0] padding_size;  
	//reg [a_size-1:0] i;	  		
	
	reg [31:0] ch, maj, sigma_0, sigma_1, little_sigma_0, little_sigma_1;	  
	
	reg [31:0] temp_1, temp_2; // NOTE MIGHT NOT BE 32 BITS?
	
	reg [7:0] index_0;
	
	//reg [a_size-1:0] a[0:a_index-1]; //[0:a_len] matrices of size [a_size-1:0] bits	 
	
	
	// H_n are the first 32 bits of the fractional parts of the square roots of the first eight prime numbers (i.e. 2, 3, 5, 7, 11, 13, 17, 19)
	reg [31:0] H[7:0];
	//initial H[0] = 32'h6a09e667;//, 32'hbb67ae85, 32'h3c6ef372, 32'ha54ff53a, 32'h510e527f, 32'h9b05688c, 32'h1f83d9ab, 32'h5be0cd19};
	reg [31:0] a, b, c, d, e, f, g, h;
	
	reg [31:0] data = 32'hda953d90; //data message
								
	//initial data = 32'hda953d90; //initial test value
	
	reg init_stb; //initialize data strobe
	reg [7:0] shift_var;
	reg [SIZE+1:0] pre_0;
	reg [511:0] pre_1, pre_2, m;
	initial shift_var = 8'b00000001;
		
	reg [31:0] w[63:0];	 
	
	reg [7:0] i, j, z, alpha, beta, gamma, delta; //for loop variables		   
///*		
	always@(posedge clock, reset) //data padding / hash preprocessing
		begin : data_padding		
		if(~reset) begin //active low
			pre_0 = {9{1'b0}};	
			pre_1 = {512{1'b0}};
			pre_2 = {512{1'b0}};
			m = {512{1'b0}};
		end else begin			   
			pre_0 = {data, 1'b1}; //concat 1
			pre_1 = {pre_0, 319'b0}; //concat (448 - (SIZE+1)) 0's 	   
			pre_2 = {pre_1, 64'h0000000000000020}; //concat 64 bit length of data, hex 20 (64 bit binary value of 128)
			//pre_2 = {pre_1, 64'h0000000000000080}; //concat 64 bit length of data 0000000000000080 (64 bit binary value of 128) 
			m = pre_2; //the message itself
			end
		end			
//*/		
		
		
	always@(posedge clock, reset) //data padding / hash preprocessing
		begin : pre_processing		
		if(~reset) begin
			for (i=0; i<64; i=i+1) w[i] <= {32{1'b0}}; //sets all values of 2-D array to zero, w is 64 arrays that are 32 bits wide	
			alpha = {8{1'b0}};
			beta = {8{1'b0}};	
			gamma = {8{1'b0}};
			delta = {8{1'b0}};
			little_sigma_0 = {32{1'b0}};
			little_sigma_1 = {32{1'b0}};
		end else begin
				
			for (j=0; j<16; j=j+1) begin
				w[j] <= m[31:0]; //places 32 bits of m into w 
				m =	{m[31:0], m[511:32]}; // shifts message values over
			end	 
			
			for (z=16; z<64; z=z+1) begin
				alpha = z - 15;	
				beta = z - 2;	
				gamma = z - 16;
				delta = z - 7;
				little_sigma_0 = {w[alpha][6:0], w[alpha][31:6]} ^ {w[alpha][17:0], w[alpha][31:18]} ^ {w[alpha][2:0], w[alpha][31:3]};
				little_sigma_1 = {w[beta][16:0], w[beta][31:17]} ^ {w[beta][18:0], w[beta][31:19]} ^ {w[beta][9:0], w[beta][31:10]};	
				w[z] = w[gamma] + little_sigma_0 + w[delta] + little_sigma_1;
			end
			
		end	end 		
		
		
		
		
		
		
		always@(posedge clock, posedge reset) //Sigma_0(a) = S^2(a) ^ S^13(a) ^ S^22(a)
		begin : sequential_process		
		if (reset) //active high reset
			begin  	   				
			index_0 = {8{1'b0}};
			ch = {32{1'b0}};
			maj = {32{1'b0}};
			sigma_0 = {32{1'b0}};
			sigma_1 = {32{1'b0}};
			temp_1 = {32{1'b0}};									 
			temp_2 = {32{1'b0}};
			a = {32{1'b0}};		
			b = {32{1'b0}};
			c = {32{1'b0}};
			d = {32{1'b0}};
			e = {32{1'b0}};
			f = {32{1'b0}};
			g = {32{1'b0}};
			h = {32{1'b0}};
			end
		else
			begin
				if (index_0 < 64) begin	//for loop, 0 -> 63 (64 iterations)	 
					index_0 = index_0 + 1;	  
					
					ch = (e & f) ^ (~e & g);  
					maj = (a & b) ^ (a & c) ^ (b & c);
					sigma_0 = {a[1:0], a[31:2]} ^ {a[12:0], a[31:13]} ^ {a[21:0], a[31:22]};
					sigma_1 = {e[5:0], e[31:6]} ^ {e[10:0], e[31:11]} ^ {e[24:0], e[31:25]};
					
					temp_1 = h + sigma_1 + ch + k(index_0) + w[index_0];
					temp_2 = sigma_0 + maj; 
					
					
					
					h = g;
					g = f;
					f = e;
					e = d + temp_1;
					d = c;
					c = b;
					b = a;
					a = temp_1 + temp_2;
				end else
					index_0 = {8{1'b0}};
				
			end
		end	 
		
		
		
		
		
		
		
				
		
		
		
		
		
//	always@(posedge clock, reset) //data padding / hash preprocessing
//		begin : sequential_process		
//		if(reset)
//			if(init_stb) begin
//			a = H[0];
//			b = H[1]; 
//			c = H[2]; 
//			d = H[3]; 
//			e = H[4]; 
//			f = H[5]; 
//			g = H[6]; 
//			h = H[7]; // note: h =/= H (case sensitive)	
//			end
//		end	 		
		
		//parameter ADDR_WIDTH = 8 ;
		//parameter RAM_DEPTH = 1 << ADDR_WIDTH;
		
		
		
		
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
//		always@(posedge clock, posedge reset) //data padding / hash preprocessing
//		begin : sequential_process		
//		if (reset == RESET_ACTIVE) begin			 
//			a[0][a_size-1:0]  = {8{1'b0}};	
//			a[1][a_size-1:0]  = {8{1'b0}};	
//			i = 2'b0;
//		end else if (clock == 1'b1) begin	
//			if (i < a_index) begin
//				a[i]  = ~a[i];
//				i = i + 1'b1;
//			end else if (i == a_index) begin
//					i = 2'b0;
//				end 
//		end end
	
		
/*		
		
		
reg [31:0] ch, maj;		
		
// Ch(e, f, g)= (e & f) ^ (~e & g)
ch = {32{1'b0}};			   	
ch = (e & f) ^ (~e & g);
		
//Maj(a, b, c) = (a & b) ^ (a & c) ^ (b & c) 
maj = {32{1'b0}};
maj = (a & b) ^ (a & c) ^ (b & c); 		
		
//Sigma_0(a) = S^2(a) ^ S^13(a) ^ S^22(a)
for loop 2 times
s_0[31:0] = {a[0], a[15:1]}; // performs right rotate: 0,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1

for loop 13 times
s_0[31:0] = {a[0], a[15:1]}; // performs right rotate: 0,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1   

for loop 22 times
s_0[31:0] = {a[0], a[15:1]}; // performs right rotate: 0,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1



//Sigma_1(e) = S^6(e) ^ S^11(e) ^ S^25(e)	
for loop 6 times
s_1[31:0] = {e[0], e[15:1]}; //performs right rotate: 0,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1

for loop 11 times
s_1[31:0] = {e[0], e[15:1]}; // performs right rotate: 0,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1   

for loop 25 times
s_1[31:0] = {e[0], e[15:1]}; // performs right rotate: 0,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1



s_1[31:0] = {e[5:0], e[31:6]} ^ {e[10:0], e[31:11]} ^ {e[24:0], e[15:25]};
s_0[31:0] = {a[1:0], a[31:2]} ^ {a[12:0], a[31:13]} ^ {a[21:0], a[15:22]};

																				 
temp1 := h + S1 + ch + k[i] + w[i]									 )
temp2 := S0 + maj




		
		
*/	




																							 

		
	
//	always@(posedge clock, posedge reset) //data padding / hash preprocessing
//		begin : sequential_process		
//		if (reset == RESET_ACTIVE)
//			begin
//			initial_padding <= assign mywire = {128{1'b0}}; 
//			padding_size <= {128{1'b0}};	
//			end
//		else if (clock == 1'b1)
//			begin
//			//initial_padding <= {data, 1b'1};  //concatenation operator, concat 1 to end of data		
//			//padding_size <= 448-(size + 1);
//			end
//		end	 
//		
//		
//	always@(posedge clock, posedge reset) //data padding / hash preprocessing
//		begin : sequential_process		
//		if (reset == RESET_ACTIVE)
//			begin
//			initial_padding <= assign mywire = {128{1'b0}}; 
//			padding_size <= {128{1'b0}};	
//			end
//		else if (clock == 1'b1)
//			begin
//			//initial_padding <= {data, 1b'1};  //concatenation operator, concat 1 to end of data		
//			//padding_size <= 448-(size + 1);
//			end
//		end
		
			
		
endmodule

module brent_kung_adder (in1, in2, cin, out);

	input [31:0] in1, in2;
	input cin;
	output [31:0] out;
	
	reg [31:0] pi_1, pi_2, pi_3, pi_4, pi_5, pi_6; 
	reg [31:0] gi_1, gi_2, gi_3, gi_4, gi_5, gi_6; 
	
	reg [32:1] cout;
	
	integer i=0;
	
	always@(*)
	begin
//		Level:1
		pi_1 = in1 ^ in2 ;
		gi_1 = in1 & in2 ;
	
//		Level:2
		for(i=0; i<16; i=i+1)
		begin
		
			pi_2[i] = pi_1[2*i+1] & pi_1[2*i] ;
			gi_2[i] = gi_1[2*i+1] + pi_1[2*i+1] & gi_1[2*i] ;
			
		end
	
//		Level:3
		for(i=0; i<8; i=i+1)
		begin
	
			pi_3[i] = pi_2[2*i+1] & pi_2[2*i] ;
			gi_3[i] = gi_2[2*i+1] + pi_2[2*i+1] & gi_2[2*i] ;
			
		end
		
//		Level:4
		for(i=0; i<4; i=i+1)
		begin

			pi_4[i] = pi_3[2*i+1] & pi_3[2*i] ;
			gi_4[i] = gi_3[2*i+1] + pi_3[2*i+1] & gi_3[2*i] ;
			
		end
		
//		Level:5
		for(i=0; i<2; i=i+1)
		begin
		
			pi_5[i] = pi_4[2*i+1] & pi_4[2*i] ;
			gi_5[i] = gi_4[2*i+1] + pi_4[2*i+1] & gi_4[2*i] ;
			
		end		
		
//		Level:6
		for(i=0; i<1; i=i+1)
		begin

			pi_6[i] = pi_5[2*i+1] & pi_5[2*i] ;
			gi_6[i] = gi_5[2*i+1] + pi_5[2*i+1] & gi_5[2*i] ;
			
		end		
	
	end
	
	always@(*)
	begin
	
//		Stage:1		
		cout[1] = gi_1[0] + pi_1[0] & cin;
		cout[2] = gi_2[0] + pi_2[0] & cin;
		cout[4] = gi_3[0] + pi_3[0] & cin;
		cout[8] = gi_4[0] + pi_4[0] & cin;
		cout[16] = gi_5[0] + pi_5[0] & cin;
		cout[32] = gi_6[0] + pi_6[0] & cin;
		
		
//		Stage:2		
		cout[3] = gi_1[2] + pi_1[2] & cout[2];
		cout[5] = gi_1[4] + pi_1[4] & cout[4];
		cout[9] = gi_1[8] + pi_1[8] & cout[8];
		cout[17] = gi_1[16] + pi_1[16] & cout[16];
		
		cout[6] = gi_2[2] + pi_2[2] & cout[4];
		cout[10] = gi_2[4] + pi_2[4] & cout[8];
		cout[18] = gi_2[8] + pi_2[8] & cout[16];
		
		cout[24] = gi_4[2] + pi_4[2] & cout[16];
		

//		Stage:3
		cout[7] = gi_1[6] + pi_1[6] & cout[6];
		cout[11] = gi_1[10] + pi_1[10] & cout[10];
		cout[19] = gi_1[18] + pi_1[18] & cout[18];
		cout[25] = gi_1[24] + pi_1[24] & cout[24];
		
		cout[12] = gi_2[5] + pi_2[5] & cout[10];
		cout[20] = gi_2[9] + pi_2[9] & cout[18];
		cout[26] = gi_2[12] + pi_2[12] & cout[24];
		
		cout[28] = gi_3[6] + pi_3[6] & cout[24];
		
		
//		Stage:4		
		cout[13] = gi_1[12] + pi_1[12] & cout[12];
		cout[21] = gi_1[20] + pi_1[20] & cout[20];
		cout[27] = gi_1[26] + pi_1[26] & cout[26];
		cout[29] = gi_1[28] + pi_1[28] & cout[28];
		
		cout[14] = gi_2[6] + pi_2[6] & cout[12];
		cout[22] = gi_2[10] + pi_2[10] & cout[20];
		cout[30] = gi_2[14] + pi_2[14] & cout[28];

//		Stage:5		
		cout[15] = gi_1[14] + pi_1[14] & cout[14];
		cout[23] = gi_1[22] + pi_1[22] & cout[22];
		cout[31] = gi_1[30] + pi_1[30] & cout[30];
		
	end
	
	assign out[31:0] = pi_1[31:0] ^ {cout[31:1],cin};
	
endmodule

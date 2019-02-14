module stopWatch(clk, switch, in_data, rst_out, out_data);
	input			clk;
	input switch;
	input [11:0] in_data;
	output rst_out;
	output [23:0] out_data;
	reg rst_out = 0;
	reg [23:0] out_data = 0;
	reg		[31:0]	cycle_cnt = 0;
	reg		[6:0]	min = 0;
	reg		[6:0]	sec = 0;
	reg		[7:0]	tm_sec = 0;
	
	reg		[3:0]	min_10, min_1, sec_10, sec_1, tm_sec_10, tm_sec_1;
	
	reg				fnd_clk = 0;
	reg		[12:0]	fnd_cnt = 0;
	reg [1:0] state = 0;
	
	parameter disabled = 0;
	parameter reset_state = 1;
	parameter count_state = 2;
	parameter stop_state = 3;
	
	
	always @ (posedge clk) begin
	 if(switch == 1 && state == disabled) begin //switch case
	   state <= reset_state;
	 end
	 else begin
	   state <= disabled;
	 end
	 //in_data case
	 if (in_data == 12'b0010_0000_0000) begin //*
	   rst_out <= 1;
	   state <= reset_state;
	 end
	 else if (in_data == 12'b1000_0000_0000) begin //#
	   rst_out <= 1;
	   if (state == count_state)
	     state <= stop_state;
	   else 
	     state <= count_state;
	 end
	 else if (in_data == 12'b0000_0000_0000) begin
	   rst_out <= 0;
	 end
	 else begin
	   rst_out <= 0;
	 end
	 //reset_state initialization
	 if (state == reset_state) begin
	   rst_out <= 0;
	   out_data <= 0;
     cycle_cnt <= 0;
     min <= 0;
     sec <= 0;
     tm_sec <= 0;

     min_10 <= 0;
     min_1 <= 0;
     sec_10 <= 0;
     sec_1 <= 0;
     tm_sec_10 <= 0;
     tm_sec_1 <= 0;

     fnd_clk <= 0;
     fnd_cnt <= 0;
	 end
	 //slow clock
	 if (state == count_state) begin
		  if (cycle_cnt == 0)			fnd_clk = 1;
		  else if (cycle_cnt == 32) begin	fnd_clk = 0; fnd_cnt = fnd_cnt + 1; end
		  cycle_cnt = cycle_cnt + 1;
		  if (cycle_cnt == 64)		cycle_cnt = 0;
	 end
	 
	 if (fnd_cnt == 5120)	begin	
		  tm_sec = tm_sec + 1;
		  fnd_cnt = 0;
		  tm_sec_10 = tm_sec / 10;
		  tm_sec_1 = tm_sec % 10;
	 end
	 
	 if (tm_sec == 100) begin	
		  tm_sec = 0;	
		  tm_sec_10 = 0;	
		  tm_sec_1 = 0;				
		  sec = sec + 1;			
		  sec_10 = sec / 10;	
		  sec_1 = sec % 10;	
	 end
	 
	 if (sec == 60) begin	
		  sec = 0;				
		  sec_10 = 0;		
		  sec_1 = 0;					
		  min = min + 1;			
		  min_10 = min / 10;	
		  min_1 = min % 10;	
	 end
	 
	 if (min == 60) begin 	
		 min <= 0;
     sec <= 0;
     tm_sec <= 0;

     min_10 <= 0;
     min_1 <= 0;
     sec_10 <= 0;
     sec_1 <= 0;
     tm_sec_10 <= 0;
     tm_sec_1 <= 0;				
	 end
	 
	 out_data[3:0] <= tm_sec_1; 
	 out_data[7:4] <= tm_sec_10;
	 out_data[11:8] <= sec_1;
	 out_data[15:12] <= sec_10;
	 out_data[19:16] <= min_1;
	 out_data[23:20] <= min_10;
	end
endmodule

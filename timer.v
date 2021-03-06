module timer(clk, switch, in_data, rst_out, light_out, out_data);
  input clk;
  input switch;
  input [11:0] in_data;
  output rst_out;
  output light_out;
  output [23:0] out_data;
  reg rst_out = 0;
  reg light_out = 0;
  reg [23:0] out_data = 0;
  reg		[31:0]	cycle_cnt = 0;
  reg		[6:0]	min = 0;
	reg		[6:0]	sec = 0;
	reg		[7:0]	tm_sec = 0;
	reg [3:0] tmp_data = 0;
	
	reg		[3:0]	min_10, min_1, sec_10, sec_1, tm_sec_10, tm_sec_1;
	
	reg				fnd_clk = 0;
	reg		[12:0]	fnd_cnt = 0;
	
	reg [2:0] state = 0;
	
	parameter disabled = 0;
  parameter reset_state = 1;
  parameter key_input_state = 2;
  parameter ready_state = 3;
  parameter countdown_state = 4;
  parameter zero_state = 5;
  
	
	always @ (posedge clk) begin
	  //mode
	 if(switch == 0 && state==disabled) begin
	   state <= reset_state;
	 end
	 else begin
	   state <= disabled;
	 end
	 //in_data
	 if (in_data == 12'b0010_0000_0000) begin //*
	   case (state)
	     reset_state: begin
	       rst_out <= 1;
	       state <= key_input_state;
	     end
	     key_input_state: begin
	       rst_out <= 1;
	       state <= ready_state;
	     end
	     ready_state: begin
	       rst_out <= 1;
	       state <= reset_state;
	     end
	     default: begin
	       rst_out <= 1;
	       state <= reset_state;
	     end
	   endcase  
	 end
	 else if (in_data == 12'b1000_0000_0000) begin //#
	   case (state)
	     ready_state: begin
	       rst_out <= 1;
	       state <= countdown_state;
	     end
	     countdown_state: begin
	       rst_out <= 1;
	       state <= ready_state;
	     end
	     zero_state: begin
	       rst_out <= 1;
	       state <= reset_state;
	     end
	     default: begin
	       rst_out <= 1;
	       state <= reset_state;
	     end
	   endcase
	 end
	 else if (in_data == 12'b0000_0000_0000) begin //default signal
	   rst_out <= 0;
	 end
	 else begin //Other keys
	   if (state == key_input_state) begin
	     rst_out <= 1;
	     case (in_data)
	       12'b0000_0000_0001: begin //1
	         tmp_data <= 1;
	       end
	       12'b0000_0000_0010: begin  //2
	         tmp_data <= 2;
	       end
	       12'b0000_0000_0100: begin  //3
	         tmp_data <= 3;
	       end
	       12'b0000_0000_1000: begin  //4
	         tmp_data <= 4;
	       end
	       12'b0000_0001_0000: begin  //5
	         tmp_data <= 5;
	       end
	       12'b0000_0010_0000: begin  //6
	         tmp_data <= 6;
	       end
	       12'b0000_0100_0000: begin  //7
	         tmp_data <= 7;
	       end
	       12'b0000_1000_0000: begin  //8
	         tmp_data <= 8;
	       end
	       12'b0001_0000_0000: begin  //9
	         tmp_data <= 9;
	       end
	       12'b0100_0000_0000: begin  //0
	         tmp_data <= 0;
	       end
	       default begin
	         tmp_data <= 0;
	       end
	     endcase
	     out_data <= out_data << 4;
	     out_data[3:0] <= tmp_data;
	     tm_sec_1 <= out_data[3:0];
	     tm_sec_10 <= out_data[7:4];
	     sec_1 <= out_data[11:8];
	     sec_10 <= out_data[15:12];
	     min_1 <= out_data[19:16];
	     min_10 <= out_data[23:20];  
	   end    
	  end
	  //reset
	  if(state == reset_state) begin
	    rst_out <= 0;
      light_out <= 0;
      out_data <= 0;
      cycle_cnt <= 0;
      min <= 0;
      sec <= 0;
      tm_sec <= 0;
      tmp_data <= 0;
      min_10 <= 0;
      min_1 <= 0;
      sec_10 <= 0;
      sec_1 <= 0;
      tm_sec_10 <= 0;
      tm_sec_1 <= 0;
      fnd_clk <= 0;
	  end
	  //slow clock
	  if (state == countdown_state || state == zero_state) begin
		  if (cycle_cnt == 0)			fnd_clk = 1;
		  else if (cycle_cnt == 32) begin	fnd_clk = 0; fnd_cnt = fnd_cnt+1; end
		  cycle_cnt = cycle_cnt + 1;
		  if (cycle_cnt == 64)		cycle_cnt = 0;
	  end
	  
	  if (state == countdown_state && min==0 && sec==0 && tm_sec==0) begin
		  state <= zero_state;
		  fnd_cnt <= 0;
		  light_out <= 1;
		end
		if (fnd_cnt == 5120 && state == countdown_state)	begin	
		  tm_sec = tm_sec - 1;
		  fnd_cnt = 0;
		  tm_sec_10 = tm_sec / 10;
		  tm_sec_1 = tm_sec % 10;
		end
		
		if (tm_sec == 0 && state == countdown_state) begin	
		  tm_sec = 99;	
		  tm_sec_10 = 9;	
		  tm_sec_1 = 9;				
		  sec = sec - 1;			
		  sec_10 = sec / 10;	
		  sec_1 = sec % 10;	
		end
		
		if (sec == 0 && state == countdown_state) begin	
		  sec = 59;				
		  sec_10 = 5;		
		  sec_1 = 9;					
		  min = min - 1;			
		  min_10 = min / 10;	
		  min_1 = min % 10;	
		end
		
		if (min == 0 && state == countdown_state) begin 			
		  min_10 = 0;		
		  min_1 = 0;					
		end
		
		if (state == zero_state) begin
	   if (fnd_cnt == 512000)	begin	
	     if (light_out) light_out <= 0;
	     else light_out <= 1;
		   fnd_cnt = 0;
		 end
	  end
	  //out data assign
	  if(state != key_input_state) begin
	   out_data[3:0] <= tm_sec_1; 
	   out_data[7:4] <= tm_sec_10;
	   out_data[11:8] <= sec_1;
	   out_data[15:12] <= sec_10;
	   out_data[19:16] <= min_1;
	   out_data[23:20] <= min_10;
	  end
	end
endmodule
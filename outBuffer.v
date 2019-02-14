module outBuffer(in_data, clk, seg_data, seg_position);
  input [23:0] in_data;
  input clk;
  output [7:0] seg_data;
  output [5:0] seg_position;
  reg		[13:0]	clk_counter;
	reg				slow_clk;
	reg		[2:0]	state;
	reg [7:0] seg_data;
	reg [5:0] seg_position;
	
	reg		[3:0]	min_10, min_1, sec_10, sec_1, tm_10, tm_1;
	
	
	
  parameter tm_1_s = 0;
  parameter tm_10_s = 1;
  parameter sec_1_s = 2;
  parameter sec_10_s = 3;
  parameter min_1_s = 4;
  parameter min_10_s = 5;
  
  
  function [7:0] myfunc;
    input [3:0] digit;
    begin
      case (digit)
        0: myfunc = 8'b11111100; //0
        1: myfunc = 8'b01100000;//1
        2: myfunc = 8'b11011010; //2
        3: myfunc = 8'b11110010; //3
        4: myfunc = 8'b01100110; //4
        5: myfunc = 8'b10110110; //5
        6: myfunc = 8'b00111110; //6
        7: myfunc = 8'b11100000; //7
        8: myfunc = 8'b11111110; //8
        9: myfunc = 8'b11100110; //9
        default: myfunc = 8'b00000000;
      endcase 
    end
  endfunction
  
  always @(posedge clk) begin
		if (clk_counter < 8000)		slow_clk = 1;
		else						slow_clk = 0;
		
		clk_counter = clk_counter + 1;
		if (clk_counter == 16000)	clk_counter = 0;
	end
	
	always @ (posedge clk) begin
	  tm_1 <= in_data[3:0];
	  tm_10 <= in_data[7:4];
	  sec_1 <= in_data[11:8];
	  sec_10 <= in_data[15:12];
	  min_1 <= in_data[19:16];
	  min_10 <= in_data[23:20];
	end
	
  always @(posedge slow_clk) begin
		case (state)
			tm_1_s: begin	seg_data = myfunc(tm_1);	seg_position = 6'b111110;	end
			tm_10_s: begin	seg_data = myfunc(tm_10);	seg_position = 6'b111101;	end
			sec_1_s: begin	seg_data = myfunc(sec_1);	seg_position = 6'b111011;	end
			sec_10_s: begin	seg_data = myfunc(sec_10);	seg_position = 6'b110111;	end
			min_1_s: begin	seg_data = myfunc(min_1);	seg_position = 6'b101111;	end
			min_10_s: begin	seg_data = myfunc(min_10);	seg_position = 6'b011111;	end
		endcase
		state = state + 1;
		if (state == 6)	state = 0;
	end
	
endmodule
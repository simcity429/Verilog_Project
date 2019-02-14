module topModule(clk, switch, key_row, key_col, seg_data, seg_position, light_out);
  input clk, switch;
  input [3:0] key_row;
  output [2:0] key_col;
  output [7:0] seg_data;
  output [5:0] seg_position;
  output [7:0] light_out;
  
  wire [11:0] scannerToDemux;
  wire scannerRst;
  wire [11:0] toSWData, toTimerData;
  wire [23:0] fromSWData, fromTimerData, finalData;
  wire rst_out_s, rst_out_t;
  wire light;
  
  keypad_scan myks(clk, scannerRst, key_col, key_row, scannerToDemux);
  demux mydemux(scannerToDemux, switch, clk, toSWData, toTimerData);
  stopWatch mysw(clk, switch, toSWData, rst_out_s, fromSWData);
  timer mytimer(clk, switch, toTimerData, rst_out_t, light, fromTimerData);
  smallMux mysmallmux(rst_out_s, rst_out_t, switch, clk, scannerRst);
  light_distributor myld(light, clk, light_out);
  mux mymux(fromSWData, fromTimerData, switch, clk, finalData);
  outBuffer mybuffer(finalData, clk, seg_data, seg_position);
endmodule
  

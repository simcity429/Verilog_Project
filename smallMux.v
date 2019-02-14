module smallMux(s, t, switch, clk, out);
  input s, t, switch;
  input clk;
  output out;
  reg out;
  always @ (posedge clk) begin
    if(switch == 0) out <= t;
    else out <= s;
  end
endmodule
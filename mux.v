module mux(swData, tData, switch, clk, O);
  input [23:0] swData, tData;
  input switch;
  input clk;
  output [23:0] O;
  reg [23:0] O;
  always @ (posedge clk) begin
    if (switch) O <= swData;
    else O <= tData;
  end
endmodule
  

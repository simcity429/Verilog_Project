module demux(inData, switch, clk, sw, t);
  input [11:0] inData;
  input switch, clk;
  output [11:0] sw, t;
  reg [11:0] sw, t;
  always @ (posedge clk) begin
    if (switch) begin
      sw <= inData;
      t <= 0;
    end
    else begin
    sw <= 0;
    t <= inData;
    end
  end
endmodule

module light_distributor(i, clk, o);
  input i, clk;
  output [7:0] o;
  reg [7:0] o;
  always @ (posedge clk) begin
    if (i==1) begin
      o[0] <= 1;
      o[1] <= 1;
      o[2] <= 1;
      o[3] <= 1;
      o[4] <= 1;
      o[5] <= 1;
      o[6] <= 1;
      o[7] <= 1;
    end
    else begin
      o[0] <= 0;
      o[1] <= 0;
      o[2] <= 0;
      o[3] <= 0;
      o[4] <= 0;
      o[5] <= 0;
      o[6] <= 0;
      o[7] <= 0;
    end
  end
endmodule

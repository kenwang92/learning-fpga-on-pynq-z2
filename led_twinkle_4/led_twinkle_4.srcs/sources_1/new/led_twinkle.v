module led_twinkle(
    Clk,
    Reset_n,
    Led
  );
  input Clk;
  input Reset_n;
  output reg Led;

  parameter MCNT = 62_500_000-1;

  reg [25:0]counter;
  always@(posedge Clk or posedge Reset_n)
    if (Reset_n)
      counter <= 0;
    else if(counter==MCNT)
      counter <=0;
    else
      counter<=counter+1'd1;
  always@(posedge Clk or posedge Reset_n)
    if (Reset_n)
      Led<=1'd0;
    else if(counter==MCNT)
      Led<=!Led;
endmodule

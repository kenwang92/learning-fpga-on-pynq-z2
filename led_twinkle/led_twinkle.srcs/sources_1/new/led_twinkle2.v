// led特定順序切換電平(範例)
module led_twinkle2(
    Clk,
    Reset_n,
    Led
  );
  input Clk;
  input Reset_n;
  output reg Led;

  parameter TIME_UNIT_MS=1000;

  reg [28:0]counter;
  always@(posedge Clk or posedge Reset_n)
    if (Reset_n)
      counter <= 0;
    else if(counter==312_500*TIME_UNIT_MS-1)
      counter <=0;
    else
      counter<=counter+1'd1;

  always@(posedge Clk or posedge Reset_n)
    if (Reset_n)
      Led<=1'd0;
    else if(counter==0)
      Led<=1'd1;
    else if(counter==31_250*TIME_UNIT_MS)
      Led<=1'd0;
    else if(counter==93_750*TIME_UNIT_MS)
      Led<=1'd1;
    else if(counter==187_500*TIME_UNIT_MS)
      Led<=1'd0;
endmodule

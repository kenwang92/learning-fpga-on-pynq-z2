// led正常閃爍，占空比25%
module led_twinkle1(
    Clk,
    Reset_n,
    Led
  );
  input Clk;
  input Reset_n;
  output reg Led;

  parameter MCNT=125_000_000-1;
  parameter HCNT=31_250_000;

  reg [26:0]counter;
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
  // 範例
  // else if(counter==0)
  //   Led<=1'd1;
  // else if(counter==HCNT)
  //   Led<=1'd0;
    else
      Led<=(counter<(HCNT+1))?1'd1:1'd0;
endmodule

// led依照撥碼開關切換電平(自己寫)
module led_twinkle5(
    SW,
    Clk,
    Reset_n,
    Led
  );
  input [7:0]SW;
  input Clk;
  input Reset_n;
  output reg Led;

  parameter TIME_UNIT_MS=1000;

  reg [28:0]counter;

  // 電平計數器
  reg [2:0]levelcounter;

  always@(posedge Clk or posedge Reset_n)
    if (Reset_n)
      counter <= 0;
    else if(counter==31_250*TIME_UNIT_MS-1)
      counter <=0;
    else
      counter<=counter+1'd1;
  //   counter數到31_250*TIME_UNIT_MS-1等於0.25s
  //   levelcounter不用清零，溢位自動清零
  always@(posedge Clk or posedge Reset_n)
    if (Reset_n)
      levelcounter<=0;
    else if(counter==31_250*TIME_UNIT_MS-1)
      levelcounter<=levelcounter+1'b1;

  always@(posedge Clk or posedge Reset_n)
    if (Reset_n)
      Led<=1'd0;
    else
      Led<=SW[levelcounter];
endmodule

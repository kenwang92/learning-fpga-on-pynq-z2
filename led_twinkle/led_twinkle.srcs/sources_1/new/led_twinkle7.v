// led依照撥碼開關切換電平並增加空閒時間(自己寫)
module led_twinkle7(
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
  reg [3:0]levelcounter;

  // 3s counter
  always@(posedge Clk or posedge Reset_n)
    if (Reset_n)
      counter <= 0;
    else if(counter==31_250*TIME_UNIT_MS-1)
      counter <=0;
    else
      counter<=counter+1'd1;

  always@(posedge Clk or posedge Reset_n)
    if (Reset_n)
      levelcounter<=0;
  // 0.25s重置levelcounter
    else if(counter==31_250*TIME_UNIT_MS-1)
      levelcounter<=(levelcounter==11)?0:levelcounter+1'b1;
  always@(posedge Clk or posedge Reset_n)
    if (Reset_n)
      Led<=1'd0;
  // 空閒時間
    else if(levelcounter<4)
      Led<=0;
    else
      Led<=SW[levelcounter-4];
endmodule

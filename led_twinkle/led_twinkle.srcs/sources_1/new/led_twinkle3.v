// led特定順序切換電平2(自己寫)
module led_twinkle3(
    Clk,
    Reset_n,
    Led
  );
  input Clk;
  input Reset_n;
  output reg Led;

  parameter TIME_UNIT_MS=1000;

  reg [28:0]counter;

  // 電平順序
  reg [9:0]level=10'b1001110000;

  // 電平計數器
  reg [3:0]levelcounter;

  always@(posedge Clk or posedge Reset_n)
    if (Reset_n)
      counter <= 0;
    else if(counter==31_250*TIME_UNIT_MS-1)
      counter <=0;
    else
      counter<=counter+1'd1;
  always@(posedge Clk or posedge Reset_n)
    if (Reset_n)
    begin
      Led<=1'd0;
      levelcounter<=1'd0;
    end
    else if(counter==31_250*TIME_UNIT_MS-1)
      levelcounter<=(levelcounter!=9)?(levelcounter+1'b1):0;
    else
      // 依序取出電平輸出至Led
      Led<=level[9-levelcounter];
endmodule

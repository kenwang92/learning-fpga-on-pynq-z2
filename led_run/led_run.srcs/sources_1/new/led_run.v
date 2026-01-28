module led_run (
    Clk,
    Reset_n,
    Led
  );
  input Clk;
  input Reset_n;
  output reg [7:0]Led;
  reg [25:0]counter;
  always @(posedge Clk or posedge Reset_n)
  begin
    if(Reset_n)
      counter<=0;
    else if(counter==62_500_000-1)
      counter<=0;
    else
      counter<=counter+1'd1;
  end

  always @(posedge Clk or posedge Reset_n)
  begin
    if(Reset_n)
      Led<=6'b0000_0001;
    else if(counter==62_500_000-1)
    begin
      // 溢位時重置為8'b0000_0001
      if ((Led==6'b1000_0000)|(Led==6'b0000_0000))
        Led<=6'b0000_0001;
      else
        Led<=Led<<1;// 左移
    end
    // Led<=Led;// 不用寫，因為D flip-flop物理上會保留當前值
  end
endmodule

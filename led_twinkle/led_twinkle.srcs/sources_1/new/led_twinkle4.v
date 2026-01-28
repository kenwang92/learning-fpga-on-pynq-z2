// led特定順序切換電平2(範例)
module led_twinkle4(
    Clk,
    Reset_n,
    Led
  );
  input Clk;
  input Reset_n;
  output reg Led;

  parameter TIME_UNIT_MS=1000;

  reg [25:0]counter0;
  reg [3:0]counter1;

  always@(posedge Clk or posedge Reset_n)
    if (Reset_n)
      counter0 <= 0;
    else if(counter0==31_250*TIME_UNIT_MS-1)
      counter0 <=0;
    else
      counter0<=counter0+1'd1;
  always@(posedge Clk or posedge Reset_n)
    if (Reset_n)
    begin
      counter1<=1'd0;
    end
    else if(counter0==31_250*TIME_UNIT_MS-1)
    begin
      if(counter1==9)
        counter1<=0;
      else
        counter1<=counter1+1'b1;
    end
    else
      counter1<=counter1;
  always@(posedge Clk or posedge Reset_n)
    if(Reset_n)
      Led<=1'd0;
    else
    begin
      case(counter1)
        0:
          Led<=1'd1;
        1:
          Led<=1'd0;
        2:
          Led<=1'd0;
        3:
          Led<=1'd1;
        4:
          Led<=1'd1;
        5:
          Led<=1'd1;
        6:
          Led<=1'd0;
        7:
          Led<=1'd0;
        8:
          Led<=1'd0;
        9:
          Led<=1'd0;
        default:
          Led<=Led;
      endcase
    end
endmodule

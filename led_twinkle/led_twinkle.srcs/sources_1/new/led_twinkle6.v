// led依照撥碼開關切換電平2(範例)
module led_twinkle6(
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

  reg [25:0]counter0;
  reg [2:0]counter1;

  always@(posedge Clk or posedge Reset_n)
    if (Reset_n)
      counter0 <= 0;
    else if(counter0==31_250*TIME_UNIT_MS-1)
      counter0 <=0;
    else
      counter0<=counter0+1'd1;
  always@(posedge Clk or posedge Reset_n)
    if (Reset_n)
      counter1<=1'd0;
    else if(counter0==31_250*TIME_UNIT_MS-1)
        counter1<=counter1+1'b1;
  always@(posedge Clk or posedge Reset_n)
    if(Reset_n)
      Led<=1'd0;
    else
    begin
      case(counter1)
        0:
          Led<=SW[0];
        1:
          Led<=SW[1];
        2:
          Led<=SW[2];
        3:
          Led<=SW[3];
        4:
          Led<=SW[4];
        5:
          Led<=SW[5];
        6:
          Led<=SW[6];
        7:
          Led<=SW[7];
        default:
          Led<=Led;
      endcase
    end
endmodule

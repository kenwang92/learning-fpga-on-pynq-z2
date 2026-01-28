// led依照撥碼開關切換電平並增加空閒時間(範例)
module led_twinkle9(
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
  parameter MCNT0 = 31_250;
  parameter MCNT2 = 125_000;

  reg [24:0]counter0;// 0.25s 31250000
  reg [26:0]counter2;// 1s   125000000
  reg [2:0]levelcounter;
  reg en_counter0;
  reg en_counter2;
  // 0.25s
  always@(posedge Clk or posedge Reset_n)
    if (Reset_n)
      counter0 <= 1'd0;
    else if(en_counter0)
      if(counter0==MCNT0*TIME_UNIT_MS-1)
        counter0 <=1'd0;
      else
        counter0<=counter0+1'd1;
    else
      counter0<=1'd0;
  // 1s
  always@(posedge Clk or posedge Reset_n)
    if (Reset_n)
      counter2<=1'd0;
    else if(en_counter2)
      if(counter2==MCNT2*TIME_UNIT_MS-1)
        counter2 <=1'd0;
      else
        counter2<=counter2+1'd1;
    else
      counter2<=1'd0;

  always@(posedge Clk or posedge Reset_n)
    if(Reset_n)
      en_counter2<=1'd1;
    else if((levelcounter==7)&&(counter0==MCNT0*TIME_UNIT_MS-1))
      en_counter2<=1'd1;
    else if(counter2==MCNT2*TIME_UNIT_MS-1)
      en_counter2<=1'd0;

  always@(posedge Clk or posedge Reset_n)
    if(Reset_n)
      en_counter0<=1'd0;
    else if(counter2==MCNT2*TIME_UNIT_MS-1)
      en_counter0<=1'd1;
    else if((levelcounter==7)&&(counter0==MCNT0*TIME_UNIT_MS-1))
      en_counter0<=1'd0;

  always@(posedge Clk or posedge Reset_n)
    if(Reset_n)
      levelcounter<=1'd0;
    else if(counter0==MCNT0*TIME_UNIT_MS-1)
      levelcounter<=levelcounter+1'd1;

  always@(posedge Clk or posedge Reset_n)
    if(Reset_n)
      Led<=1'd0;
    else if(en_counter2==1)
      Led<=1'd0;
    else
    begin
      case(levelcounter)
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

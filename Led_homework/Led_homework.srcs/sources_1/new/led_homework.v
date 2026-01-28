module led_homework (
    Clk,
    Reset_n,
    Led
  );
  input Clk;
  input Reset_n;
  output reg [3:0]Led;

  parameter MCNT = 62_500_000-1;
  parameter MCNT1 = 31_250_000-1;
  parameter MCNT2 = 15_625_000-1;
  parameter MCNT3 = 6_250_000-1;
  reg [25:0]counter;
  reg [25:0]counter1;
  reg [25:0]counter2;
  reg [25:0]counter3;
  always@(posedge Clk or posedge Reset_n)
  begin
    if(Reset_n)
    begin
      counter<=0;
      counter1<=0;
      counter2<=0;
      counter3<=0;
    end
    else
    begin
      counter<=(counter==MCNT)?0:(counter+1'd1);
      counter1<=(counter1==MCNT1)?0:(counter1+1'd1);
      counter2<=(counter2==MCNT2)?0:(counter2+1'd1);
      counter3<=(counter3==MCNT3)?0:(counter3+1'd1);
    end
  end

  always@(posedge Clk or posedge Reset_n)
  begin
    if(Reset_n)
      Led<=4'b0000;
    else
    begin
      Led[0]<=(counter==MCNT)?~Led[0]:Led[0];
      Led[1]<=(counter1==MCNT1)?~Led[1]:Led[1];
      Led[2]<=(counter2==MCNT2)?~Led[2]:Led[2];
      Led[3]<=(counter3==MCNT3)?~Led[3]:Led[3];
    end
  end


endmodule

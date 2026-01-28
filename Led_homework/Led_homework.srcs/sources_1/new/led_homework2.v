module led_homework2 (
    Clk,
    Reset_n,
    Led
  );
  input Clk;
  input Reset_n;
  output reg [3:0]Led;

  parameter MCNT = 62_500_000;

  reg [25:0]counter;
  always@(posedge Clk or posedge Reset_n)
  begin
    if(Reset_n)
      counter<=0;
    else
    begin
      counter<=(counter==(MCNT-1))?0:(counter+1'd1);
    end
  end

  always@(posedge Clk or posedge Reset_n)
  begin
    if(Reset_n)
      Led<=4'b0000;
    else
    begin
      Led[0]<=(counter%(MCNT))?Led[0]:~Led[0];
      Led[1]<=(counter%((MCNT>>1)+1))?Led[1]:~Led[1];
      Led[2]<=(counter%((MCNT>>2)+1))?Led[2]:~Led[2];
      Led[3]<=(counter%((MCNT>>3)+1))?Led[3]:~Led[3];
    end
  end

endmodule

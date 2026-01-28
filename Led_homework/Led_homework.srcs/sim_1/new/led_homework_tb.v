`timescale 1ns/1ns
module led_homework_tb();
  reg Clk;
  reg Reset_n;
  wire [3:0]Led;
  led_homework2 led_homework_inst0(
                 .Clk(Clk),
                 .Reset_n(Reset_n),
                 .Led(Led)
               );

  initial
    Clk=1;
  always #4 Clk=~Clk;

  defparam led_homework_inst0.MCNT = 62_500-1;
  // defparam led_homework_inst0.MCNT1 = 31_250-1;
  // defparam led_homework_inst0.MCNT2 = 15_625-1;
  // defparam led_homework_inst0.MCNT3 = 6_250-1;
  initial
  begin
    Reset_n=1;
    #201;
    Reset_n=0;
    #20_000_000;
    $stop;
  end
endmodule

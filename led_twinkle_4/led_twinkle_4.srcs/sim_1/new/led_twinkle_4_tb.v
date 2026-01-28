`timescale 1ns/1ns

module led_twinkle_4_tb();
  reg Clk;
  reg Reset_n;
  wire [3:0]Led;
  led_twinkle_4 led_twinkle_4_inst0(
                  .Clk(Clk),
                  .Reset_n(Reset_n),
                  .Led(Led)
                );

  initial
    Clk=1;
  always #4 Clk=~Clk;

  defparam led_twinkle_4_inst0.MCNT0 = 62_500-1;
  defparam led_twinkle_4_inst0.MCNT1 = 31_250-1;
  defparam led_twinkle_4_inst0.MCNT2 = 15_625-1;
  defparam led_twinkle_4_inst0.MCNT3 = 6_250-1;

  initial
  begin
    Reset_n=1;
    #201;
    Reset_n=0;
    #2000_000_000;
    $stop;
  end
endmodule

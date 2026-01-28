module led_twinkle_4 (
    Clk,
    Reset_n,
    Led
  );

  input Clk;
  input Reset_n;
  output wire [3:0]Led;

  parameter MCNT0 = 62_500_000-1;
  parameter MCNT1 = 31_250_000-1;
  parameter MCNT2 = 15_625_000-1;
  parameter MCNT3 = 6_250_000-1;

  led_twinkle led_twinkle_inst0(
                .Clk(Clk),
                .Reset_n(Reset_n),
                .Led(Led[0])
              );
  defparam led_twinkle_inst0.MCNT=MCNT0;

  led_twinkle
    #(
      .MCNT(MCNT0)
    )
    led_twinkle_inst1(
      .Clk(Clk),
      .Reset_n(Reset_n),
      .Led(Led[1])
    );

  led_twinkle led_twinkle_inst2(
                .Clk(Clk),
                .Reset_n(Reset_n),
                .Led(Led[2])
              );
  defparam led_twinkle_inst2.MCNT=MCNT1;

  led_twinkle led_twinkle_inst3(
                .Clk(Clk),
                .Reset_n(Reset_n),
                .Led(Led[3])
              );
  defparam led_twinkle_inst3.MCNT=MCNT3;

endmodule

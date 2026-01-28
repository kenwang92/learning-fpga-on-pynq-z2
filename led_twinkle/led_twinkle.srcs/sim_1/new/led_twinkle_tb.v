`timescale 1ns/1ns

module led_twinkle_tb();
  reg [7:0]SW;
  reg Clk;
  reg Reset_n;
  wire Led;
  wire [7:0]Counter;
  led_twinkle10 led_twinkle_inst0(
                 .SW(SW),
                 .Clk(Clk),
                 .Reset_n(Reset_n),
                 .Led(Led),
                 .Counter(Counter)
               );
  // defparam led_twinkle_inst0.TIME_UNIT_MS=1;

  initial
    Clk=1;
  always #4 Clk=~Clk;

  initial
  begin
    Reset_n=1;
    SW=8'b1010_0001;
    #201;
    Reset_n=0;
    #8_000_000;
    SW=8'b1000_0001;
    #20_000_000;
    $stop;
  end
endmodule

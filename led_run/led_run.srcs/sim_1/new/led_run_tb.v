`timescale 1ns/1ns

module led_run_tb();
  reg Clk;
  reg Reset_n;
  wire [7:0]Led;
  // led_run3 led_run_inst0(
  //            .Clk(Clk),
  //            .Reset_n(Reset_n),
  //            .Led(Led)
  //          );
  // 修改仿真時使用的內部參數，不會影響到實際module
  // defparam led_run_inst0.MCNT = 62_500-1;
  
  // 修改仿真時使用的內部參數，不會影響到實際module
  led_run3
    #(
      .MCNT(62_500-1)
    )
    led_run_inst0(
      .Clk(Clk),
      .Reset_n(Reset_n),
      .Led(Led)
    );

  initial
    Clk=1;
  always #4 Clk=~Clk;

  initial
  begin
    Reset_n=1;
    #201;
    Reset_n=0;
    #40_000_000;
    $stop;
  end
endmodule

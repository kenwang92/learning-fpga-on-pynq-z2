// 思考題
module led_twinkle10(
    SW,
    Clk,
    Reset_n,
    Led,
    Counter
  );
  input [7:0]SW;
  input Clk;
  input Reset_n;
  output wire Led;
  output reg [7:0]Counter;
  wire Cycle;

  led_twinkle8 led_twinkle8_inst0(
                 .SW(SW),
                 .Clk(Clk),
                 .Reset_n(Reset_n),
                 .Led(Led),
                 .Cycle(Cycle)
               );
  defparam led_twinkle8_inst0.TIME_UNIT_MS=1000;

  // Cycle上升沿將計數器+1
  reg Cycle_delay;
  // combinational logic
  // Cycle_rise值隨著Cycle值 0->1 產生1 Clk寬度脈衝
  wire Cycle_rise=Cycle&~Cycle_delay;

  // 下一個Clk上升沿更新Cycle_delay
  // 紀錄Cycle舊值
  always@(posedge Clk or posedge Reset_n)
    if(Reset_n)
      Cycle_delay<=1'b0;
    else
      Cycle_delay<=Cycle;
  // 紀錄第幾輪
  always@(posedge Clk or posedge Reset_n)
    if(Reset_n)
      Counter<=1'd0;
    else if(Cycle_rise)
      Counter<=(Counter)?(Counter<<1):(Counter+1'd1);

endmodule

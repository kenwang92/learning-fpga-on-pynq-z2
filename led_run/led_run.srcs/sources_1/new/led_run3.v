module led_run3 (
    Clk,
    Reset_n,
    Led
  );
  input Clk;
  input Reset_n;
  output wire [7:0]Led;

  reg [25:0]counter;

  parameter MCNT=62_500_000-1;

  always @(posedge Clk or posedge Reset_n)
  begin
    if(Reset_n)
      counter<=0;
    else if(counter==MCNT)
      counter<=0;
    else
      counter<=counter+1'd1;
  end

  reg [2:0]counter2;
  always @(posedge Clk or posedge Reset_n)
  begin
    if(Reset_n)
      counter2<=0;
    else if(counter==MCNT)
      counter2<=counter2+1'b1;
    // 不須清零，111->1000，溢位後自動清零
  end

  decoder_3_8 decoder_3_8_inst0 (
                .A0(counter2[0]),
                .A1(counter2[1]),
                .A2(counter2[2]),
                .Y0(Led[0]),
                .Y1(Led[1]),
                .Y2(Led[2]),
                .Y3(Led[3]),
                .Y4(Led[4]),
                .Y5(Led[5]),
                .Y6(Led[6]),
                .Y7(Led[7])
              );
endmodule

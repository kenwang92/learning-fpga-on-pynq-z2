`timescale 1ns/1ns;

module key_filter_tb();
    reg Clk;
    reg Reset_p;
    reg Key;
    // wire Key_R_Flag;
    // wire Key_P_Flag;
    // wire Key_State;
    wire Led;

    // key_filter key_filter_inst0(
    key_filter_onboard key_filter_onboard_inst0(
                           .Clk(Clk),
                           .Reset_p(Reset_p),
                           .Led(Led),
                           .Key(Key)
                        //    .Key_R_Flag(Key_R_Flag),
                        //    .Key_P_Flag(Key_P_Flag),
                        //    .Key_State(Key_State)
                       );
    // defparam key_filter_inst0.TIME_UNIT_MS=1;

    initial
        Clk=1;
    always #4 Clk=~Clk;

    initial begin
        Reset_p=1;
        Key=1;
        #201;
        Reset_p=0;
        // for key_filter.v
        // IDLE
        Key=1;
        #100_000;
        // 按下抖動
        Key=0;
        #18_000;
        Key=1;
        #2_000;
        Key=0;
        #1_000;
        Key=1;
        #200;
        Key=0;
        #20_000;
        // 按下穩定
        Key=0;
        #50_000;

        // 釋放抖動
        Key=1;
        #2_000;
        Key=0;
        #1_000;
        Key=1;
        #20_000;

        // 釋放穩定
        Key=1;
        #50_000;

        // IDLE
        #100_000;
    end
endmodule

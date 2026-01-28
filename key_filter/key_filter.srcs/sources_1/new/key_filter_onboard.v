module key_filter_onboard (
        Clk,
        Reset_p,
        Key,
        Led
    );
    input Clk;
    input Reset_p;
    input Key;
    output reg Led;

    key_filter key_filter_inst0(
                   .Clk(Clk),
                   .Reset_p(Reset_p),
                   .Key(Key),
                   .Key_R_Flag(Key_R_Flag),
                   .Key_P_Flag(Key_P_Flag),
                   .Key_State(Key_State)
               );
    // defparam key_filter_inst0.TIME_UNIT_MS=1;

    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            Led<=0;
        else if(Key_R_Flag)
            Led<=~Led;


endmodule

module adc128s102_driver_test(
        Clk,
        Reset_p,
    );
    input Clk;
    input Reset_p;
    input [1:0]SW;
    wire Addr;

    adc128s102_driver_homework adc128s102_inst0(
                                   .Clk(Clk),
                                   .Reset_p(Reset_p),
                                   .Addr(Addr),
                                   .Data(Data),
                                   .Conv_Go(Conv_Go),
                                   .Conv_Done(Conv_Done),
                                   .ADC_CS_N(ADC_CS_N),
                                   .ADC_SCLK(ADC_SCLK),
                                   .ADC_DIN(ADC_DIN),
                                   .ADC_DOUT(ADC_DOUT)
                               );

    key_filter key_filter_inst0(
                   .Clk(Clk),
                   .Reset_p(Reset_p),
                   .Key(Key),
                   .Key_R_Flag(Key_R_Flag),
                   .Key_P_Flag(Key_P_Flag),
                   .Key_State(Key_State)
               );

    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            SW<=0;
        else if(Key_P_Flag)
        case (SW)
            0:
                Addr=8'hFD;// hum_msb
            1:
                Addr=8'hFA;// temp_mcb
            2:
                Addr=8'hF7;// press_msb
            3:
                Addr=8'hD0;// chip_id
        endcase

endmodule

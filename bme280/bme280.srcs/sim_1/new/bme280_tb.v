`timescale 1ns/1ns
module bme280_tb ();
    reg Clk;
    reg Reset_p;
    reg Conv_Go;
    reg [7:0]Addr;
    reg ADC_DOUT;

    wire Conv_Done;
    wire [15:0]Data;
    wire ADC_SCLK;
    wire ADC_CS_N;
    wire ADC_DIN;
    bme280_driver bme280_driver_inst0(
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

    initial
        Clk=1;
    always #4 Clk=~Clk;

    initial begin
        Reset_p=1;
        Conv_Go=0;
        Addr=0;
        #201;
        Reset_p=0;
        #200;


        Conv_Go=1;
        Addr=8'hD0;
        #8;
        Conv_Go=0;
        wait(!ADC_CS_N);
        // AD
        @(negedge ADC_SCLK)
         ADC_DOUT<=0;// DB15
        @(negedge ADC_SCLK)
         ADC_DOUT<=0;// DB14
        @(negedge ADC_SCLK)
         ADC_DOUT<=0;// DB13
        @(negedge ADC_SCLK)
         ADC_DOUT<=0;// DB12

        @(negedge ADC_SCLK)
         ADC_DOUT<=0;// DB12
        @(negedge ADC_SCLK)
         ADC_DOUT<=0;// DB12
        @(negedge ADC_SCLK)
         ADC_DOUT<=0;// DB12
        @(negedge ADC_SCLK)
         ADC_DOUT<=0;// DB12
        // DO 15-8
        @(negedge ADC_SCLK)
         ADC_DOUT<=1;// DB11
        @(negedge ADC_SCLK)
         ADC_DOUT<=0;// DB10
        @(negedge ADC_SCLK)
         ADC_DOUT<=1;// DB9
        @(negedge ADC_SCLK)
         ADC_DOUT<=0;// DB8

        @(negedge ADC_SCLK)
         ADC_DOUT<=0;// DB7
        @(negedge ADC_SCLK)
         ADC_DOUT<=1;// DB6
        @(negedge ADC_SCLK)
         ADC_DOUT<=0;// DB5
        @(negedge ADC_SCLK)
         ADC_DOUT<=1;// DB4
        // DO 7-0
        @(negedge ADC_SCLK)
         ADC_DOUT<=1;// DB3
        @(negedge ADC_SCLK)
         ADC_DOUT<=0;// DB2
        @(negedge ADC_SCLK)
         ADC_DOUT<=0;// DB1
        @(negedge ADC_SCLK)
         ADC_DOUT<=0;// DB0

        @(negedge ADC_SCLK)
         ADC_DOUT<=1;// DB9
        @(negedge ADC_SCLK)
         ADC_DOUT<=0;// DB8
        @(negedge ADC_SCLK)
         ADC_DOUT<=0;// DB7
        @(negedge ADC_SCLK)
         ADC_DOUT<=1;// DB9

        wait(ADC_CS_N);
        #200;

    end
endmodule

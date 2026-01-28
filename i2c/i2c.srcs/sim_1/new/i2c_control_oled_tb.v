`timescale 1ns / 1ns
module i2c_control_oled_tb ();
    reg  Clk;
    reg  Reset_p;
    wire i2c_sclk;
    wire i2c_sdat;
    pullup PUP (i2c_sdat);
    i2c_control_oled i2c_control_oled_inst0 (
        .Clk     (Clk),
        .Reset_p (Reset_p),
        .i2c_sclk(i2c_sclk),
        .i2c_sdat(i2c_sdat)
    );
    // M24LC04B M24LC04B_inst0(
    //              .A0(0),
    //              .A1(0),
    //              .A2(0),
    //              .WP(0),
    //              .SDA(i2c_sdat),
    //              .SCL(i2c_sclk),
    //              .RESET(Reset_p)
    //          );
    initial Clk = 0;
    always #4 Clk = ~Clk;

    initial begin
        Reset_p <= 1;
        #81;
        Reset_p <= 0;
        #200000;
        $stop;
    end
endmodule

`timescale 1ns / 1ns

module i2c_control_test_tb ();
    reg        Clk;
    reg        Reset_p;
    reg  [2:0] key;
    reg  [7:0] SW;
    wire [7:0] led;
    wire       RW_Done_delay;
    wire       i2c_sclk;
    pullup PUP (i2c_sdat);

    i2c_control_test i2c_control_test_inst0 (
        .Clk          (Clk),
        .Reset_p      (Reset_p),
        .key          (key),
        .SW           (SW),
        .led          (led),
        .RW_Done_delay(RW_Done_delay),
        .i2c_sclk     (i2c_sclk),
        .i2c_sdat     (i2c_sdat)
    );
    M24LC04B M24LC04B_inst0 (
        .A0   (0),
        .A1   (0),
        .A2   (0),
        .WP   (0),
        .SDA  (i2c_sdat),
        .SCL  (i2c_sclk),
        .RESET(Reset_p)
    );
    initial Clk = 1;
    always #4 Clk = ~Clk;

    initial begin
        Reset_p = 1;
        SW      = 8'h00;
        key     = 3'b000;
        #81;
        Reset_p = 0;
        #80;
        SW  = 8'h03;
        key = 3'b100;
        #20_000_000;

        #800;
        $stop;
    end
endmodule

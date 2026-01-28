`timescale 1ns/1ns
module hex8_tb ();
    reg Clk;
    reg Reset_p;
    reg [7:0]SEL;
    reg [7:0]SEG;

    wire DIO;
    wire SRCLK;
    wire RCLK;

    // hex8_homework hex8_inst0(
    // hex8 hex8_inst0(
    hc595_driver hex8_inst0(
    // hc595_driver_example hex8_inst0(
                     .Clk(Clk),
                     .Reset_p(Reset_p),
                     .SEL(SEL),
                     .SEG(SEG),
                     .DIO(DIO),
                     .SRCLK(SRCLK),
                     .RCLK(RCLK)
                 );
    // defparam hex8_inst0.TIME_UNIT_MS = 1;
    initial
        Clk=1;
    always #4 Clk=~Clk;

    initial begin

        Reset_p=1;
        SEL=8'b0000_0001;
        SEG=8'b0101_0101;
        #201;
        Reset_p=0;
        #5_000;
        SEL=8'b0000_0010;
        SEG=8'b1010_1010;
        #5_000;
        SEL=8'b1010_0101;
        SEG=8'b0000_1101;
        #5_000;
        $stop;
    end

endmodule

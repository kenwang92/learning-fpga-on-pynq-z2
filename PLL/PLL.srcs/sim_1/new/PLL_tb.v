`timescale 1ns/1ns
module PLL_tb();
    reg clk;
    reg rst_n;
    wire clk_out1;
    wire clk_out2;
    wire clk_out3;
    wire clk_out4;
    wire locked;
    pll pll_inst0
        (
            // Clock out ports
            .clk_out1(clk_out1),     // output clk_out1
            .clk_out2(clk_out2),     // output clk_out2
            .clk_out3(clk_out3),     // output clk_out3
            .clk_out4(clk_out4),     // output clk_out4
            // Status and control signals
            .resetn(rst_n), // input resetn
            .locked(locked),       // output locked
            // Clock in ports
            .clk_in1(clk)      // input clk_in1
        );

    initial clk=1;
    always #4 clk=~clk;

    initial begin
        rst_n=0;
        #81;
        rst_n=1;
        #8000;
        $stop;
    end
endmodule

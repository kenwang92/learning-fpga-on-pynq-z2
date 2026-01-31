`timescale 1ns / 1ns

module top_tb;

    // Parameters

    //Ports
    reg        Clk;
    reg        Reset_p;
    wire       hdmi_clk_n;
    wire       hdmi_clk_p;
    wire [2:0] hdmi_tx_n;
    wire [2:0] hdmi_tx_p;

    top top_inst (
        .Clk       (Clk),
        .Reset_p   (Reset_p),
        .hdmi_clk_n(hdmi_clk_n),
        .hdmi_clk_p(hdmi_clk_p),
        .hdmi_tx_n (hdmi_tx_n),
        .hdmi_tx_p (hdmi_tx_p)
    );

    always #4 Clk = !Clk;

    initial begin
        Clk     = 1;
        Reset_p = 1;
        #81;
        Reset_p = 0;
        #2000000;
        $stop;
    end

endmodule

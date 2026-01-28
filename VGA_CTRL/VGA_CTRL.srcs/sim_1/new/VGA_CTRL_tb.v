`include "../../sources_1/new/disp_parameter_cfg.v"
`timescale 1ns/1ns
module VGA_CTRL_tb ();
    reg Clk;
    reg Reset_p;
    // reg [23:0]Data_in;
    // wire [10:0]hcount;
    // wire [10:0]vcount;
    wire DISP_HS;
    wire DISP_VS;
    // wire DISP_DE;
    // wire DISP_CLK;
    wire [`Red-1:0]disp_red;
    wire [`Green-1:0]disp_green;
    wire [`Blue-1:0]disp_blue;
    // wire [23:0]VGA_DATA;
    // wire hdmi_clk_n;
    // wire hdmi_clk_p;
    // wire [2:0]hdmi_tx_n;
    // wire [2:0]hdmi_tx_p;

    // VGA_CTRL_homework VGA_CTRL_inst0 (
    // VGA_CTRL VGA_CTRL_inst0 (
    // VGA_test VGA_CTRL_inst0 (
    // vga_to_hdmi_onboard VGA_CTRL_inst0(
    VGA_onboard VGA_CTRL_inst0(
                            .Clk(Clk),
                            .Reset_p(Reset_p),
                            // .DISP_DATA(VGA_DATA),
                            // .hdmi_clk_n(hdmi_clk_n),
                            // .hdmi_clk_p(hdmi_clk_p),
                            // .hdmi_tx_n(hdmi_tx_n),
                            // .hdmi_tx_p(hdmi_tx_p)
                            //  .Data_in(Data_in),
                            //  .hcount(hcount),
                            //  .vcount(vcount),
                            .DISP_HS(DISP_HS),
                            .DISP_VS(DISP_VS),
                            // .DISP_DE(DISP_DE),
                            // .DISP_CLK(DISP_CLK)
                            .disp_red(disp_red),
                            .disp_green(disp_green),
                            .disp_blue(disp_blue)
                            //  .VGA_DATA(VGA_DATA)
                        );
    initial
        Clk=1;
    // always #15 Clk=~Clk;// 33M≒週期30ns
    always #4 Clk=~Clk;// 125M

    initial begin
        Reset_p<=1;
        // #201;
        #81;
        Reset_p<=0;
        #80_000_000;
        $stop;
    end

    // always@(posedge Clk or posedge Reset_p)
    //     if(Reset_p)
    //         Data_in<=0;
    //     else if(~VGA_BLK)
    //         Data_in<=Data_in;
    //     else
    //         Data_in<=Data_in+1;
endmodule

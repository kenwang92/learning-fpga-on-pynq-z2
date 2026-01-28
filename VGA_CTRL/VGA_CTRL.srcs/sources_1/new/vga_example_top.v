`timescale 1ns / 1ps

// FOR USE WITH AN FPGA THAT HAS 12 PINS FOR RGB VALUES, 4 PER COLOR


module vga_example_top(
        input Clk,      // from FPGA
        input Reset_p,
      //   input [11:0] sw,       // 12 bits for color
        output hsync,
        output vsync,
        output [11:0] rgb      // 12 FPGA pins for RGB(4 per color)
    );

    // Signal Declaration
    reg [11:0] rgb_reg;    // Registar for displaying color on a screen
    wire video_on;         // Same signal as in controller
    clk_div clk_div_inst0(
                .clk_out1(Clk100),
                .reset(Reset_p),
                .clk_in1(Clk)// 125M
            );
    // Instantiate VGA Controller
    vga_example vga_c(
                    .Clk(Clk100),
                    .Reset_p(Reset_p),
                    .hsync(hsync),
                    .vsync(vsync),
                    .video_on(video_on),
                    .p_tick(),
                    .x(),
                    .y());
    // RGB Buffer
    always @(posedge Clk or posedge Reset_p)
        if (Reset_p)
            rgb_reg <= 0;
      //   else
      //       rgb_reg <= sw;

    // Output
   //  assign rgb = (video_on) ? rgb_reg : 12'b0;   // while in display area RGB color = sw, else all OFF
    assign rgb = (video_on) ? 12'h00f : 12'b0;   // while in display area RGB color = sw, else all OFF

endmodule

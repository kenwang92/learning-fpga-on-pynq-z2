module dvi_encoder (
    input        pixelclk,
    input        pixelclk5x,
    input        Reset_p,
    input  [7:0] blue_din,
    input  [7:0] green_din,
    input  [7:0] red_din,
    input        hsync,
    input        vsync,
    input        de,
    output       tmds_clk_p,
    output       tmds_clk_n,
    output [2:0] tmds_data_p,
    output [2:0] tmds_data_n
);

    wire [9:0] red;
    wire [9:0] green;
    wire [9:0] blue;

    encode_hw encode_red_inst0 (
        .Clk    (pixelclk),
        .Reset_p(Reset_p),
        .din    (red_din),
        .c0     (1'b0),
        .c1     (1'b0),
        .de     (de),
        .dout   (red)
    );
    encode_hw encode_green_inst0 (
        .Clk    (pixelclk),
        .Reset_p(Reset_p),
        .din    (green_din),
        .c0     (1'b0),
        .c1     (1'b0),
        .de     (de),
        .dout   (green)
    );
    encode_hw encode_blue_inst0 (
        .Clk    (pixelclk),
        .Reset_p(Reset_p),
        .din    (blue_din),
        .c0     (hsync),
        .c1     (vsync),
        .de     (de),
        .dout   (blue)
    );
    serdes_4b_10to1 serdes_4b_10to1_inst0 (
        .clkx5         (pixelclk5x),
        .data_in_ch0   (blue),
        .data_in_ch1   (green),
        .data_in_ch2   (red),
        .data_in_ch3   (10'b11111_00000),
        .data_out_ch0_p(tmds_data_p[0]),
        .data_out_ch0_n(tmds_data_n[0]),
        .data_out_ch1_p(tmds_data_p[1]),
        .data_out_ch1_n(tmds_data_n[1]),
        .data_out_ch2_p(tmds_data_p[2]),
        .data_out_ch2_n(tmds_data_n[2]),
        .data_out_ch3_p(tmds_clk_p),
        .data_out_ch3_n(tmds_clk_n)
    );

endmodule

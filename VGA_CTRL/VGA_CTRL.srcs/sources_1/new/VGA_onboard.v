// 已上板驗證，要接網路線
`include "disp_parameter_cfg.v"
// `define RGB888
// `define RGB565
`define RGB444
module VGA_onboard (
    Clk,
    Reset_p,
    DISP_HS,
    DISP_VS,
    disp_red,
    disp_green,
    disp_blue,
    Key
);

    input Clk;
    input Reset_p;
    input [1:0] Key;

    output DISP_HS;
    output DISP_VS;
    output [`Red-1:0] disp_red;
    output [`Green-1:0] disp_green;
    output [`Blue-1:0] disp_blue;
    wire [11:0] Data;

    wire [11:0] h_addr;
    wire [11:0] v_addr;
    wire        DISP_DE;
    wire        DISP_CLK;
    wire [11:0] VGA_DATA;
    // for button
    wire Key0_R_Flag, Key1_R_Flag;
    reg  [4:0] cnt;

    wire       Clk_DISP;
    clk_div clk_div_inst0 (
        .clk_out1(Clk_DISP),
        .reset   (Reset_p),
        .clk_in1 (Clk)        // 125M
    );
    disp_driver disp_driver_inst0 (
        .CLK_DISP  (Clk_DISP),
        .Reset_p   (Reset_p),
        .Data      (Data),
        .h_addr    (h_addr),
        .v_addr    (v_addr),
        .DISP_HS   (DISP_HS),
        .DISP_VS   (DISP_VS),
        .DISP_DE   (DISP_DE),
        .DISP_CLK  (DISP_CLK),
        .disp_red  (disp_red),
        .disp_green(disp_green),
        .disp_blue (disp_blue)
    );
    key_filter key_filter_inst0 (
        .Clk       (Clk_DISP),
        .Reset_p   (Reset_p),
        .Key       (Key[0]),
        .Key_R_Flag(Key0_R_Flag),
        .Key_P_Flag(Key0_P_Flag),
        .Key_State (Key0_State)
    );
    key_filter key_filter_inst1 (
        .Clk       (Clk_DISP),
        .Reset_p   (Reset_p),
        .Key       (Key[1]),
        .Key_R_Flag(Key1_R_Flag),
        .Key_P_Flag(Key1_P_Flag),
        .Key_State (Key1_State)
    );
`ifdef RGB888
    localparam BLACK = 24'h000000;
    localparam RED = 24'hFF0000;
    localparam GREEN = 24'h00FF00;
    localparam BLUE = 24'h0000FF;
    localparam YELLOW = 24'hFFFF00;
    localparam AQUA = 24'h00FFFF;
    localparam PINK = 24'hFF00FF;
    localparam WHITE = 24'hFFFFFF;
`elsif RGB444
    localparam BLACK = 12'h000;
    localparam RED = 12'hF00;
    localparam GREEN = 12'h0F0;
    localparam BLUE = 12'h00F;
    localparam YELLOW = 12'hFF0;
    localparam AQUA = 12'h0FF;
    localparam PINK = 12'hF0F;
    localparam WHITE = 12'hFFF;
`endif

    // 黑白方格
    /*
    EX: 棋盤方格本質是二進位座標[0]的XOR
    w(000,000) | b(001,000) | w(010,000)
    b(000,001) | w(001,001) | b(010,001)
    w(000,010) | b(001,010) | w(010,010)
    */
    wire [ 7:0] grid_size = cnt;  // 格子長寬像素：2^grid_size
    wire [10:0] h_idx = h_addr >> grid_size;  // 得到水平座標
    wire [10:0] v_idx = v_addr >> grid_size;  // 得到垂直座標
    assign Data = (h_idx[0] ^ v_idx[0]) ? RED : GREEN;

    always @(posedge Clk_DISP or posedge Reset_p)
        if (Reset_p) cnt <= 1;
        else if (Key0_R_Flag) cnt <= (cnt == 9) ? cnt : cnt + 1;
        else if (Key1_R_Flag) cnt <= (cnt == 1) ? cnt : cnt - 1;

endmodule

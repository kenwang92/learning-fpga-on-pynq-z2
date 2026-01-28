module ov5640_ram_tft #(
    parameter IMAGE_WIDTH     = 800,
    parameter IMAGE_HEIGHT    = 480,
    parameter IMAGE_FLIP_EN   = 0,
    parameter IMAGE_MIRROR_EN = 0
) (
    input Clk,
    input Reset_p,

    output       cam_rst_n,
    input        cam_pclk,
    input        cam_Vsync,
    input        cam_Href,
    output       cam_xclk,
    input  [7:0] cam_Data,
    output       cam_sclk,
    inout        cam_sdat,

    output       Disp_HS,
    output       Disp_VS,
    // RGB565
    output [4:0] Disp_Red,
    output [5:0] Disp_Green,
    output [4:0] Disp_Blue,
    output       Disp_DE,
    output       Disp_PCLK,
    output       Disp_PWM
);

    wire        ImageState;  // Vsync是否拉低
    wire        DataValid;
    wire        DispValid;
    wire [15:0] q;
    wire [15:0] RGB_DATA;
    wire [15:0] DataPixel;
    wire        ClkDisp;
    wire        locked;
    wire [11:0] H_Addr;
    wire [11:0] V_Addr;
    wire        Data_Req;
    assign Disp_PWM = 1;
    wire        Init_Done;
    reg  [15:0] wraddr;  // ram寫入地址計數器
    reg  [15:0] rdaddr;

    camera_init #(
        .IMAGE_WIDTH    (IMAGE_WIDTH),
        .IMAGE_HEIGHT   (IMAGE_HEIGHT),
        .IMAGE_FLIP_EN  (IMAGE_FLIP_EN),
        .IMAGE_MIRROR_EN(IMAGE_MIRROR_EN)
    ) camera_init_inst0 (
        .Clk         (Clk),
        .Reset_p     (Reset_p),
        .Init_Done   (Init_Done),
        .camera_rst_n(cam_rst_n),
        .camera_pwdn (),
        .i2c_sclk    (cam_sclk),
        .i2c_sdat    (cam_sdat)
    );
    pll pll_inst0 (
        // Clock out ports
        .clk_out1(cam_xclk),  // 24M for xclk
        .clk_out2(ClkDisp),   // 33M for LCD
        // Status and control signals
        .reset   (Reset_p),   // input reset
        .locked  (locked),    // output locked
        // Clock in ports
        .clk_in1 (Clk)        // input clk_in1
    );


    ram ram_inst0 (
        .clka (cam_pclk),   // input wire clka
        .wea  (DataValid),  // input wire [0 : 0] wea
        .addra(wraddr),     // input wire [15 : 0] addra
        .dina (DataPixel),  // input wire [15 : 0] dina

        .clkb (ClkDisp),  // input wire clkb
        .addrb(rdaddr),   // input wire [15 : 0] addrb
        .doutb(q)         // output wire [15 : 0] doutb
    );
    disp_driver #(
        .AHEAD_CLK_CNT(0)  //ahead N clock generate DataReq
    ) disp_driver_inst0 (
        .ClkDisp   (ClkDisp),
        .Reset_p   (Reset_p),
        .Data      (RGB_DATA),
        .DataReq   (DataReq),
        .H_Addr    (H_Addr),
        .V_Addr    (V_Addr),
        .Disp_Sof  (),
        .Disp_HS   (Disp_HS),
        .Disp_VS   (Disp_VS),
        .Disp_Red  (Disp_Red),
        .Disp_Green(Disp_Green),
        .Disp_Blue (Disp_Blue),
        .Disp_DE   (Disp_DE),
        .Disp_PCLK (Disp_PCLK)
    );
    DVP_Capture DVP_Capture_inst0 (
        .Reset_p   (!Init_Done),
        .PCLK      (cam_pclk),
        .Vsync     (cam_Vsync),
        .Href      (cam_Href),
        .Data      (cam_Data),
        .ImageState(ImageState),
        .DataValid (DataValid),
        .DataPixel (DataPixel),
        .DataHS    (),
        .DataVS    (),
        .Xaddr     (),
        .Yaddr     ()
    );
    assign RGB_DATA = DispValid ? q : 16'd0;
    assign Disp_Valid = DataReq&&(H_Addr>=272)&&(H_Addr<528)&&(V_Addr>=112)&&(V_Addr<368);
    // ram寫入地址
    always @(posedge cam_pclk or posedge Reset_p) begin
        if (Reset_p) begin
            wraddr <= 16'd0;
        end else if (ImageState) begin  // Vsync高電平歸零
            wraddr <= 16'd0;
        end else if (DataValid) begin
            if (wraddr == 65535) begin
                wraddr <= 16'd0;
            end else begin
                wraddr <= wraddr + 1'd1;
            end
        end
    end

    // ram讀取地址
    always @(posedge ClkDisp or posedge Reset_p) begin
        if (Reset_p) begin
            rdaddr <= 16'd0;
        end else if (ImageState) begin  // Vsync高電平歸零
            rdaddr <= 16'd0;
        end else if (DataValid) begin
            if (rdaddr == 65535) begin
                rdaddr <= 16'd0;
            end else begin
                rdaddr <= rdaddr + 1'd1;
            end
        end
    end

endmodule

module camera_init #(
    parameter IMAGE_WIDTH     = 640,
    parameter IMAGE_HEIGHT    = 480,
    parameter IMAGE_FLIP_EN   = 0,
    parameter IMAGE_MIRROR_EN = 0,

    // 上電reset完成後20ms開始配置，1.0034 + 20 = 21.0034ms
    // 優化邏輯，比較值設為24'h100800，21.0125ms
    parameter CLK_FREQ   = 125_000_000,                  // 125Mhz
    parameter TARGET_NS  = 21_012_500,                   // ns
    parameter NS_PER_CLK = 8,
    parameter DELAY_CNT  = (TARGET_NS / NS_PER_CLK) - 1
) (
    input      Clk,
    input      Reset_p,
    output reg Init_Done,
    output     camera_rst_n,
    output     camera_pwdn,
    output     i2c_sclk,
    inout      i2c_sdat
);

    wire [15:0] addr;
    reg         wrreg_req;
    reg         rdreg_req;
    wire [ 7:0] wrdata;
    wire [ 7:0] rddata;
    wire        RW_Done;
    wire        ack;
    reg  [31:0] i2c_dly_cnt_max;

    reg  [ 7:0] cnt;
    wire [23:0] lut;

    wire [ 7:0] lut_size;
    wire [ 7:0] device_id;
    wire        addr_mode;

    assign camera_pwdn = 0;

    assign device_id   = 8'h78;
    assign addr_mode   = 1'b1;
    assign addr        = lut[23:8];
    assign wrdata      = lut[7:0];

    assign lut_size    = 252;

    ov5640_init_table_rgb #(
        .IMAGE_WIDTH    (IMAGE_WIDTH),
        .IMAGE_HEIGHT   (IMAGE_HEIGHT),
        .IMAGE_FLIP_EN  (IMAGE_FLIP_EN),
        .IMAGE_MIRROR_EN(IMAGE_MIRROR_EN)
    ) ov5640_init_table_rgb_inst0 (
        .clk (Clk),
        .addr(cnt),
        .q   (lut)
    );

    i2c_control i2c_control_inst0 (
        .Clk        (Clk),
        .Reset_p    (Reset_p),
        .wrreg_req  (wrreg_req),
        .rdreg_req  (0),
        .addr       (addr),
        .addr_mode  (addr_mode),
        .wrdata     (wrdata),
        .rddata     (rddata),
        .device_id  (device_id),
        .RW_Done    (RW_Done),
        .ack        (ack),
        .i2c_dly_cnt_max(i2c_dly_cnt_max),
        .i2c_sclk   (i2c_sclk),
        .i2c_sdat   (i2c_sdat)
    );

    wire        Go;
    reg  [20:0] delay_cnt;


    always @(posedge Clk or posedge Reset_p)
        if (Reset_p) delay_cnt <= 21'd0;
        else if (delay_cnt == DELAY_CNT) delay_cnt <= DELAY_CNT;
        else delay_cnt <= delay_cnt + 1;

    // 延遲後enable初始化
    assign Go           = (delay_cnt == (DELAY_CNT - 1)) ? 1'b1 : 1'b0;

    // 上電Reset狀態需保持1ms，所以上電後1ms再釋放enable性號
    // 優化邏輯，延遲比較值為24'hC400，1.003520ms
    // assign camera_rst_n = (delay_cnt > 21'h3D090);

    assign camera_rst_n = 1;

    // 初始指令計數(第幾條)
    always @(posedge Clk or posedge Reset_p)
        if (Reset_p) cnt <= 0;
        else if (Go) cnt <= 0;
        else if (cnt < lut_size) begin
            if (RW_Done && (!ack)) cnt <= cnt + 1;  // ack拉低表示從機有應答
            else cnt <= cnt;
        end else cnt <= 0;

    // 初始化完成tag
    always @(posedge Clk or posedge Reset_p)
        if (Reset_p) Init_Done <= 0;
        else if (Go) Init_Done <= 0;
        else if (cnt == lut_size) Init_Done <= 1;

    reg [1:0] state;

    always @(posedge Clk or posedge Reset_p)
        if (Reset_p) begin
            state           <= 0;
            wrreg_req       <= 1'b0;
            i2c_dly_cnt_max <= 32'd0;
        end else if (cnt < lut_size)
            case (state)
                // 20ms後開始發送初始化指令
                0:       state <= Go ? 1 : state;
                // 發送指令狀態
                1: begin
                    wrreg_req       <= 1'b1;  // 拉高寫入請求訊號
                    // 第二條指令發送後延遲5ms
                    i2c_dly_cnt_max <= (cnt == 1) ? 32'h1312D0 : 32'd0;
                    state           <= 2;
                end
                // 等待發送完畢狀態
                2: begin
                    wrreg_req <= 1'b0;
                    if (RW_Done) state <= 1;  // 指令發送完畢回狀態一繼續發送
                    else state <= state;
                end
                default: state <= 0;
            endcase
        else state <= 0;
endmodule

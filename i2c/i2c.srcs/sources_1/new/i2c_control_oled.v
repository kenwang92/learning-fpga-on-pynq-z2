module i2c_control_oled (
    Clk,
    Reset_p,
    i2c_sclk,
    i2c_sdat
);
    input Clk;
    input Reset_p;

    reg  [ 7:0] init_index;  // 初始化指令計數器
    reg  [ 7:0] init_cmd;
    reg  [ 2:0] state;
    wire        RW_Done;
    reg         wrreg_req;
    reg  [15:0] addr;
    reg  [ 7:0] wrdata;
    reg  [ 3:0] cnt;  // max 16
    reg  [ 7:0] col_cnt;  // max 256
    reg  [ 2:0] page;
    output i2c_sclk;
    inout i2c_sdat;

    // 一個字 16x16=256bit=32bytes
    // 三個字 96bytes
    parameter FONT_NUM = 8;
    reg [7:0] font16x16_rom[0:FONT_NUM*32];
    initial begin
        $readmemh("font.mem", font16x16_rom);
    end
    reg  [ 7:0] font_index;  // 128/16=8
    wire [15:0] rom_addr = font_index * 32 + col_cnt[3:0] + page[0] * 16;
    // p0 0-127[8bits]
    // p1 0-127
    // p0  fontrom[0]-fontrom[15] fontrom[32]-fontrom[47] ...
    // p1 fontrom[16]-fontrom[31] fontrom[48]-fontrom[63] ...

    i2c_control i2c_control_inst0 (
        .Clk      (Clk),
        .Reset_p  (Reset_p),
        .wrreg_req(wrreg_req),
        .rdreg_req(),
        .addr     (addr),
        .addr_mode(1'd0),
        .wrdata   (wrdata),
        .rddata   (),
        .device_id(8'h78),      // SSD1306
        .RW_Done  (RW_Done),
        .ack      (),
        .i2c_sclk (i2c_sclk),
        .i2c_sdat (i2c_sdat)
    );
    always @(*)  // 初始化指令
        case (init_index)
            0:       init_cmd <= 8'hAE;
            1:       init_cmd <= 8'h00;
            2:       init_cmd <= 8'h10;
            3:       init_cmd <= 8'h40;
            4:       init_cmd <= 8'h81;
            5:       init_cmd <= 8'hCF;
            6:       init_cmd <= 8'hA1;
            7:       init_cmd <= 8'hC8;
            8:       init_cmd <= 8'hA6;
            9:       init_cmd <= 8'hA8;
            10:      init_cmd <= 8'h3f;
            11:      init_cmd <= 8'hD3;
            12:      init_cmd <= 8'h00;
            13:      init_cmd <= 8'hd5;
            14:      init_cmd <= 8'h80;
            15:      init_cmd <= 8'hD9;
            16:      init_cmd <= 8'hF1;
            17:      init_cmd <= 8'hDA;
            18:      init_cmd <= 8'h12;
            19:      init_cmd <= 8'hDB;
            20:      init_cmd <= 8'h40;
            21:      init_cmd <= 8'h20;
            22:      init_cmd <= 8'h02;
            23:      init_cmd <= 8'h8D;
            24:      init_cmd <= 8'h14;
            25:      init_cmd <= 8'hA4;
            26:      init_cmd <= 8'hA6;
            27:      init_cmd <= 8'hAF;
            28:      init_cmd <= 8'hA6;
            29:      init_cmd <= 8'hC8;
            30:      init_cmd <= 8'hA1;
            default: ;
        endcase


    localparam INIT = 3'd0;
    localparam CLEAR = 3'd1;
    localparam DRAW = 3'd2;
    localparam DRAW_FONT = 3'd3;
    localparam FINISH = 3'd4;

    always @(posedge Clk or posedge Reset_p) begin
        if (Reset_p) begin
            init_index <= 0;
            state      <= INIT;
            cnt        <= 0;
            col_cnt    <= 0;
            page       <= 0;
            wrreg_req  <= 0;
            addr       <= 16'h0000;
            wrdata     <= 8'h00;
            font_index <= 0;
        end else
            case (state)
                INIT:  // 初始化OLED（發縙初始化指令）
                if (RW_Done) begin
                    wrreg_req <= 0;
                    if (init_index == 30) state <= CLEAR;
                    else init_index <= init_index + 1;
                end else begin
                    addr      <= 16'h0000;
                    wrdata    <= init_cmd;
                    wrreg_req <= 1;
                end
                CLEAR:
                // 執行順序：列低位地址->列高位地址->頁地址
                // ->128位數據(每個數據8bit，畫出垂直一列)
                if (RW_Done) begin
                    wrreg_req <= 0;
                    // 將每個像素值清零
                    if (cnt == 3)
                        if (col_cnt == 127)
                            if (page == 7) begin
                                state   <= DRAW;
                                cnt     <= 0;
                                col_cnt <= 0;
                                page    <= 0;
                            end else begin
                                page    <= page + 1;
                                col_cnt <= 0;
                                cnt     <= 0;
                            end
                        else col_cnt <= col_cnt + 1;
                    else cnt <= cnt + 1;
                end else
                    case (cnt)
                        0: begin  // 設定列起始低位地址
                            addr      <= 16'h0000;
                            wrdata    <= 8'h00;
                            wrreg_req <= 1;
                        end
                        1: begin  // 設定列起始高位地址
                            addr      <= 16'h0000;
                            wrdata    <= 8'h10;
                            wrreg_req <= 1;
                        end
                        2: begin  // 設定頁地址
                            addr      <= 16'h0000;
                            wrdata    <= 8'hB0 + page;
                            wrreg_req <= 1;
                        end
                        default: begin
                            addr      <= 16'h0040;
                            wrdata    <= 8'h00;
                            wrreg_req <= 1;
                        end
                    endcase
                DRAW:
                if (RW_Done) begin
                    wrreg_req <= 0;
                    if (cnt == 3)
                        if (col_cnt == 127)
                            if (page == 7) begin
                                state   <= DRAW_FONT;
                                page    <= 0;
                                col_cnt <= 0;
                                cnt     <= 0;
                            end else begin
                                page    <= page + 1;
                                col_cnt <= 0;
                                cnt     <= 0;
                            end
                        else col_cnt <= col_cnt + 1;
                    else cnt <= cnt + 1;
                end else
                    case (cnt)
                        0: begin  // 設定列起始低位地址
                            addr      <= 16'h0000;
                            wrdata    <= 8'h00;
                            wrreg_req <= 1;
                        end
                        1: begin  // 設定列起始高位地址
                            addr      <= 16'h0000;
                            wrdata    <= 8'h10;
                            wrreg_req <= 1;
                        end
                        2: begin  // 設定頁地址
                            addr      <= 16'h0000;
                            wrdata    <= 8'hB0 + page;
                            wrreg_req <= 1;
                        end
                        default: begin  // 欲刷新內容
                            addr      <= 16'h0040;
                            wrdata    <= (col_cnt[0]) ? 8'hCC : 8'h33;
                            wrreg_req <= 1;
                        end
                    endcase
                DRAW_FONT:
                if (RW_Done) begin
                    wrreg_req <= 0;
                    if (cnt == 3)
                        // 印完上、下半個字
                        if (col_cnt == 15) begin
                            col_cnt <= 0;
                            // font_index
                            // p0 fi_0 fi_1
                            // p1 fi_0 fi_1
                            // page整排印完換行歸零font_index
                            if (font_index < FONT_NUM - 1) font_index <= font_index + 1;
                            else begin
                                font_index <= 0;
                                if (page[0] == 1) state <= FINISH;
                                else begin
                                    page <= page + 1;
                                    cnt  <= 0;
                                end
                            end
                        end else col_cnt <= col_cnt + 1;
                    else cnt <= cnt + 1;
                end else
                    case (cnt)
                        0: begin  // 設定列起始低位地址
                            addr      <= 16'h0000;
                            wrdata    <= 8'h00;
                            wrreg_req <= 1;
                        end
                        1: begin  // 設定列起始高位地址
                            addr      <= 16'h0000;
                            wrdata    <= 8'h10;
                            wrreg_req <= 1;
                        end
                        2: begin  // 設定頁地址
                            addr      <= 16'h0000;
                            wrdata    <= 8'hB0 + page;
                            wrreg_req <= 1;
                        end
                        default: begin  // 欲刷新內容
                            addr      <= 16'h0040;
                            wrdata    <= font16x16_rom[rom_addr];
                            wrreg_req <= 1;
                        end
                    endcase
                FINISH: ;
            endcase
    end
endmodule

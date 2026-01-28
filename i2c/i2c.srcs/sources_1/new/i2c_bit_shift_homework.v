module i2c_bit_shift_homework (
    Clk,
    Reset_p,
    CMD,
    Tx_DATA,
    Go,
    ack_o,
    Rx_DATA,
    Trans_Done,
    i2c_sclk,
    i2c_sdat
);
    input Clk;
    input Reset_p;
    input [5:0] CMD;
    input [7:0] Tx_DATA;
    input Go;

    output reg ack_o;
    output reg [7:0] Rx_DATA;
    output reg Trans_Done;
    output reg i2c_sclk;
    inout i2c_sdat;

    reg [7:0] state;

    localparam IDLE         =7'b0000001,
               STARTUP_BIT  =7'b0000010,
               WRITE_DATA   =7'b0000100,
               READ_DATA    =7'b0001000,
               DETECT_ACT   =7'b0010000,
               PRODUCE_ACT  =7'b0100000,
               STOP_BIT     =7'b1000000;

    parameter SYS_CLOCK = 125_000_000;
    parameter SCL_FREQ = 400_000;
    localparam SCL_MCNT = SYS_CLOCK / SCL_FREQ / 4 - 1;
    reg en_cnt;
    localparam
        WRITE   = 6'b000001,
        STARTUP = 6'b000010,
        READ    = 6'b000100,
        STOP    = 6'b001000,
        ACK     = 6'b010000,
        NACK   = 6'b100000;
    reg [19:0] cnt;
    always @(posedge Clk or posedge Reset_p)
        if (Reset_p) cnt <= 0;
        else if (en_cnt)
            if (cnt == SCL_MCNT) cnt <= 0;
            else cnt <= cnt + 1'd1;
        else cnt <= 0;
    wire       sclk_edge = (cnt == SCL_MCNT);

    reg  [4:0] sclk_cnt;
    reg        i2c_sdat_oe;
    reg        i2c_sdat_o;
    assign i2c_sdat = !i2c_sdat_o && i2c_sdat_oe ? 1'b0 : 1'bz;

    always @(posedge Clk or posedge Reset_p)
        if (Reset_p) begin
            Rx_DATA     <= 0;
            i2c_sdat_oe <= 0;
            i2c_sdat_o  <= 0;
            en_cnt      <= 0;
            Trans_Done  <= 0;
            ack_o       <= 0;
            state       <= IDLE;
            sclk_cnt    <= 0;
        end else
            case (state)
                IDLE:
                if(Go)// 檢測[開始發送]訊號
                begin
                    Trans_Done <= 0;
                    en_cnt     <= 1;
                    if (CMD & STARTUP) state <= STARTUP_BIT;
                    else if (CMD & READ) state <= READ_DATA;
                    else if (CMD & WRITE) state <= WRITE_DATA;
                    else begin
                        en_cnt <= 0;
                        state  <= IDLE;
                    end
                end else begin
                    en_cnt <= 0;
                    state  <= IDLE;
                end
                STARTUP_BIT:
                if (sclk_edge) begin
                    case (sclk_cnt)
                        0: begin
                            i2c_sdat_oe <= 1;
                            i2c_sdat_o  <= 1;
                            i2c_sclk    <= 1;
                        end
                        1: begin
                            i2c_sdat_oe <= 1;
                            i2c_sdat_o  <= 0;
                        end
                        2: i2c_sclk <= 0;
                        default: begin
                            i2c_sdat_o <= 1;
                            i2c_sclk   <= 1;
                        end
                    endcase
                    if (sclk_cnt == 2) begin
                        sclk_cnt <= 0;
                        if (CMD & READ) state <= READ_DATA;
                        else if (CMD & WRITE) state <= WRITE_DATA;
                        else state <= STARTUP_BIT;
                    end else sclk_cnt <= sclk_cnt + 1;
                end
                WRITE_DATA:
                if (sclk_edge) begin
                    case (sclk_cnt)
                        0, 4, 8, 12, 16, 20, 24, 28: begin
                            i2c_sdat_oe <= 1;
                            i2c_sdat_o  <= Tx_DATA[7-sclk_cnt[4:2]];
                        end
                        1, 5, 9, 13, 17, 21, 25, 29:  i2c_sclk <= 1;
                        2, 6, 10, 14, 18, 22, 26, 30: i2c_sclk <= i2c_sclk;
                        3, 7, 11, 15, 19, 23, 27, 31: i2c_sclk <= 0;
                        default: begin
                            i2c_sclk   <= 1;
                            i2c_sdat_o <= 1;
                        end
                    endcase
                    if (sclk_cnt == 31) begin
                        sclk_cnt <= 0;
                        state    <= DETECT_ACT;
                    end else sclk_cnt <= sclk_cnt + 1;
                end
                DETECT_ACT:
                if (sclk_edge) begin
                    case (sclk_cnt)
                        0: begin
                            i2c_sdat_oe <= 0;
                            i2c_sclk    <= i2c_sclk;
                        end
                        1: i2c_sclk <= 1;
                        2: begin
                            ack_o    <= i2c_sdat;
                            i2c_sclk <= i2c_sclk;
                        end
                        3: i2c_sclk <= 0;
                        default: begin
                            i2c_sclk   <= 1;
                            i2c_sdat_o <= 1;
                        end
                    endcase
                    if (sclk_cnt == 3) begin
                        sclk_cnt <= 0;
                        if (CMD & STOP) state <= STOP_BIT;
                        else begin
                            Trans_Done <= 1;
                            state      <= IDLE;
                        end
                    end else sclk_cnt <= sclk_cnt + 1;
                end
                READ_DATA:
                if (sclk_edge) begin
                    case (sclk_cnt)
                        0, 4, 8, 12, 16, 20, 24, 28: begin
                            i2c_sdat_oe <= 0;
                            i2c_sclk    <= 0;  // 從IDLE跳來為高電平，須手動拉低
                        end
                        1, 5, 9, 13, 17, 21, 25, 29:  i2c_sclk <= 1;
                        2, 6, 10, 14, 18, 22, 26, 30: begin
                            Rx_DATA  <= {Rx_DATA[6:0], i2c_sdat};
                            i2c_sclk <= i2c_sclk;
                        end
                        3, 7, 11, 15, 19, 23, 27, 31: i2c_sclk <= 0;
                        default: begin
                            i2c_sclk   <= 1;
                            i2c_sdat_o <= 1;
                        end
                    endcase
                    if (sclk_cnt == 31) begin
                        sclk_cnt <= 0;
                        state    <= PRODUCE_ACT;
                    end else sclk_cnt <= sclk_cnt + 1;
                end
                PRODUCE_ACT:
                if (sclk_edge) begin
                    case (sclk_cnt)
                        0: begin
                            i2c_sdat_oe <= 1;
                            if (CMD & ACK) i2c_sdat_o <= 0;
                            else if (CMD & NACK) i2c_sdat_o <= 1;
                        end
                        1: i2c_sclk <= 1;
                        2: i2c_sclk <= i2c_sclk;
                        3: i2c_sclk <= 0;
                        default: begin
                            i2c_sdat_o <= 1;
                            i2c_sclk   <= 1;
                        end
                    endcase
                    if (sclk_cnt == 3) begin
                        sclk_cnt <= 0;
                        if (CMD & STOP) state <= STOP_BIT;
                        else begin
                            state      <= IDLE;
                            Trans_Done <= 1;
                        end
                    end else sclk_cnt <= sclk_cnt + 1;
                end
                STOP_BIT:
                if (sclk_edge) begin
                    case (sclk_cnt)
                        0: begin
                            i2c_sdat_oe <= 1;
                            i2c_sdat_o  <= 0;
                        end
                        1: i2c_sclk <= 1;
                        2: i2c_sdat_o <= 1;
                        3: i2c_sclk <= i2c_sclk;
                        default: begin
                            i2c_sdat_o <= 1;
                            i2c_sclk   <= 1;
                        end
                    endcase
                    if (sclk_cnt == 3) begin
                        sclk_cnt   <= 0;
                        state      <= IDLE;
                        Trans_Done <= 1;
                    end else sclk_cnt <= sclk_cnt + 1;
                end
                default: state <= IDLE;
            endcase
endmodule

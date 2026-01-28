`timescale 1ns / 1ns
module i2c_bit_shift_tb ();
    reg        Clk;
    reg        Reset_p;
    reg  [5:0] CMD;
    reg  [7:0] Tx_DATA;
    reg        Go;

    wire       ack_o;
    wire [7:0] Rx_DATA;
    wire       Trans_Done;
    wire       i2c_sclk;
    wire       i2c_sdat;
    pullup PUP (i2c_sdat);
    localparam
        WRITE   = 6'b000001,
        STARTUP = 6'b000010,
        READ    = 6'b000100,
        STOP    = 6'b001000,
        ACK     = 6'b010000,
        NOACK   = 6'b100000;
    i2c_bit_shift_homework i2c_bit_shift_inst0 (
        .Clk       (Clk),
        .Reset_p   (Reset_p),
        .CMD       (CMD),
        .Tx_DATA   (Tx_DATA),
        .Go        (Go),
        .ack_o     (ack_o),
        .Rx_DATA   (Rx_DATA),
        .Trans_Done(Trans_Done),
        .i2c_sclk  (i2c_sclk),
        .i2c_sdat  (i2c_sdat)
    );
    M24LC04B M24LC04B_inst0 (
        .A0   (0),
        .A1   (0),
        .A2   (0),
        .WP   (0),
        .SDA  (i2c_sdat),
        .SCL  (i2c_sclk),
        .RESET(Reset_p)
    );
    always #4 Clk = ~Clk;

    initial begin
        Clk     = 1;
        Reset_p = 1;
        Go      = 0;
        CMD     = 6'b000000;
        Tx_DATA = 8'd0;
        #2001;
        Reset_p = 0;
        #2000;

        // 起始位及設備地址
        CMD     = STARTUP | WRITE;
        Go      = 1;
        Tx_DATA = 8'hA0 | 8'd0;
        @(posedge Clk);
        #1;
        Go = 0;
        @(posedge Trans_Done) #200;
        // 寫入寄存器地址
        CMD     = WRITE;
        Go      = 1;
        Tx_DATA = 8'hB1;
        @(posedge Clk);
        #1;
        Go = 0;
        @(posedge Trans_Done) #200;
        // 寫入DATA
        CMD     = WRITE | STOP;
        Go      = 1;
        Tx_DATA = 8'hda;
        @(posedge Clk);
        #1;
        Go = 0;
        @(posedge Trans_Done) #200;

        #5000000;  // 等待擦寫
        // 讀取資料
        // 起始位及設備地址（要從哪個設備讀）
        CMD     = STARTUP | WRITE;
        Go      = 1;
        Tx_DATA = 8'hA0 | 8'd0;
        @(posedge Clk);
        #1;
        Go = 0;
        @(posedge Trans_Done) #200;
        // 寫入寄存器地址（要從哪個位置讀）
        CMD     = WRITE;
        Go      = 1;
        Tx_DATA = 8'hB1;
        @(posedge Clk);
        #1;
        Go = 0;
        @(posedge Trans_Done) #200;
        // 起始位及設備地址（要從哪個設備讀）
        CMD     = STARTUP | WRITE;
        Go      = 1;
        Tx_DATA = 8'hA0 | 8'd1;
        @(posedge Clk);
        #1;
        Go = 0;
        @(posedge Trans_Done) #200;
        // 讀資料+停止位
        CMD = READ | NOACK | STOP;
        Go  = 1;
        @(posedge Clk);
        #1;
        Go = 0;
        @(posedge Trans_Done) #200;

        #2000;
        $stop;
    end
endmodule

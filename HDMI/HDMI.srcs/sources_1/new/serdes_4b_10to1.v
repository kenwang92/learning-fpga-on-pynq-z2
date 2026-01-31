module serdes_4b_10to1 (
    input        clkx5,
    input  [9:0] data_in_ch0,
    input  [9:0] data_in_ch1,
    input  [9:0] data_in_ch2,
    input  [9:0] data_in_ch3,
    output       data_out_ch0_p,
    output       data_out_ch0_n,
    output       data_out_ch1_p,
    output       data_out_ch1_n,
    output       data_out_ch2_p,
    output       data_out_ch2_n,
    output       data_out_ch3_p,
    output       data_out_ch3_n
);
    // wire data_out_0, data_out_1, data_out_2, data_out_3;
    wire data_out_ch0_n, data_out_ch1_n, data_out_ch2_n, data_out_ch3_n;
    wire [4:0] tmds_ch_0_l = {
        data_in_ch0[9], data_in_ch0[7], data_in_ch0[5], data_in_ch0[3], data_in_ch0[1]
    };
    wire [4:0] tmds_ch_0_h = {
        data_in_ch0[8], data_in_ch0[6], data_in_ch0[4], data_in_ch0[2], data_in_ch0[0]
    };

    wire [4:0] tmds_ch_1_l = {
        data_in_ch1[9], data_in_ch1[7], data_in_ch1[5], data_in_ch1[3], data_in_ch1[1]
    };
    wire [4:0] tmds_ch_1_h = {
        data_in_ch1[8], data_in_ch1[6], data_in_ch1[4], data_in_ch1[2], data_in_ch1[0]
    };

    wire [4:0] tmds_ch_2_l = {
        data_in_ch2[9], data_in_ch2[7], data_in_ch2[5], data_in_ch2[3], data_in_ch2[1]
    };
    wire [4:0] tmds_ch_2_h = {
        data_in_ch2[8], data_in_ch2[6], data_in_ch2[4], data_in_ch2[2], data_in_ch2[0]
    };

    wire [4:0] tmds_ch_3_l = {
        data_in_ch3[9], data_in_ch3[7], data_in_ch3[5], data_in_ch3[3], data_in_ch3[1]
    };
    wire [4:0] tmds_ch_3_h = {
        data_in_ch3[8], data_in_ch3[6], data_in_ch3[4], data_in_ch3[2], data_in_ch3[0]
    };

    // 計數0到4
    reg [2:0] tmds_cnt = 0;
    always @(posedge clkx5)
        // if (tmds_cnt == 'd4) tmds_cnt <= 'd0;
        // else tmds_cnt <= tmds_cnt + 1'd1;

        // 優化版本：取[2]如果為1剛好是4(100)
        tmds_cnt <= (tmds_cnt[2]) ? 'd0 : tmds_cnt + 'd1;

    reg [4:0] tmds_shift_0_h = 0, tmds_shift_0_l = 0;
    reg [4:0] tmds_shift_1_h = 0, tmds_shift_1_l = 0;
    reg [4:0] tmds_shift_2_h = 0, tmds_shift_2_l = 0;
    reg [4:0] tmds_shift_3_h = 0, tmds_shift_3_l = 0;
    always @(posedge clkx5) begin
        // counter=4時，填充待發送data
        // 移位暫存器每次右移取[0]輸出
        tmds_shift_0_h <= (tmds_cnt[2]) ? tmds_ch_0_h : {'d0, tmds_shift_0_h[4:1]};
        tmds_shift_0_l <= (tmds_cnt[2]) ? tmds_ch_0_l : {'d0, tmds_shift_0_l[4:1]};

        tmds_shift_1_h <= (tmds_cnt[2]) ? tmds_ch_1_h : {'d0, tmds_shift_1_h[4:1]};
        tmds_shift_1_l <= (tmds_cnt[2]) ? tmds_ch_1_l : {'d0, tmds_shift_1_l[4:1]};

        tmds_shift_2_h <= (tmds_cnt[2]) ? tmds_ch_2_h : {'d0, tmds_shift_2_h[4:1]};
        tmds_shift_2_l <= (tmds_cnt[2]) ? tmds_ch_2_l : {'d0, tmds_shift_2_l[4:1]};

        tmds_shift_3_h <= (tmds_cnt[2]) ? tmds_ch_3_h : {'d0, tmds_shift_3_h[4:1]};
        tmds_shift_3_l <= (tmds_cnt[2]) ? tmds_ch_3_l : {'d0, tmds_shift_3_l[4:1]};
    end
    // 用ODDR合併high和low為DDR訊號
    ODDR #(
        .DDR_CLK_EDGE("SAME_EDGE"),  // "OPPOSITE_EDGE" or "SAME_EDGE" 
        .INIT        (1'b0),         // Initial value of Q: 1'b0 or 1'b1
        .SRTYPE      ("SYNC")        // Set/Reset type: "SYNC" or "ASYNC" 
    ) ODDR_inst0 (
        .Q (data_out_0),         // 1-bit DDR output
        .C (clkx5),              // 1-bit clock input
        .CE(1'b1),               // 1-bit clock enable input
        .D1(tmds_shift_0_h[0]),  // 1-bit data input (positive edge)
        .D2(tmds_shift_0_l[0]),  // 1-bit data input (negative edge)
        .R (1'b0),               // 1-bit reset
        .S (1'b0)                // 1-bit set
    );
    // output buffer differential signaling
    // 將單端信號轉成差分信號
    OBUFDS #(
        .IOSTANDARD("DEFAULT"),  // Specify the output I/O standard
        .SLEW      ("SLOW")      // Specify the output slew rate
    ) OBUFDS_inst0 (
        .O (data_out_ch0_p),  // Diff_p output (connect directly to top-level port)
        .OB(data_out_ch0_n),  // Diff_n output (connect directly to top-level port)
        .I (data_out_0)       // Buffer input
    );
    // 用ODDR合併high和low為DDR訊號
    ODDR #(
        .DDR_CLK_EDGE("SAME_EDGE"),  // "OPPOSITE_EDGE" or "SAME_EDGE" 
        .INIT        (1'b0),         // Initial value of Q: 1'b0 or 1'b1
        .SRTYPE      ("SYNC")        // Set/Reset type: "SYNC" or "ASYNC" 
    ) ODDR_inst1 (
        .Q (data_out_1),         // 1-bit DDR output
        .C (clkx5),              // 1-bit clock input
        .CE(1'b1),               // 1-bit clock enable input
        .D1(tmds_shift_1_h[0]),  // 1-bit data input (positive edge)
        .D2(tmds_shift_1_l[0]),  // 1-bit data input (negative edge)
        .R (1'b0),               // 1-bit reset
        .S (1'b0)                // 1-bit set
    );
    // output buffer differential signaling
    // 將單端信號轉成差分信號
    OBUFDS #(
        .IOSTANDARD("DEFAULT"),  // Specify the output I/O standard
        .SLEW      ("SLOW")      // Specify the output slew rate
    ) OBUFDS_inst1 (
        .O (data_out_ch1_p),  // Diff_p output (connect directly to top-level port)
        .OB(data_out_ch1_n),  // Diff_n output (connect directly to top-level port)
        .I (data_out_1)       // Buffer input
    );
    // 用ODDR合併high和low為DDR訊號
    ODDR #(
        .DDR_CLK_EDGE("SAME_EDGE"),  // "OPPOSITE_EDGE" or "SAME_EDGE" 
        .INIT        (1'b0),         // Initial value of Q: 1'b0 or 1'b1
        .SRTYPE      ("SYNC")        // Set/Reset type: "SYNC" or "ASYNC" 
    ) ODDR_inst2 (
        .Q (data_out_2),         // 1-bit DDR output
        .C (clkx5),              // 1-bit clock input
        .CE(1'b1),               // 1-bit clock enable input
        .D1(tmds_shift_2_h[0]),  // 1-bit data input (positive edge)
        .D2(tmds_shift_2_l[0]),  // 1-bit data input (negative edge)
        .R (1'b0),               // 1-bit reset
        .S (1'b0)                // 1-bit set
    );
    // output buffer differential signaling
    // 將單端信號轉成差分信號
    OBUFDS #(
        .IOSTANDARD("DEFAULT"),  // Specify the output I/O standard
        .SLEW      ("SLOW")      // Specify the output slew rate
    ) OBUFDS_inst2 (
        .O (data_out_ch2_p),  // Diff_p output (connect directly to top-level port)
        .OB(data_out_ch2_n),  // Diff_n output (connect directly to top-level port)
        .I (data_out_2)       // Buffer input
    );
    // 用ODDR合併high和low為DDR訊號
    ODDR #(
        .DDR_CLK_EDGE("SAME_EDGE"),  // "OPPOSITE_EDGE" or "SAME_EDGE" 
        .INIT        (1'b0),         // Initial value of Q: 1'b0 or 1'b1
        .SRTYPE      ("SYNC")        // Set/Reset type: "SYNC" or "ASYNC" 
    ) ODDR_inst3 (
        .Q (data_out_3),         // 1-bit DDR output
        .C (clkx5),              // 1-bit clock input
        .CE(1'b1),               // 1-bit clock enable input
        .D1(tmds_shift_3_h[0]),  // 1-bit data input (positive edge)
        .D2(tmds_shift_3_l[0]),  // 1-bit data input (negative edge)
        .R (1'b0),               // 1-bit reset
        .S (1'b0)                // 1-bit set
    );
    // output buffer differential signaling
    // 將單端信號轉成差分信號
    OBUFDS #(
        .IOSTANDARD("DEFAULT"),  // Specify the output I/O standard
        .SLEW      ("SLOW")      // Specify the output slew rate
    ) OBUFDS_inst3 (
        .O (data_out_ch3_p),  // Diff_p output (connect directly to top-level port)
        .OB(data_out_ch3_n),  // Diff_n output (connect directly to top-level port)
        .I (data_out_3)       // Buffer input
    );

endmodule

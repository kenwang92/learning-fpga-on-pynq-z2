module i2c_control_test(
        Clk,
        Reset_p,
        key,
        SW,
        led,
        RW_Done_delay,
        i2c_sclk,
        i2c_sdat
    );
    input Clk;
    input Reset_p;
    input [2:0]key;
    input [7:0]SW;
    output reg [7:0]led;
    output reg RW_Done_delay;
    output i2c_sclk;
    inout i2c_sdat;

    wire key0_flag;
    wire key0_state;
    wire key1_flag;
    wire key1_state;
    wire key2_flag;
    wire key2_state;
    wire RW_Done;
    wire ack;
    wire wrreg_req;
    wire rdreg_req;

    reg [15:0]addr;
    reg [7:0]wr_data;

    key_filter key_filter_inst0(
                   .Clk(Clk),
                   .Reset_p(Reset_p),
                   .Key(key[0]),
                   .Key_P_Flag(key0_flag),
                   .Key_State(key0_state)
               );
    key_filter key_filter_inst1(
                   .Clk(Clk),
                   .Reset_p(Reset_p),
                   .Key(key[1]),
                   .Key_P_Flag(key1_flag),
                   .Key_State(key1_state)
               );
    key_filter key_filter_inst2(
                   .Clk(Clk),
                   .Reset_p(Reset_p),
                   .Key(key[2]),
                   .Key_P_Flag(key2_flag),
                   .Key_State(key2_state)
               );

    assign wrreg_req=key0_flag&(!key0_state);
    assign rdreg_req=key1_flag&(!key1_state);

    i2c_control i2c_control_inst0(
                    .Clk(Clk),
                    .Reset_p(Reset_p),
                    .wrreg_req(wrreg_req),
                    .rdreg_req(rdreg_req),
                    .device_id(8'h78),
                    .addr_mode(1),
                    .addr(addr),
                    .wrdata(wr_data),
                    .rddata(led),
                    .RW_Done(RW_Done),
                    .ack(ack),
                    .i2c_sclk(i2c_sclk),
                    .i2c_sdat(i2c_sdat)
                );
    reg addr_data_flag;// 標示SW設定的是待寫數據，還是要寫入的寄存器地址

    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            addr_data_flag<=0;
        else if(RW_Done)// 傳輸完成預設是低8位地址
            addr_data_flag<=0;
        else if(key2_flag&(!key2_state))
            addr_data_flag<=addr_data_flag+1;

    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            addr<=16'd3;
        else if(!addr_data_flag)
            addr<={8'd0,SW};
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            wr_data<=8'd0;
        else if(addr_data_flag)
            wr_data<=SW;
    reg [1:0]RW_Done_reg;
    reg delay_cnt_en;
    reg [27:0]delay_cnt;

    // 將RW_Done信號存起來判斷上升沿
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            RW_Done_reg<=0;
        else
            RW_Done_reg<={RW_Done_reg[0],RW_Done};
    // 傳輸完成，計數點亮Led(維持一秒)
    reg cnt_en;
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            cnt_en<= 0;
        else if((delay_cnt>=124_999_999)|wrreg_req|rdreg_req)
            cnt_en<=0;
    // 傳輸完成信號出現上升沿，開始計數
        else if(RW_Done_reg[0]&(!RW_Done_reg[1]))
            cnt_en<=1;
    // Led計數器(延長Led點亮時間)
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p) begin
            delay_cnt<=0;
            RW_Done_delay<=0;
        end
        else if((delay_cnt>=124_999_999)|wrreg_req|rdreg_req) begin
            delay_cnt<=0;
            RW_Done_delay<=0;
        end
        else if(cnt_en) begin
            delay_cnt<=delay_cnt+1;
            RW_Done_delay<=1;
        end
endmodule

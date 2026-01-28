module img_rx_homework (
        Clk,
        Reset_p,
        rx_data,
        rx_done,
        ram_wren,
        ram_wraddr,
        ram_wrdata,
        led
    );
    input Clk;
    input Reset_p;
    input [7:0]rx_data;
    input rx_done;
    output reg ram_wren;
    output reg [15:0]ram_wraddr;// 64Kb
    output [15:0]ram_wrdata;
    output reg led;

    // wire nedge_rx_done;

    // // rx_done非同步訊號打兩拍
    // reg rx_done_dff0,rx_done_dff1,rx_done_r;
    // assign nedge_rx_done = (~rx_done_dff1)&rx_done_r;
    // always@(posedge Clk)
    //     rx_done_dff0<=rx_done;
    // always@(posedge Clk)
    //     rx_done_dff1<=rx_done_dff0;
    // always@(posedge Clk)
    //     rx_done_r<=rx_done_dff1;

    reg [16:0]data_cnt;// 計數收到幾組資料(總共128Kb=131072)
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            data_cnt<=0;
        else if(rx_done)
            data_cnt<=data_cnt+1;
    // 每兩組資料enable寫入
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            ram_wren<=0;
        else if(rx_done && data_cnt[0])
            ram_wren<=1;
        else
            ram_wren<=0;

    reg [15:0]ram_wrdata_tmp;//暫存待寫入資料
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            ram_wrdata_tmp<=0;
        else if(rx_done)
            ram_wrdata_tmp<={ram_wrdata_tmp[7:0],rx_data};

    // 用sequential logic寫法，write enable時無法即時更新ram_wrdata
    // always@(posedge Clk or posedge Reset_p)
    //     if(Reset_p)
    //         ram_wrdata<=0;
    //     else
    //         ram_wrdata<=ram_wrdata_tmp;
    assign ram_wrdata=ram_wrdata_tmp;
    // ram寫入索引值為counter/2(左移1bit)
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            ram_wraddr<=0;
        else if(rx_done&data_cnt[0])
            ram_wraddr<=data_cnt[16:1];
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            led<=0;
        else if(rx_done&data_cnt==131071)
            led<=~led;

endmodule

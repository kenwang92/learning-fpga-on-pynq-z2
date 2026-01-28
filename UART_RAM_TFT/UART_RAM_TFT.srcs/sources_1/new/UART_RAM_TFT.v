module UART_RAM_TFT(
        Clk,
        Reset_p,
        uart_rx,
        TFT_RGB,
        TFT_HS,
        TFT_VS,
        TFT_DE,
        TFT_CLK,
        TFT_BL,
        led
    );

    input Clk;
    input Reset_p;
    input uart_rx;

    output [15:0]TFT_RGB;
    output TFT_HS;
    output TFT_VS;
    output TFT_DE;
    output TFT_CLK;
    output TFT_BL;
    output led;

    wire [7:0]rx_data;
    wire rx_done;

    wire ram_wren;
    wire [15:0]ram_wraddr;
    wire [15:0]ram_wrdata;
    wire [15:0]ram_rddata;
    reg [15:0]ram_rdaddr;
    wire Clk_TFT;
    wire [11:0]hcount,vcount;
    wire ram_data_en;
    wire [15:0]disp_data;
    wire locked;
    // 分頻ip
    clk_div clk_div_inst0(
                .clk_out1(Clk_TFT),
                .reset(Reset_p),
                .clk_in1(Clk)// 125M
            );
    // *[uart接收]ip
    uart_byte_rx uart_byte_rx_inst0(
                     .Clk(Clk),
                     .Reset_p(Reset_p),
                     .uart_rx(uart_rx),
                     .Rx_Done(Rx_Done),
                     .Rx_Data(Rx_Data)
                 );
    // *[接收uart信號寫入ram]ip
    img_rx_homework img_rx_homework_inst0(
                        .Clk(Clk),
                        .Reset_p(Reset_p),
                        .rx_data(Rx_Data),
                        .rx_done(Rx_Done),
                        .ram_wren(ram_wren),
                        .ram_wraddr(ram_wraddr),
                        .ram_wrdata(ram_wrdata),
                        .led(led)
                    );
    // ram ip
    RAM RAM_inst0 (
            .clka(Clk),    // input wire clka
            .ena(1),      // input wire ena
            .wea(ram_wren),      // input wire [0 : 0] wea
            .addra(ram_wraddr),  // input wire [15 : 0] addra
            .dina(ram_wrdata),    // input wire [15 : 0] dina

            .clkb(TFT_CLK),    // input wire clkb
            .enb(1),      // input wire enb
            .addrb(ram_rdaddr),  // input wire [15 : 0] addrb
            .doutb(ram_rddata)  // output wire [15 : 0] doutb
        );
    // *[TFT驅動]ip
    TFT_CTRL TFT_CTRL_inst0(
                 .CLK(Clk_TFT),
                 .Reset_p(Reset_p),
                 .Data_in(disp_data),
                 .Data_req(Data_req),
                 .hcount(hcount),
                 .vcount(vcount),
                 .TFT_HS(TFT_HS),
                 .TFT_VS(TFT_VS),
                 .TFT_DE(TFT_DE),
                 .TFT_CLK(TFT_CLK),
                 .TFT_DATA(TFT_RGB),
                 .TFT_BL(TFT_BL)// 背光
             );
    // ! 當ram_data_en為真開始讀出像素資料
    always@(posedge Clk_TFT or posedge Reset_p)
        if(Reset_p)
            ram_rdaddr<=0;
        else if(ram_data_en)
            ram_rdaddr<=ram_rdaddr+1;

    // ! 只用TFT螢幕中間區域顯示
    assign ram_data_en =
           Data_req&&
           (hcount>=272&&hcount<528)&&
           (vcount>=112&&vcount<368);

    // 中間以外區域不顯示顏色
    assign disp_data=ram_data_en?ram_rddata:0;

endmodule

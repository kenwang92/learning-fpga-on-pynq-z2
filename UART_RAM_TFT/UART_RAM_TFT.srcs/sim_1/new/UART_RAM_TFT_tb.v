`timescale 1ns/1ns
module UART_RAM_TFT_tb ();
    // reg Clk;
    // reg Reset_p;
    // reg [7:0]rx_data;
    // reg rx_done;
    // wire ram_wren;
    // wire [15:0]ram_wraddr;// 64Kb
    // wire [15:0]ram_wrdata;
    // wire led;

    // img_rx_homework img_rx_homework(
    //                     .Clk(Clk),
    //                     .Reset_p(Reset_p),
    //                     .rx_data(rx_data),
    //                     .rx_done(rx_done),
    //                     .ram_wren(ram_wren),
    //                     .ram_wraddr(ram_wraddr),
    //                     .ram_wrdata(ram_wrdata),
    //                     .led(led)
    //                 );
    reg Clk;
    reg Reset_p;
    reg uart_rx;

    wire [15:0]TFT_RGB;
    wire TFT_HS;
    wire TFT_VS;
    wire TFT_DE;
    wire TFT_CLK;
    wire TFT_BL;
    wire led;
    UART_RAM_TFT UART_RAM_TFT_inst0(
                     .Clk(Clk),
                     .Reset_p(Reset_p),
                     .uart_rx(uart_rx),
                     .TFT_RGB(TFT_RGB),
                     .TFT_HS(TFT_HS),
                     .TFT_VS(TFT_VS),
                     .TFT_DE(TFT_DE),
                     .TFT_CLK(TFT_CLK),
                     .TFT_BL(TFT_BL),
                     .led(led)
                 );

    initial
        Clk=1;
    always #4 Clk=~Clk;

    initial begin
        Reset_p=1;
        // rx_done=0;
        // rx_data=0;
        #81;
        Reset_p=0;
        #2000;
        #20000000;
        // #800
        //  rx_data=255;
        // repeat(131072) begin
        //     rx_done=1;
        //     #8;
        //     rx_done=0;
        //     #80;
        //     rx_data=rx_data-1;
        // end
        // #800000;
        // repeat(131072) begin
        //     rx_done=1;
        //     #8;
        //     rx_done=0;
        //     #80;
        //     rx_data=rx_data-1;
        // end
        $stop;
    end
endmodule

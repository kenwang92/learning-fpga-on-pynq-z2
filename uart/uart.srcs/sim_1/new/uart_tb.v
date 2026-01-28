`timescale 1ns/1ns

module uart_tb ();
    // reg [7:0]Data;
    reg Clk;
    reg Reset_p;
    reg Rx;
    // reg uart_rx;
    wire Rx_Done;
    wire [7:0]Rx_Data;
    // reg Send_Go;
    wire Led;
    // wire Uart_tx;
    // wire Tx_Done;
    // uart uart_inst0(
    // uart_example uart_inst0(
    // uart_homework uart_inst0(
    // uart_rx uart_inst0(
    // uart_byte_rx uart_inst0(
    uart_byte_rx_test uart_inst0(
                     //   .Data(Data),
                     .Clk(Clk),
                     .Reset_p(Reset_p),
                     .uart_rx(Rx),
                    //  .Rx_Done(Rx_Done),
                     .Rx_Data(Rx_Data),
                     // .Rx(Rx)
                       .Led(Led)
                     //   .Uart_tx(Uart_tx)
                     //  .Send_Go(Send_Go),
                     //  .Tx_Done(Tx_Done)
                 );
    // defparam uart_inst0.TIME_UNIT_MS = 1;
    initial
        Clk = 1;
    always #4 Clk=~Clk;

    initial begin

        // Data=8'b0000_0000;
        // Send_Go=0;
        Rx=1;
        // uart_rx=1;
        Reset_p=1;
        #201;
        Reset_p=0;
        #500;

        // 8'b01000101
        Rx=0;
        #(13*8);// Start
        // #50;// glitch start

        Rx=1;
        #104;
        Rx=0;
        #104;
        Rx=1;
        #104;
        Rx=0;
        #104;

        Rx=0;
        #104;
        Rx=0;
        #104;
        Rx=1;
        #104;
        Rx=0;
        #104;

        Rx=1;
        #104;// Stop

        #(13*8*10);

        // 8'b0000_1111
        Rx=0;
        #(13*8);// Start
        // #50;// glitch start

        Rx=1;
        #104;
        Rx=1;
        #104;
        Rx=1;
        #104;
        Rx=1;
        #104;

        Rx=0;
        #104;
        Rx=0;
        #104;
        Rx=0;
        #104;
        Rx=0;
        #104;

        Rx=1;
        #104;// Stop

        #40_000_000;

        // Data=8'b1010_0001;
        // Send_Go=1;
        // #8;
        // Send_Go=0;
        // #40_000_000;

        // Data=8'b1000_0001;
        // Send_Go=1;
        // #8;
        // Send_Go=0;
        // #40_000_000;

        $stop;
    end
endmodule

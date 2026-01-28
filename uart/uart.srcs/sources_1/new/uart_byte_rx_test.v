module uart_byte_rx_test(
        Clk,
        Reset_p,
        uart_rx,
        Led,
        Rx_Data
    );
    input Clk;
    input Reset_p;
    input uart_rx;
    output reg Led;
    output [7:0]Rx_Data;

    uart_byte_rx uart_byte_rx_inst0(
                     .Clk(Clk),
                     .Reset_p(Reset_p),
                     .uart_rx(uart_rx),
                     .Rx_Done(Rx_Done),
                     .Rx_Data(Rx_Data)
                 );
    defparam uart_byte_rx_inst0.TIME_UNIT_MS = 1000;

    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            Led<=0;
        else if(Rx_Done)
            Led<=~Led;
endmodule

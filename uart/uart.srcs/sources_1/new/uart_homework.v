module uart_homework (
        Clk,
        Reset_p,
        Data,
        Uart_tx,
        Led
    );
    input Clk;
    input Reset_p;
    input [7:0]Data;
    output reg Led;
    output wire Uart_tx;

    uart_example uart_inst0(
                     .Clk(Clk),
                     .Reset_p(Reset_p),
                     .Data(Data),
                     .Uart_tx(Uart_tx),
                     .Send_Go(r_Send_Go),
                     .Tx_Done(Tx_Done)
                 );
    defparam uart_inst0.TIME_UNIT_MS=1000;

    parameter TIME_UNIT_MS=1000;
    parameter MCNT_SEND = 125_000*TIME_UNIT_MS-1;
    reg r_Send_Go;
    reg  [26:0]send_cnt;

    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            send_cnt<=0;
        else if(send_cnt==MCNT_SEND)
            send_cnt<=0;
        else
            send_cnt<=send_cnt+1'd1;
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            r_Send_Go<=0;
        else if(send_cnt==MCNT_SEND)
            r_Send_Go<=1;
        else
            r_Send_Go<=0;
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            Led<=0;
        else if(Tx_Done)
            Led<=~Led;
endmodule

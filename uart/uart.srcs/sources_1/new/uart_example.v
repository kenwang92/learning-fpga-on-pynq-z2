module uart_example (
        Clk,
        Reset_p,
        Data,
        Send_Go,
        Uart_tx,
        Tx_Done
    );
    input Clk;
    input Reset_p;
    input Send_Go;// 開始發送訊號
    input [7:0]Data;
    output reg Uart_tx;
    output reg Tx_Done;//發送完成訊號

    parameter TIME_UNIT_MS = 1000;

    parameter BAUD = 9600;
    parameter CLOCK_FREQ = 125_000_000;

    parameter BAUD_MCNT = 13*TIME_UNIT_MS-1;  // (1/9600)s counter
    // parameter BAUD_MCNT = CLOCK_FREQ/BAUD-1;  // (1/9600)s counter
    parameter BIT_MCNT = 10-1;

    reg [29:0] baud_div_cnt;  // (1/9600)s counter
    reg [3:0] bit_cnt;  // counter 0-9
    reg [7:0] r_Data;  // store Data[7:0]
    reg en_baud_cnt;
    wire w_Tx_Done;

    always @(posedge Clk or posedge Reset_p)
        if(Reset_p)
            baud_div_cnt<=0;
        else if(en_baud_cnt)
            if(baud_div_cnt==BAUD_MCNT)
                baud_div_cnt<=0;
            else
                baud_div_cnt<=baud_div_cnt+1'd1;
        else
            baud_div_cnt<=0;
    always @(posedge Clk or posedge Reset_p)
        if(Reset_p)
            en_baud_cnt<=0;
        else if(Send_Go)
            en_baud_cnt<=1;
        else if(w_Tx_Done)
            en_baud_cnt<=0;
    always @(posedge Clk or posedge Reset_p)
        if(Reset_p)
            bit_cnt<=0;
        else if(baud_div_cnt==BAUD_MCNT)
            if(bit_cnt==BIT_MCNT)
                bit_cnt<=0;
            else
                bit_cnt<=bit_cnt+1'd1;

    always @(posedge Clk or posedge Reset_p)
        if(Reset_p)
            r_Data<=0;
        else if(Send_Go)
            r_Data<=Data;
        else
            r_Data<=r_Data;
    // always @(posedge Clk)
    //     if(Send_Go)
    //         r_Data<=Data;

    always @(posedge Clk or posedge Reset_p)
        if(Reset_p)
            Uart_tx<=1'd1;
        else if(en_baud_cnt==0)
            Uart_tx<=1'd1;
        else
        case (bit_cnt)
            0:
                Uart_tx <= 0;  // Start
            1:
                Uart_tx <= r_Data[0];
            2:
                Uart_tx <= r_Data[1];
            3:
                Uart_tx <= r_Data[2];
            4:
                Uart_tx <= r_Data[3];
            5:
                Uart_tx <= r_Data[4];
            6:
                Uart_tx <= r_Data[5];
            7:
                Uart_tx <= r_Data[6];
            8:
                Uart_tx <= r_Data[7];
            9:
                Uart_tx <= 1'd1;  // Stop
            default:
                Uart_tx <= Uart_tx;
        endcase
    // 讓Tx_Done在發送完成後改變狀態
    assign w_Tx_Done=((bit_cnt==9)&&(baud_div_cnt==BAUD_MCNT));
    always @(posedge Clk)
        if(Reset_p)
            Tx_Done<=0;
        else
            Tx_Done<=w_Tx_Done;

endmodule

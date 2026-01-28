module uart_byte_rx (
        Clk,
        Reset_p,
        uart_rx,
        Rx_Done,
        Rx_Data
    );
    input Clk;
    input uart_rx;
    input Reset_p;
    output reg [7:0]Rx_Data;
    output reg Rx_Done;

    parameter TIME_UNIT_MS = 1000;
    parameter MCNT_BAUD = 13*TIME_UNIT_MS-1;
    parameter MCNT_BAUD_MID = MCNT_BAUD/2;

    reg [7:0]r_Rx_Data;
    reg [26:0]baud_div_cnt;
    reg en_baud_cnt;
    reg [3:0]bit_cnt;
    wire w_Rx_Done;
    wire nedge_uart_rx;
    reg r_uart_rx;
    reg dff0_uart_rx,dff1_uart_rx;
    // Baud Rate Counter邏輯
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            baud_div_cnt<=0;
        else if(en_baud_cnt)
            if(baud_div_cnt==MCNT_BAUD)
                baud_div_cnt<=0;
            else
                baud_div_cnt<=baud_div_cnt+1'd1;
        else
            baud_div_cnt<=0;

    // uart信號邊緣檢測邏輯
    always@(posedge Clk)
        dff0_uart_rx<=uart_rx;

    always@(posedge Clk)
        dff1_uart_rx<=dff0_uart_rx;

    always@(posedge Clk)
        r_uart_rx<=dff1_uart_rx;

    assign nedge_uart_rx=(dff1_uart_rx==0) && (r_uart_rx==1);
    // Baud Rate Counter enable邏輯
    always @(posedge Clk or posedge Reset_p)
        if(Reset_p)
            en_baud_cnt<=0;
        else if(nedge_uart_rx)
            en_baud_cnt<=1;
        else if((bit_cnt==0) && (dff1_uart_rx==1 )&& (baud_div_cnt==MCNT_BAUD_MID))// 處理glitch
            en_baud_cnt<=0;
        else if(bit_cnt==9 && baud_div_cnt==MCNT_BAUD_MID)// 提前讀取停止位，避免連續讀取遺失數據
            en_baud_cnt<=0;

    always @(posedge Clk or posedge Reset_p)
        if(Reset_p)
            bit_cnt<=0;
        else if((baud_div_cnt==MCNT_BAUD_MID) && (bit_cnt==9))
            bit_cnt<=0;
        else if(baud_div_cnt==MCNT_BAUD)
            bit_cnt<=bit_cnt+1'd1;
    // Rx接收邏輯
    always @(posedge Clk or posedge Reset_p)
        if(Reset_p)
            r_Rx_Data<=8'd0;
        else if(baud_div_cnt==MCNT_BAUD_MID)
        case (bit_cnt)
            1:
                r_Rx_Data[0]<=dff1_uart_rx;
            2:
                r_Rx_Data[1]<=dff1_uart_rx;
            3:
                r_Rx_Data[2]<=dff1_uart_rx;
            4:
                r_Rx_Data[3]<=dff1_uart_rx;
            5:
                r_Rx_Data[4]<=dff1_uart_rx;
            6:
                r_Rx_Data[5]<=dff1_uart_rx;
            7:
                r_Rx_Data[6]<=dff1_uart_rx;
            8:
                r_Rx_Data[7]<=dff1_uart_rx;
            default:
                r_Rx_Data<=r_Rx_Data;
        endcase
    // 接收完成Tag
    assign w_Rx_Done=(baud_div_cnt==MCNT_BAUD_MID)&&(bit_cnt==9);
    always@(posedge Clk)
        Rx_Done<=w_Rx_Done;
    // 完成傳輸後一次接受全部資料
    always@(posedge Clk)
        if(w_Rx_Done)
            Rx_Data<=r_Rx_Data;

endmodule

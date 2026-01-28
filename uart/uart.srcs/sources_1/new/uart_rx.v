// Uart Rx 自己寫
module uart_rx (
        Clk,
        Reset_p,
        Rx_Done,
        Rx,
        Rx_Data
    );
    input Rx;
    input Clk;
    input Reset_p;
    output reg Rx_Done;
    output reg [7:0]Rx_Data;

    parameter TIME_UNIT_MS = 1000;
    parameter MCNT_BAUD = 13*TIME_UNIT_MS-1;
    parameter MCNT_BAUD_MID = MCNT_BAUD/2;
    parameter MCNT_BIT = 10-1;
    reg [26:0]baud_cnt;
    reg [3:0]bit_cnt;
    reg level_delay;
    reg en_baud_cnt;
    wire level_fall;
    // 位計數器邏輯
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            bit_cnt<=0;
        else if((baud_cnt==MCNT_BAUD))
            if(bit_cnt==MCNT_BIT)
                bit_cnt<=0;
            else
                bit_cnt<=bit_cnt+1'd1;

    // Rx下降沿檢測
    assign level_fall=~Rx&level_delay;
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            level_delay<=1;
        else
            level_delay<=Rx;
    // 檢測到Rx下降沿 enable Baud Rate Counter
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            en_baud_cnt<=0;
        else if(level_fall)
            en_baud_cnt<=1'd1;
        else if(bit_cnt==MCNT_BIT & baud_cnt==MCNT_BAUD)
            en_baud_cnt<=0;
        else if((bit_cnt==0) & Rx & (baud_cnt==MCNT_BAUD_MID))// Detect Glitch
            en_baud_cnt<=0;
        else
            en_baud_cnt<=en_baud_cnt;
    // Baud Rate Counter
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            baud_cnt<=0;
        else if(en_baud_cnt)
            if(baud_cnt==MCNT_BAUD)
                baud_cnt<=0;
            else
                baud_cnt<=baud_cnt+1'd1;
        else
            baud_cnt<=0;
    // Data from Rx
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            Rx_Data<=0;
        else if(baud_cnt==MCNT_BAUD_MID)
        case (bit_cnt)
            1:
                Rx_Data[0]<=Rx;
            2:
                Rx_Data[1]<=Rx;
            3:
                Rx_Data[2]<=Rx;
            4:
                Rx_Data[3]<=Rx;
            5:
                Rx_Data[4]<=Rx;
            6:
                Rx_Data[5]<=Rx;
            7:
                Rx_Data[6]<=Rx;
            8:
                Rx_Data[7]<=Rx;
            default:
                Rx_Data<=Rx_Data;
        endcase
    // Rx Done Tag
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            Rx_Done<=0;
        else if(bit_cnt==MCNT_BIT & baud_cnt==MCNT_BAUD)
            Rx_Done<=1'd1;
endmodule

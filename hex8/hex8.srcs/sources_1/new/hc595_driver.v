// 自己寫
module hc595_driver (
        Clk,
        Reset_p,
        SEG,
        SEL,
        DIO,
        SRCLK,
        RCLK
    );
    input Clk;
    input Reset_p;
    input [7:0]SEL;
    input [7:0]SEG;
    output reg DIO;
    output SRCLK;
    output RCLK;

    reg [29:0]cnt;
    parameter MCNT=10-1;//12.5Mhz
    parameter MCNT_SRCLK = 5-1;
    parameter MCNT_RCLK = 5-1;

    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            cnt<=0;
        else if(cnt==MCNT)
            cnt<=0;
        else
            cnt<=cnt+1'd1;

    reg [3:0]cnt_dio;// 16 counter
    always @(posedge Clk or posedge Reset_p)
        if(Reset_p)
            cnt_dio<=0;
        else if(cnt==MCNT)
            cnt_dio<=cnt_dio+1'd1;

    assign SRCLK=(cnt>MCNT_SRCLK)?1'd1:1'd0;
    assign RCLK=(cnt<=MCNT_RCLK&cnt_dio==0)?1'd1:1'd0;

    always @(*)
    case(cnt_dio)
        0:
            DIO<=SEG[7];
        1:
            DIO<=SEG[6];
        2:
            DIO<=SEG[5];
        3:
            DIO<=SEG[4];
        4:
            DIO<=SEG[3];
        5:
            DIO<=SEG[2];
        6:
            DIO<=SEG[1];
        7:
            DIO<=SEG[0];

        8:
            DIO<=SEL[7];
        9:
            DIO<=SEL[6];
        10:
            DIO<=SEL[5];
        11:
            DIO<=SEL[4];
        12:
            DIO<=SEL[3];
        13:
            DIO<=SEL[2];
        14:
            DIO<=SEL[1];
        15:
            DIO<=SEL[0];
    endcase
endmodule

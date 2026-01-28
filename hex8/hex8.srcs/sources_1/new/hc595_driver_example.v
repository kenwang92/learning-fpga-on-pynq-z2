// 範例
module hc595_driver_example (
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
    input [7:0]SEG;
    input [7:0]SEL;
    output reg DIO;
    output reg SRCLK;
    output reg RCLK;

    parameter CLOCK_FREQ = 125_000_000;
    parameter SRCLK_FREQ = 12_500_000;
    parameter MCNT = CLOCK_FREQ/(SRCLK_FREQ*2)-1;

    reg [29:0]div_cnt;
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            div_cnt<=0;
        else if(div_cnt==MCNT)
            div_cnt<=0;
        else
            div_cnt<=div_cnt+1'd1;

    reg [4:0]cnt;
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            cnt<=0;
        else if(div_cnt==MCNT)
            cnt<=cnt+1'd1;

    always@(posedge Clk or posedge Reset_p)
        if(Reset_p) begin
            DIO<=1'd0;
            SRCLK<=1'd0;
            RCLK<=1'd0;
        end
        else
        case (cnt)
            0: begin
                DIO<=SEG[7];
                SRCLK<=1'd0;
                RCLK<=1'd1;
            end
            1: begin
                SRCLK<=1'd1;
                RCLK<=1'd0;
            end
            2: begin
                DIO<=SEG[6];
                SRCLK<=1'd0;
            end
            3:
                SRCLK<=1'd1;
            4: begin
                DIO<=SEG[5];
                SRCLK<=1'd0;
            end
            5:
                SRCLK<=1'd1;
            6: begin
                DIO<=SEG[4];
                SRCLK<=1'd0;
            end
            7:
                SRCLK<=1'd1;
            8: begin
                DIO<=SEG[3];
                SRCLK<=1'd0;
            end
            9:
                SRCLK<=1'd1;
            10: begin
                DIO<=SEG[2];
                SRCLK<=1'd0;
            end
            11:
                SRCLK<=1'd1;
            12: begin
                DIO<=SEG[1];
                SRCLK<=1'd0;
            end
            13:
                SRCLK<=1'd1;
            14: begin
                DIO<=SEG[0];
                SRCLK<=1'd0;
            end
            15:
                SRCLK<=1'd1;
            16: begin
                DIO<=SEL[7];
                SRCLK<=1'd0;
            end
            17:
                SRCLK<=1'd1;
            18: begin
                DIO<=SEL[6];
                SRCLK<=1'd0;
            end
            19:
                SRCLK<=1'd1;
            20: begin
                DIO<=SEL[5];
                SRCLK<=1'd0;
            end
            21:
                SRCLK<=1'd1;
            22: begin
                DIO<=SEL[4];
                SRCLK<=1'd0;
            end
            23:
                SRCLK<=1'd1;
            24: begin
                DIO<=SEL[3];
                SRCLK<=1'd0;
            end
            25:
                SRCLK<=1'd1;
            26: begin
                DIO<=SEL[2];
                SRCLK<=1'd0;
            end
            27:
                SRCLK<=1'd1;
            28: begin
                DIO<=SEL[1];
                SRCLK<=1'd0;
            end
            29:
                SRCLK<=1'd1;
            30: begin
                DIO<=SEL[0];
                SRCLK<=1'd0;
            end
            31:
                SRCLK<=1'd1;
        endcase

endmodule

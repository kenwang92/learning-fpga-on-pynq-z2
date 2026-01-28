module tlv5618_driver_homework (
        Clk,
        Reset_p,
        CS_N,
        SCLK,
        DIN,
        DAC_DATA,
        Set_Go,
        Set_Done
    );
    input Clk;
    input Reset_p;
    input [15:0]DAC_DATA;
    input Set_Go;
    output reg Set_Done;
    output reg CS_N;
    output reg SCLK;
    output reg DIN;

    parameter CLOCK_FREQ = 125_000_000;
    parameter SCLK_FREQ = 12_500_000;
    parameter MCNT_DIV_CNT = CLOCK_FREQ/(SCLK_FREQ*2)-1;
    // parameter MCNT_DIV_CNT = 3-1;
    parameter MCNT_LSM_CNT = 33;

    reg [5:0]lsm_cnt;
    reg [7:0]div_cnt;
    reg [15:0]R_DAC_DATA;

    always@(posedge Clk)
        if(Set_Go)
            R_DAC_DATA<=DAC_DATA;

    // Divider Counter Enable邏輯
    reg Set_En;
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            Set_En<=1'd0;
        else if(Set_Go)
            Set_En<=1'd1;
        else if((div_cnt==MCNT_DIV_CNT)&&(lsm_cnt==MCNT_LSM_CNT))
            Set_En<=1'd0;

    // SCLK最小時間單位計數器
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            div_cnt<=0;
        else if(Set_En)
            if(div_cnt==MCNT_DIV_CNT)
                div_cnt<=1'd0;
            else
                div_cnt<=div_cnt+1'd1;
        else
            div_cnt<=1'd0;

    // SCLK計數35次
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            lsm_cnt<=6'd0;
        else if(div_cnt==MCNT_DIV_CNT)
            if(lsm_cnt==MCNT_LSM_CNT)
                lsm_cnt<=6'd0;
            else
                lsm_cnt<=lsm_cnt+1'd1;
    // LSM
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p) begin
            SCLK<=1'd0;
            DIN<=1'd1;
            CS_N<=1'd1;
        end
        else if(div_cnt==MCNT_DIV_CNT)
        case (lsm_cnt)
            0: begin
                CS_N<=1'd0;
                DIN<=R_DAC_DATA[15];
                SCLK<=1'd1;
            end
            1:
                SCLK<=1'd0;
            2: begin
                DIN<=R_DAC_DATA[14];
                SCLK<=1'd1;
            end
            3:
                SCLK<=1'd0;
            4: begin
                DIN<=R_DAC_DATA[13];
                SCLK<=1'd1;
            end
            5:
                SCLK<=1'd0;
            6: begin
                DIN<=R_DAC_DATA[12];
                SCLK<=1'd1;
            end
            7:
                SCLK<=1'd0;
            8: begin
                DIN<=R_DAC_DATA[11];
                SCLK<=1'd1;
            end
            9:
                SCLK<=1'd0;
            10: begin
                DIN<=R_DAC_DATA[10];
                SCLK<=1'd1;
            end
            11:
                SCLK<=1'd0;
            12: begin
                DIN<=R_DAC_DATA[9];
                SCLK<=1'd1;
            end
            13:
                SCLK<=1'd0;
            14: begin
                DIN<=R_DAC_DATA[8];
                SCLK<=1'd1;
            end
            15:
                SCLK<=1'd0;
            16: begin
                DIN<=R_DAC_DATA[7];
                SCLK<=1'd1;
            end
            17:
                SCLK<=1'd0;
            18: begin
                DIN<=R_DAC_DATA[6];
                SCLK<=1'd1;
            end
            19:
                SCLK<=1'd0;
            20: begin
                DIN<=R_DAC_DATA[5];
                SCLK<=1'd1;
            end
            21:
                SCLK<=1'd0;
            22: begin
                DIN<=R_DAC_DATA[4];
                SCLK<=1'd1;
            end
            23:
                SCLK<=1'd0;
            24: begin
                DIN<=R_DAC_DATA[3];
                SCLK<=1'd1;
            end
            25:
                SCLK<=1'd0;
            26: begin
                DIN<=R_DAC_DATA[2];
                SCLK<=1'd1;
            end
            27:
                SCLK<=1'd0;
            28: begin
                DIN<=R_DAC_DATA[1];
                SCLK<=1'd1;
            end
            29:
                SCLK<=1'd0;
            30: begin
                DIN<=R_DAC_DATA[0];
                SCLK<=1'd1;
            end
            31:
                SCLK<=1'd0;
            32:
                SCLK<=1'd1;
            33:
                CS_N<=1'd1;
            default:
                CS_N<=1'd1;
        endcase
    // 完成傳輸後一次接受全部資料，完成Tag設1
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            Set_Done<=0;
        else if((div_cnt==MCNT_DIV_CNT)&&(lsm_cnt==MCNT_LSM_CNT))
            Set_Done<=1'd1;
        else
            Set_Done<=1'd0;
endmodule


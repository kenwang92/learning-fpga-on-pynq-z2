module adc128s102_driver_homework (
        Clk,
        Reset_p,
        Addr,
        Data,
        Conv_Go,
        Conv_Done,
        ADC_CS_N,
        ADC_SCLK,
        ADC_DIN,
        ADC_DOUT
    );
    input Clk;
    input Reset_p;
    input [2:0]Addr;
    input Conv_Go;
    input ADC_DOUT;

    output reg [11:0]Data;
    output reg Conv_Done;
    output reg ADC_CS_N;
    output reg ADC_SCLK;
    output reg ADC_DIN;

    parameter CLOCK_FREQ = 125_000_000;
    parameter ADC_SCLK_FREQ = 12_500_000;
    parameter MCNT_DIV_CNT = CLOCK_FREQ/(ADC_SCLK_FREQ*2)-1;

    reg [5:0]lsm_cnt;
    reg [7:0]div_cnt;
    reg [2:0]r_Addr;
    reg [11:0]r_data;

    // Divider Counter Enable邏輯
    reg Conv_En;
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            Conv_En<=1'd0;
        else if(Conv_Go)
            Conv_En<=1'd1;
        else if((div_cnt==MCNT_DIV_CNT)&&(lsm_cnt==6'd34))
            Conv_En<=1'd0;

    // ADC_SCLK最小時間單位計數器
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            div_cnt<=0;
        else if(Conv_En)
            if(div_cnt==MCNT_DIV_CNT)
                div_cnt<=1'd0;
            else
                div_cnt<=div_cnt+1'd1;
        else
            div_cnt<=1'd0;

    // ADC_SCLK計數35次
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            lsm_cnt<=6'd0;
        else if(div_cnt==MCNT_DIV_CNT)
            if(lsm_cnt==34)
                lsm_cnt<=6'd0;
            else
                lsm_cnt<=lsm_cnt+1'd1;
    // 存住Addr避免傳輸時改變
    always@(posedge Clk)
        if(Conv_Go)
            r_Addr<=Addr;
    // LSM
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p) begin
            ADC_SCLK<=1'd1;
            ADC_DIN<=1'd1;
            ADC_CS_N<=1'd1;
            Conv_Done<=1'd0;
            Data<=1'd0;
            r_data<=12'd0;
        end
        else if(div_cnt==MCNT_DIV_CNT)
        case (lsm_cnt)
            0: begin
                ADC_CS_N<=1'd1;
                ADC_SCLK<=1'd1;
            end
            1:
                ADC_CS_N<=1'd0;
            2:
                ADC_SCLK<=1'd0;
            3:
                ADC_SCLK<=1'd1;
            4:
                ADC_SCLK<=1'd0;
            5:
                ADC_SCLK<=1'd1;
            6: begin
                ADC_SCLK<=1'd0;
                ADC_DIN<=r_Addr[2];
            end
            7:
                ADC_SCLK<=1'd1;
            8: begin
                ADC_SCLK<=1'd0;
                ADC_DIN<=r_Addr[1];
            end
            9:
                ADC_SCLK<=1'd1;
            10: begin
                ADC_SCLK<=1'd0;
                ADC_DIN<=r_Addr[0];
            end
            11: begin
                ADC_SCLK<=1'd1;
                r_data[11] <= ADC_DOUT;
            end
            12:
                ADC_SCLK<=1'd0;
            13: begin
                ADC_SCLK<=1'd1;
                r_data[10] <= ADC_DOUT;
            end
            14:
                ADC_SCLK<=1'd0;
            15: begin
                ADC_SCLK<=1'd1;
                r_data[9] <= ADC_DOUT;
            end
            16:
                ADC_SCLK<=1'd0;
            17: begin
                ADC_SCLK<=1'd1;
                r_data[8] <= ADC_DOUT;
            end
            18:
                ADC_SCLK<=1'd0;
            19: begin
                ADC_SCLK<=1'd1;
                r_data[7] <= ADC_DOUT;
            end
            20:
                ADC_SCLK<=1'd0;
            21: begin
                ADC_SCLK<=1'd1;
                r_data[6] <= ADC_DOUT;
            end
            22:
                ADC_SCLK<=1'd0;
            23: begin
                ADC_SCLK<=1'd1;
                r_data[5] <= ADC_DOUT;
            end
            24:
                ADC_SCLK<=1'd0;
            25: begin
                ADC_SCLK<=1'd1;
                r_data[4] <= ADC_DOUT;
            end
            26:
                ADC_SCLK<=1'd0;
            27: begin
                ADC_SCLK<=1'd1;
                r_data[3] <= ADC_DOUT;
            end
            28:
                ADC_SCLK<=1'd0;
            29: begin
                ADC_SCLK<=1'd1;
                r_data[2] <= ADC_DOUT;
            end
            30:
                ADC_SCLK<=1'd0;
            31: begin
                ADC_SCLK<=1'd1;
                r_data[1] <= ADC_DOUT;
            end
            32:
                ADC_SCLK<=1'd0;
            33: begin
                ADC_SCLK<=1'd1;
                r_data[0] <= ADC_DOUT;
            end
            34:
                ADC_CS_N<=1'd1;
            default:
                ADC_CS_N<=1'd1;
        endcase
    // 完成傳輸Tag
    assign w_Conv_Done=(div_cnt==MCNT_DIV_CNT)&&(lsm_cnt==34);
    always@(posedge Clk) begin
        Conv_Done<=w_Conv_Done;
    end
    // 完成傳輸後一次接受全部資料
    always@(posedge Clk)
        if(w_Conv_Done)
            Data<=r_data;
endmodule

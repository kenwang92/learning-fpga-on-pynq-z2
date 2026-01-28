module bme280_driver (
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
    input Conv_Go;
    input [7:0]Addr;

    output reg Conv_Done;
    output reg [7:0]Data;

    output reg ADC_SCLK;
    output reg ADC_CS_N;
    output reg ADC_DIN;
    input ADC_DOUT;

    parameter CLOCK_FREQ = 125_000_000;
    parameter SCLK_FREQ = 5_000_000;
    // parameter MCNT_DIV_CNT = CLOCK_FREQ/(SCLK_FREQ*2)-1;
    parameter MCNT_DIV_CNT = 13-1;// 12.5
    parameter MCNT_LSM = 34;

    reg [7:0]r_Addr;
    reg [5:0]LSM_CNT;
    reg [7:0]DIV_CNT;
    reg [7:0]Data_r;
    // 存住Addr避免傳輸時改變
    always@(posedge Clk)
        if(Conv_Go)
            r_Addr<=Addr;
        else
            r_Addr<=r_Addr;

    // Divider Counter Enable邏輯
    reg Conv_En;
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            Conv_En<=1'd0;
        else if(Conv_Go)
            Conv_En<=1'd1;
        else if((DIV_CNT==MCNT_DIV_CNT)&&(LSM_CNT==MCNT_LSM))
            Conv_En<=1'd0;
        else
            Conv_En<=Conv_En;

    // ADC_SCLK最小時間單位計數器
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            DIV_CNT<=0;
        else if(Conv_En)
            if(DIV_CNT==MCNT_DIV_CNT)
                DIV_CNT<=1'd0;
            else
                DIV_CNT<=DIV_CNT+1'd1;
        else
            DIV_CNT<=0;

    // ADC_SCLK計數
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            LSM_CNT<=6'd0;
        else if(DIV_CNT==MCNT_DIV_CNT)
            if(LSM_CNT==MCNT_LSM)
                LSM_CNT<=6'd0;
            else
                LSM_CNT<=LSM_CNT+1'd1;
        else
            LSM_CNT<=LSM_CNT;
    // LSM
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p) begin
            Data_r<=8'd0;
            ADC_SCLK<=1'd1;
            ADC_DIN<=1'd1;
            ADC_CS_N<=1'd1;
        end
        else if(DIV_CNT==MCNT_DIV_CNT)
        case (LSM_CNT)
            0: begin
                ADC_CS_N<=1'd1;
                ADC_SCLK<=1'd1;
            end
            1:
                ADC_CS_N<=1'd0;
            2: begin
                ADC_SCLK<=1'd0;
                ADC_DIN<=r_Addr[7];
            end
            3:
                ADC_SCLK<=1'd1;
            4: begin
                ADC_DIN<=r_Addr[6];
                ADC_SCLK<=1'd0;
            end
            5:
                ADC_SCLK<=1'd1;
            6: begin
                ADC_SCLK<=1'd0;
                ADC_DIN<=r_Addr[5];
            end
            7:
                ADC_SCLK<=1'd1;
            8: begin
                ADC_SCLK<=1'd0;
                ADC_DIN<=r_Addr[4];
            end
            9:
                ADC_SCLK<=1'd1;
            10: begin
                ADC_SCLK<=1'd0;
                ADC_DIN<=r_Addr[3];
            end
            11:
                ADC_SCLK<=1'd1;
            12: begin
                ADC_DIN<=r_Addr[2];
                ADC_SCLK<=1'd0;
            end
            13:
                ADC_SCLK<=1'd1;

            14: begin
                ADC_DIN<=r_Addr[1];
                ADC_SCLK<=1'd0;
            end
            15:
                ADC_SCLK<=1'd1;

            16: begin
                ADC_DIN<=r_Addr[0];
                ADC_SCLK<=1'd0;
            end
            17: 
                ADC_SCLK<=1'd1;
            18:
                ADC_SCLK<=1'd0;
            19: begin
                ADC_SCLK<=1'd1;
                Data_r[7] <= ADC_DOUT;
            end
            20:
                ADC_SCLK<=1'd0;
            21: begin
                ADC_SCLK<=1'd1;
                Data_r[6] <= ADC_DOUT;
            end
            22:
                ADC_SCLK<=1'd0;
            23: begin
                ADC_SCLK<=1'd1;
                Data_r[5] <= ADC_DOUT;
            end
            24:
                ADC_SCLK<=1'd0;
            25: begin
                ADC_SCLK<=1'd1;
                Data_r[4] <= ADC_DOUT;
            end
            26:
                ADC_SCLK<=1'd0;
            27: begin
                ADC_SCLK<=1'd1;
                Data_r[3] <= ADC_DOUT;
            end
            28:
                ADC_SCLK<=1'd0;
            29: begin
                ADC_SCLK<=1'd1;
                Data_r[2] <= ADC_DOUT;
            end
            30:
                ADC_SCLK<=1'd0;
            31: begin
                ADC_SCLK<=1'd1;
                Data_r[1] <= ADC_DOUT;
            end
            32:
                ADC_SCLK<=1'd0;
            33: begin
                ADC_SCLK<=1'd1;
                Data_r[0] <= ADC_DOUT;
            end
            34:
                ADC_CS_N<=1'd1;
            default:
                ADC_CS_N<=1'd1;
        endcase

    // 完成傳輸後一次接受全部資料，完成Tag設1
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p) begin
            Data<=8'd0;
            Conv_Done<=0;
        end
        else if((DIV_CNT==MCNT_DIV_CNT)&&(LSM_CNT==MCNT_LSM)) begin
            Conv_Done<=1'd1;
            Data<=Data_r;
        end
        else begin
            Conv_Done<=1'd0;
            Data<=Data;
        end
endmodule

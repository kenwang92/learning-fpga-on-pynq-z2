`include "disp_parameter_cfg.v"
module disp_driver (
    CLK_DISP,
    Reset_p,
    Data,
    h_addr,
    v_addr,
    DISP_HS,
    DISP_VS,
    DISP_DE,
    DISP_PCLK,
    disp_red,
    disp_green,
    disp_blue
);
    input CLK_DISP;
    input Reset_p;
    input [`Red+`Green+`Blue-1:0] Data;

    output [11:0] h_addr;
    output [11:0] v_addr;
    output DISP_PCLK;
    output DISP_DE;
    // output [`Red-1:0]disp_red;
    // output [`Green-1:0]disp_green;
    // output [`Blue-1:0]disp_blue;
    // output DISP_HS;
    // output DISP_VS;
    output reg [`Red-1:0] disp_red;
    output reg [`Green-1:0] disp_green;
    output reg [`Blue-1:0] disp_blue;
    output reg DISP_HS;
    output reg DISP_VS;

    reg [11:0] hcnt;
    reg [11:0] vcnt;
    reg        disp_de_r;
    assign DISP_DE   = disp_de_r;
    assign DISP_PCLK = ~CLK_DISP;  // for DAC

    parameter H_DATA_BEGIN = `H_SYNC_TIME + `H_BACK_PORCH + `H_LEFT_BORDER;
    parameter H_DATA_END = `H_TOTAL - `H_RIGHT_BORDER - `H_FRONT_PORCH;
    parameter V_DATA_BEGIN = `V_SYNC_TIME + `V_BACK_PORCH + `V_TOP_BORDER;
    parameter V_DATA_END = `V_TOTAL - `V_BOTTOM_BORDER - `V_FRONT_PORCH;

    // 只有在有效數據輸出範圍計數
    assign h_addr = (disp_de_r) ? (hcnt - H_DATA_BEGIN) : 12'd0;
    assign v_addr = (disp_de_r) ? (vcnt - V_DATA_BEGIN) : 12'd0;

    assign h_scan = (hcnt >= `H_TOTAL - 1);
    assign v_scan = (vcnt >= `V_TOTAL - 1);

    always @(posedge CLK_DISP or posedge Reset_p)
        if (Reset_p) hcnt <= 0;
        else if (h_scan) hcnt <= 0;
        else hcnt <= hcnt + 1'b1;
    always @(posedge CLK_DISP or posedge Reset_p)
        if (Reset_p) vcnt <= 0;
        else if (h_scan)
            if (v_scan) vcnt <= 0;
            else vcnt <= vcnt + 1'b1;
        else vcnt <= vcnt;
    // 有效數據輸出範圍
    always @(posedge CLK_DISP or posedge Reset_p)
        if (Reset_p) disp_de_r <= 0;
        else
            disp_de_r<=((hcnt>=H_DATA_BEGIN)&&
                        (hcnt<H_DATA_END)&&
                        (vcnt>=V_DATA_BEGIN)&&
                        (vcnt<V_DATA_END));
    always @(posedge CLK_DISP or posedge Reset_p)
        if (Reset_p) begin
            disp_red   <= 0;
            disp_green <= 0;
            disp_blue  <= 0;
            DISP_HS    <= 0;
            DISP_VS    <= 0;
        end else begin
            DISP_HS                           <= (hcnt >= `H_SYNC_TIME);
            DISP_VS                           <= (vcnt >= `V_SYNC_TIME);
            {disp_red, disp_green, disp_blue} <= (disp_de_r) ? Data : 0;
        end
    // assign DISP_HS=(hcnt>`H_SYNC_TIME-1);
    // assign DISP_VS=(vcnt>`V_SYNC_TIME-1);
    // assign {disp_red,disp_green,disp_blue}=(disp_de_r)?Data:0;
endmodule

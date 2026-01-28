// 會有偏移
module VGA_CTRL_homework (
        CLK_33M,
        Reset_p,
        Data_in,
        hcount,
        vcount,
        VGA_HS,
        VGA_VS,
        VGA_BLK,
        VGA_CLK,
        VGA_DATA
    );
    input CLK_33M;
    input Reset_p;
    input [23:0]Data_in;
    output reg [10:0]hcount;
    output reg [10:0]vcount;
    output reg VGA_HS;
    output reg VGA_VS;
    output reg VGA_BLK;
    output VGA_CLK;
    output reg [23:0]VGA_DATA;

    reg [10:0]hcnt;// max:1056
    reg [10:0]vcnt;// max:525
    parameter HCNT_SYNC = 128;// HSync_Time
    parameter HCNT_LEFT_BORDER = HCNT_SYNC+ 88 + 0;
    parameter HCNT_DATA = HCNT_LEFT_BORDER+ 800;
    parameter HCNT_FRONT_PORCH = HCNT_DATA+ 0 + 40-1;

    parameter VCNT_SYNC = 2;// VSync_Time
    parameter VCNT_TOP_BORDER = VCNT_SYNC+ 25 + 8;
    parameter VCNT_DATA = VCNT_TOP_BORDER+ 480;
    parameter VCNT_FRONT_PORCH = VCNT_DATA+ 8+ 2-1;

    assign VGA_CLK=~CLK_33M;// 未知原因取反
    always@(posedge CLK_33M or posedge Reset_p)
        if(Reset_p)
            hcnt<=0;
        else if(hcnt==HCNT_FRONT_PORCH)
            hcnt<=0;
        else
            hcnt<=hcnt+1'b1;
    always@(posedge CLK_33M or posedge Reset_p)
        if(Reset_p)
            vcnt<=0;
        else if(hcnt==HCNT_FRONT_PORCH)
            if(vcnt==VCNT_FRONT_PORCH)
                vcnt<=0;
            else
                vcnt<=vcnt+1'd1;
        else
            vcnt<=vcnt;
    // 會右移一個像素，因為循序邏輯判斷造成延遲
    always@(posedge CLK_33M)
            VGA_BLK <=((hcnt>=HCNT_LEFT_BORDER)&&
                       (hcnt<HCNT_DATA)&&
                       (vcnt>=VCNT_TOP_BORDER)&&
                       (vcnt<VCNT_DATA));

    always@(posedge CLK_33M or posedge Reset_p)
        if(Reset_p)
            hcount <=0;
        else if((hcnt>=HCNT_LEFT_BORDER)&&(hcnt<HCNT_DATA))
            hcount<=hcnt-HCNT_LEFT_BORDER;
        else
            hcount<=0;

    always@(posedge CLK_33M or posedge Reset_p)
        if(Reset_p)
            vcount <=0;
        else if((vcnt>=VCNT_TOP_BORDER)&&(vcnt<VCNT_DATA))
            vcount<=vcnt-VCNT_TOP_BORDER;
        else
            vcount<=0;

    always@(posedge CLK_33M or posedge Reset_p)
        if(Reset_p)
            VGA_HS <=0;
        else if(hcnt==HCNT_SYNC)
            VGA_HS<=1;
        else if(hcnt==0)
            VGA_HS<=0;
    always@(posedge CLK_33M or posedge Reset_p)
        if(Reset_p)
            VGA_VS <=0;
        else if(vcnt==VCNT_SYNC)
            VGA_VS<=1;
        else if(vcnt==0)
            VGA_VS<=0;
    always@(posedge CLK_33M or posedge Reset_p)
        if(Reset_p)
            VGA_DATA <=0;
        else if((hcnt>=HCNT_LEFT_BORDER)&&
                (hcnt<HCNT_DATA)&&
                (vcnt>=VCNT_TOP_BORDER)&&
                (vcnt<VCNT_DATA))
            VGA_DATA<=Data_in;
        else
            VGA_DATA<=0;
endmodule

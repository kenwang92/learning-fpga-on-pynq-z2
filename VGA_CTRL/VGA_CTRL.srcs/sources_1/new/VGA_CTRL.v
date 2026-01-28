module VGA_CTRL (
        CLK,
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
    input CLK;
    input Reset_p;
    input [23:0]Data_in;
    output [10:0]hcount;
    output [10:0]vcount;
    output VGA_HS;
    output VGA_VS;
    output VGA_BLK;
    output VGA_CLK;
    output [23:0]VGA_DATA;

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
    always@(posedge CLK or posedge Reset_p)
        if(Reset_p)
            hcnt<=0;
        else if(hcnt==HCNT_FRONT_PORCH)
            hcnt<=0;
        else
            hcnt<=hcnt+1'b1;
    always@(posedge CLK or posedge Reset_p)
        if(Reset_p)
            vcnt<=0;
        else if(hcnt==HCNT_FRONT_PORCH)
            if(vcnt==VCNT_FRONT_PORCH)
                vcnt<=0;
            else
                vcnt<=vcnt+1'd1;
        else
            vcnt<=vcnt;
    // 有效數據輸出範圍
    assign VGA_BLK=
           (hcnt>=HCNT_LEFT_BORDER-1)&&
           (hcnt<HCNT_DATA-1)&&
           (vcnt>=VCNT_TOP_BORDER-1)&&
           (vcnt<VCNT_DATA-1)
           ?1'b1:1'b0;
    assign VGA_CLK=~CLK;// 未知原因取反

    // 只有在有效數據輸出範圍計數
    assign hcount=VGA_BLK?(hcnt-HCNT_LEFT_BORDER):10'd0;
    assign vcount=VGA_BLK?(vcnt-VCNT_TOP_BORDER):10'd0;

    // 大於127為1否則0
    // assign VGA_HS=(hcnt>HCNT_SYNC-1)?1'b1:1'b0;

    // 小於128為0否則1
    assign VGA_HS=(hcnt<HCNT_SYNC)?1'b0:1'b1;

    assign VGA_VS=(vcnt<VCNT_SYNC)?1'b0:1'b1;
    assign VGA_DATA=VGA_BLK?Data_in:0;
endmodule

module TFT_CTRL (
        CLK,
        Reset_p,
        Data_in,
        Data_req,
        hcount,
        vcount,
        TFT_HS,
        TFT_VS,
        TFT_DE,
        TFT_CLK,
        TFT_DATA,
        TFT_BL// 背光
    );
    input CLK;
    input Reset_p;
    input [15:0]Data_in;
    output reg Data_req;
    output reg [11:0]hcount;
    output reg [11:0]vcount;
    output TFT_HS;
    output TFT_VS;
    output TFT_DE;
    output TFT_CLK;
    output reg [15:0]TFT_DATA;
    output TFT_BL;

    reg [11:0]hcnt;// max:1056
    reg [11:0]vcnt;// max:525
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

    assign TFT_CLK=~CLK;// 未知原因取反

    // Data_req替換TFT_DE
    always@(posedge CLK)
        Data_req<=(hcnt>=HCNT_LEFT_BORDER-1)&&
                (hcnt<HCNT_DATA-1)&&
                (vcnt>=VCNT_TOP_BORDER-1)&&
                (vcnt<VCNT_DATA-1)
                ?1'b1:1'b0;

    // Data_req打兩拍給TFT_DE
    reg [3:0]TFT_DE_r;
    always@(posedge CLK) begin
        TFT_DE_r[0]<=Data_req;
        TFT_DE_r[3:1]<=TFT_DE_r[2:0];
    end
    assign TFT_DE=TFT_DE_r[2];


    // 只有在有效數據輸出範圍計數
    always@(posedge CLK) begin
        hcount<=Data_req?(hcnt-HCNT_LEFT_BORDER):10'd0;
        vcount<=Data_req?(vcnt-VCNT_TOP_BORDER):vcount;
    end

    always@(posedge CLK) begin
        TFT_DATA<=Data_req?Data_in:0;
    end

    // HS和VS皆打兩拍
    reg [3:0]TFT_HS_r;
    always@(posedge CLK) begin
        TFT_HS_r[0]<=(hcnt<HCNT_SYNC)?1'b0:1'b1;
        TFT_HS_r[3:1]<=TFT_HS_r[2:0];
    end
    assign TFT_HS=TFT_HS_r[2];

    reg [3:0]TFT_VS_r;
    always@(posedge CLK) begin
        TFT_VS_r[0]<=(vcnt<VCNT_SYNC)?1'b0:1'b1;
        TFT_VS_r[3:1]<=TFT_VS_r[2:0];
    end
    assign TFT_VS=TFT_VS_r[2];

    // 背光總是開啟
    assign TFT_BL = 1;
endmodule

module DVP_Capture (
    Reset_p,
    PCLK,
    Vsync,
    Href,
    Data,

    ImageState,
    DataValid,
    DataPixel,
    DataHS,
    DataVS,
    Xaddr,
    Yaddr
);
    input Reset_p;
    input PCLK;
    input Vsync;
    input Href;
    input [7:0] Data;
    output reg ImageState;
    output DataValid;
    output [15:0] DataPixel;
    output DataHS;
    output DataVS;
    output [11:0] Xaddr;
    output [11:0] Yaddr;

    reg        r_Vsync;
    reg        r_Href;
    reg [ 7:0] r_Data;
    reg [15:0] r_DataPixel;
    reg        r_DataValid;
    reg        r_DataHS;
    reg        r_DataVS;
    reg [12:0] Hcount;
    reg [11:0] Vcount;
    reg [ 3:0] FrameCnt;
    reg        dump_frame;

    always @(posedge PCLK or posedge Reset_p)
        if (Reset_p) ImageState <= 1'b1;
        else if (r_Vsync) ImageState <= 1'b0;

    // 輸入信號打一拍，利於邊沿檢測
    always @(posedge PCLK) begin
        r_Vsync <= Vsync;
        r_Href  <= Href;
        r_Data  <= Data;
    end

    always @(posedge PCLK or posedge Reset_p)
        if (Reset_p) Hcount <= 0;
        else if (r_Href) Hcount <= Hcount + 1'd1;
        else Hcount <= 0;

    // 奇數位填入圖像數據高字節[15:8]
    // 偶數位填入圖像數據低字節[7:0]
    always @(posedge PCLK or posedge Reset_p)
        if (Reset_p) r_DataPixel <= 0;
        else if (!Hcount[0]) r_DataPixel[15:8] <= r_Data;
        else r_DataPixel[7:0] <= r_Data;

    always @(posedge PCLK or posedge Reset_p)
        if (Reset_p) r_DataValid <= 0;
        else if (Hcount[0] && r_Href) r_DataValid <= 1;
        else r_DataValid <= 0;

    always @(posedge PCLK) begin
        r_DataHS <= r_Href;
        r_DataVS <= ~r_Vsync;
    end
    // 行數計數器
    always @(posedge PCLK or posedge Reset_p)
        if (Reset_p) Vcount <= 0;
        else if (r_Vsync) Vcount <= 0;
        else if ({r_Href, Href} == 2'b01)  // Href下降沿
            Vcount <= Vcount + 1'd1;
        else Vcount <= Vcount;

    // 輸出Y地址
    assign Yaddr = Vcount;
    // 輸出X地址，一行N像素使用RGB565需要2N個數據，所以Hcount值除2等於X地址
    assign Xaddr = Hcount[12:1];

    /*以下非必要*/
    // 前10幀計數
    always @(posedge PCLK or posedge Reset_p)
        if (Reset_p) FrameCnt <= 0;
        else if ({r_Vsync, Vsync} == 2'b01)  // Vsync下降沿
            if (FrameCnt >= 10) FrameCnt <= 4'd10;
            else FrameCnt <= FrameCnt + 1'd1;
        else FrameCnt <= FrameCnt;

    // 捨棄前10幀
    always @(posedge PCLK or posedge Reset_p)
        if (Reset_p) dump_frame <= 0;
        else if (FrameCnt >= 10) dump_frame <= 1'd1;
        else dump_frame <= 0;

    assign DataPixel = r_DataPixel;
    assign DataValid = r_DataValid & dump_frame;
    assign DataHS    = r_DataHS & dump_frame;
    assign DataVS    = r_DataVS & dump_frame;
endmodule

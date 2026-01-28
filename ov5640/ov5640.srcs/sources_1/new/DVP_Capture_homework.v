module DVP_Capture (
    input       Reset_p,
    input       PCLK,
    input       Vsync,
    input       Href,
    input [7:0] Data,

    output reg        ImageState,
    output            DataValid,
    output     [15:0] DataPixel,
    output            DataHS,
    output            DataVS,
    output     [11:0] Xaddr,
    output     [11:0] Yaddr
);
    reg [28:0] hcount;
    reg [15:0] DataTemp;
    always @(posedge PCLK or posedge Reset_p)
        if (Reset_p) hcount <= 0;
        else if (hcount[0]) DataPixel[7:0] <= Data;
        else DataPixel[15:8] <= Data;

    always @(posedge PCLK or posedge Reset_p)
        if (Reset_p) hcount <= 0;
        else if (Href) hcount <= hcount + 1'd1;
        else hcount <= 0;

    always @(posedge PCLK)
        if (Reset_p) ImageState <= 1'd0;
        else if (Vsync) ImageState <= 1'd1;

endmodule

`include "disp_parameter_cfg.v"
module TFT_CTRL_TEST (
        Clk,
        Reset_p,
        TFT_HS,
        TFT_VS,
        TFT_BL,
        TFT_CLK,
        TFT_DATA
    );
    input Clk;
    input Reset_p;
    output TFT_HS;
    output TFT_VS;
    output TFT_BL;
    output TFT_CLK;
    output [23:0]TFT_DATA;

    reg [23:0]Data;
    wire [11:0]h_addr;
    wire [11:0]v_addr;

    clk_div clk_div_inst0(
                .clk_out1(Clk_TFT),
                .reset(Reset_p),
                .clk_in1(Clk)// 125M
            );

    TFT_CTRL TFT_CTRL_inst0 (
                 .CLK(Clk_TFT),
                 .Reset_p(Reset_p),
                 .Data_in(Data),
                 .hcount(h_addr),
                 .vcount(v_addr),
                 .TFT_HS(TFT_HS),
                 .TFT_VS(TFT_VS),
                 .TFT_DE(TFT_DE),
                 .TFT_CLK(TFT_CLK),
                 .TFT_DATA(TFT_DATA),
                 .TFT_BL(TFT_BL)
             );
    localparam  BLACK = 24'h000000
                ,RED = 24'hFF0000
                ,GREEN = 24'h00FF00
                ,BLUE = 24'h0000FF
                ,YELLOW = 24'hFFFF00
                ,AQUA = 24'h00FFFF
                ,PINK = 24'hFF00FF
                ,WHITE = 24'hFFFFFF
                ;
    // 間隔切換畫面
    // reg [31:0]cnt;
    // parameter MCNT = `TFT_CLK*2-1;// 2s
    // parameter MCNT_EN = `TFT_CLK-1;// 1s
    // always@(posedge Clk_TFT or posedge Reset_p)
    //     if(Reset_p)
    //         cnt<=0;
    //     else if(cnt==MCNT)
    //         cnt<=0;
    //     else
    //         cnt<=cnt+1'd1;
    // reg en;
    // always@(posedge Clk_TFT or posedge Reset_p)
    //     if(Reset_p)
    // en<=1;
    // else if(cnt>=MCNT_EN)
    //     en<=1;
    // else
    //     en<=1;

    // 2x4
    //         col0  col_1
    // row_0   B0     B1
    // row_1   B2     B3
    // row_2   B4     B5
    // row_3   B6     B7
    wire col_0 = (h_addr>=0)&&(h_addr<`H_DATA/2);
    wire col_1 = (h_addr>=`H_DATA/2)&&(h_addr<`H_DATA);
    wire row_0 = (v_addr>=0)&&(v_addr<`V_DATA/4);
    wire row_1 = (v_addr>=`V_DATA/4)&&(v_addr<`V_DATA/2);
    wire row_2 = (v_addr>=`V_DATA/2)&&(v_addr<`V_DATA/4*3);
    wire row_3 = (v_addr>=`V_DATA/4*3)&&(v_addr<`V_DATA);

    wire block_0 = (col_0)&&(row_0);
    wire block_1 = (col_1)&&(row_0);
    wire block_2 = (col_0)&&(row_1);
    wire block_3 = (col_1)&&(row_1);
    wire block_4 = (col_0)&&(row_2);
    wire block_5 = (col_1)&&(row_2);
    wire block_6 = (col_0)&&(row_3);
    wire block_7 = (col_1)&&(row_3);

    always@(*)
        // if(en)
    case ({
                  block_7,
                  block_6,
                  block_5,
                  block_4,
                  block_3,
                  block_2,
                  block_1,
                  block_0
              })
        8'b0000_0001:
            Data=WHITE;
        8'b0000_0010:
            Data=GREEN;
        8'b0000_0100:
            Data=WHITE;
        8'b0000_1000:
            Data=GREEN;
        8'b0001_0000:
            Data=WHITE;
        8'b0010_0000:
            Data=GREEN;
        8'b0100_0000:
            Data=WHITE;
        8'b1000_0000:
            Data=WHITE;
        default:
            Data=BLACK;
    endcase
endmodule

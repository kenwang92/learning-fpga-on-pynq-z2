// 會閃爍
`include "disp_parameter_cfg.v"
module vga_to_hdmi_onboard (
        Clk,
        Reset_p,
        hdmi_clk_n,
        hdmi_clk_p,
        hdmi_tx_n,
        hdmi_tx_p
    );
    input Clk;
    input Reset_p;
    output hdmi_clk_n;
    output hdmi_clk_p;
    output [2:0]hdmi_tx_n;
    output [2:0]hdmi_tx_p;

    wire [11:0]h_addr;
    wire [11:0]v_addr;

    reg [23:0]Data;
    wire Clk_DISP;
    wire Clk_DISPx5;
    wire locked;
    wire DISP_HS;
    wire DISP_VS;
    wire DISP_DE;
    wire DISP_CLK;
    wire [`Red-1:0]disp_red;
    wire [`Green-1:0]disp_green;
    wire [`Blue-1:0]disp_blue;
    clk_div clk_div_inst0(
                .clk_out1(Clk_DISP),
                .clk_out2(Clk_DISPx5),
                .clk_in1(Clk),// 125M
                .locked(locked),
                .reset(Reset_p)
            );
    vga_to_hdmi vga_to_hdmi_inst0 (
                    .pix_clk(Clk_DISP),                // input wire pix_clk
                    .pix_clkx5(Clk_DISPx5),            // input wire pix_clkx5
                    .pix_clk_locked(locked),  // input wire pix_clk_locked
                    .rst(Reset_p),                        // input wire rst
                    .red(disp_red),                        // input wire [7 : 0] red
                    .green(disp_green),                    // input wire [7 : 0] green
                    .blue(disp_blue),                      // input wire [7 : 0] blue
                    .hsync(DISP_HS),                    // input wire hsync
                    .vsync(DISP_VS),                    // input wire vsync
                    .vde(DISP_DE),                        // input wire vde
                    .TMDS_CLK_P(hdmi_clk_p),          // output wire TMDS_CLK_P
                    .TMDS_CLK_N(hdmi_clk_n),          // output wire TMDS_CLK_N
                    .TMDS_DATA_P(hdmi_tx_p),        // output wire [2 : 0] TMDS_DATA_P
                    .TMDS_DATA_N(hdmi_tx_n)        // output wire [2 : 0] TMDS_DATA_N
                );
    disp_driver disp_driver_inst0(
                    .CLK_DISP(Clk_DISP),
                    .Reset_p(Reset_p),
                    .Data(Data),
                    .h_addr(h_addr),
                    .v_addr(v_addr),
                    .DISP_HS(DISP_HS),
                    .DISP_VS(DISP_VS),
                    .DISP_DE(DISP_DE),
                    .DISP_CLK(DISP_CLK),
                    .disp_red(disp_red),
                    .disp_green(disp_green),
                    .disp_blue(disp_blue)
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
    reg [31:0]cnt;
    parameter MCNT = `DISP_CLK*2-1;// 2s
    parameter MCNT_EN = `DISP_CLK-1;// 1s
    always@(posedge Clk_DISP or posedge Reset_p)
        if(Reset_p)
            cnt<=0;
        else if(cnt==MCNT)
            cnt<=0;
        else
            cnt<=cnt+1'd1;
    reg en;
    always@(posedge Clk_DISP or posedge Reset_p)
        if(Reset_p)
            en<=0;
    // else if(cnt>=MCNT_EN)
    //     en<=1;
        else
            en<=0;

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
    // 4x2
    //        vcol_0 vcol_1 vcol_2 vcol_3
    // vrow_0  VB0    VB1    VB2    VB3
    // vrow_1  VB4    VB5    VB6    VB7
    wire vcol_0 = (h_addr>=0)&&(h_addr<`H_DATA/4);
    wire vcol_1 = (h_addr>=`H_DATA/4)&&(h_addr<`H_DATA/2);
    wire vcol_2 = (h_addr>=`H_DATA/2)&&(h_addr<`H_DATA/4*3);
    wire vcol_3 = (h_addr>=`H_DATA/4*3)&&(h_addr<`H_DATA);
    wire vrow_0 = (v_addr>=0)&&(v_addr<`V_DATA/2);
    wire vrow_1 = (v_addr>=`V_DATA/2)&&(v_addr<`V_DATA);

    wire vblock_0 = (vcol_0)&&(vrow_0);
    wire vblock_1 = (vcol_1)&&(vrow_0);
    wire vblock_2 = (vcol_2)&&(vrow_0);
    wire vblock_3 = (vcol_3)&&(vrow_0);
    wire vblock_4 = (vcol_0)&&(vrow_1);
    wire vblock_5 = (vcol_1)&&(vrow_1);
    wire vblock_6 = (vcol_2)&&(vrow_1);
    wire vblock_7 = (vcol_3)&&(vrow_1);

    always@(*)
        if(en)
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
                Data=PINK;
            8'b0000_0010:
                Data=YELLOW;
            8'b0000_0100:
                Data=BLACK;
            8'b0000_1000:
                Data=RED;
            8'b0001_0000:
                Data=GREEN;
            8'b0010_0000:
                Data=BLUE;
            8'b0100_0000:
                Data=AQUA;
            8'b1000_0000:
                Data=WHITE;
        endcase
        else if(~en)
        case ({
                      vblock_7,
                      vblock_6,
                      vblock_5,
                      vblock_4,
                      vblock_3,
                      vblock_2,
                      vblock_1,
                      vblock_0
                  })
            8'b0000_0001:
                Data=PINK;
            8'b0000_0010:
                Data=YELLOW;
            8'b0000_0100:
                Data=BLACK;
            8'b0000_1000:
                Data=RED;
            8'b0001_0000:
                Data=GREEN;
            8'b0010_0000:
                Data=BLUE;
            8'b0100_0000:
                Data=AQUA;
            8'b1000_0000:
                Data=WHITE;
        endcase
endmodule

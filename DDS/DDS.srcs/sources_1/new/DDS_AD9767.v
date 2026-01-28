`define sim
module DDS_AD9767 (
        Clk,
        Reset_p,
        DataA,
        ClkA,
        WRTA,
        DataB,
        ClkB,
        WRTB
    );
    input Clk;
    input Reset_p;
    output [13:0]DataA;
    output ClkA;
    output WRTA;
    output [13:0]DataB;
    output ClkB;
    output WRTB;

    wire CLK125M = Clk;// 可用Clock wizard組件轉換頻率
    assign ClkA = CLK125M;
    assign ClkB = CLK125M;
    assign WRTA = ClkA;
    assign WRTB = ClkB;

    reg [31:0]FwordA,FwordB;
    reg [11:0]PwordA,PwordB;
    reg [1:0]Mode_SelA;
    reg [1:0]Mode_SelB;
    reg [2:0]CHA_Fword_Sel;
    reg [2:0]CHB_Fword_Sel;
    reg [2:0]CHA_Pword_Sel;
    reg [2:0]CHB_Pword_Sel;

    DDS_Module_homework DDS_Module_instA (
                            .Clk(CLK125M),
                            .Reset_p(Reset_p),
                            .Mode_Sel(Mode_SelA),
                            .Fword(FwordA),
                            .Pword(PwordA),
                            .Data(DataA)
                        );
    DDS_Module_homework DDS_Module_instB (
                            .Clk(CLK125M),
                            .Reset_p(Reset_p),
                            .Mode_Sel(Mode_SelB),
                            .Fword(FwordB),
                            .Pword(PwordB),
                            .Data(DataB)
                        );
    // vio輸入
    wire CHA_Fword_flag;
    wire CHB_Fword_flag;
    wire CHA_Pword_flag;
    wire CHB_Pword_flag;
    wire Mode_SelA_flag;
    wire Mode_SelB_flag;

    vio_0 vio_inst_0 (
              .clk(CLK125M),                // input wire clk
              .probe_out0(CHA_Fword_flag),  // output wire [0 : 0] probe_out0
              .probe_out1(CHB_Fword_flag),  // output wire [0 : 0] probe_out1
              .probe_out2(CHA_Pword_flag),  // output wire [0 : 0] probe_out2
              .probe_out3(CHB_Pword_flag),  // output wire [0 : 0] probe_out3
              .probe_out4(Mode_SelA_flag),  // output wire [0 : 0] probe_out4
              .probe_out5(Mode_SelB_flag)  // output wire [0 : 0] probe_out5
          );
    // vio輸入訊號打兩拍
    reg CHA_Fword_flag_reg0,CHA_Fword_flag_reg1;
    reg CHB_Fword_flag_reg0,CHB_Fword_flag_reg1;
    reg CHA_Pword_flag_reg0,CHA_Pword_flag_reg1;
    reg CHB_Pword_flag_reg0,CHB_Pword_flag_reg1;
    reg Mode_SelA_flag_reg0,Mode_SelA_flag_reg1;
    reg Mode_SelB_flag_reg0,Mode_SelB_flag_reg1;

    // CHA_Fword_flag打兩拍
    always@(posedge CLK125M or posedge Reset_p)
        if(Reset_p)
            CHA_Fword_flag_reg0<=0;
        else
            CHA_Fword_flag_reg0<=CHA_Fword_flag;

    always@(posedge CLK125M or posedge Reset_p)
        if(Reset_p)
            CHA_Fword_flag_reg1<=0;
        else
            CHA_Fword_flag_reg1<=CHA_Fword_flag_reg0;
    // CHB_Fword_flag打兩拍
    always@(posedge CLK125M or posedge Reset_p)
        if(Reset_p)
            CHB_Fword_flag_reg0<=0;
        else
            CHB_Fword_flag_reg0<=CHB_Fword_flag;

    always@(posedge CLK125M or posedge Reset_p)
        if(Reset_p)
            CHB_Fword_flag_reg1<=0;
        else
            CHB_Fword_flag_reg1<=CHB_Fword_flag_reg0;
    // CHA_Pword_flag打兩拍
    always@(posedge CLK125M or posedge Reset_p)
        if(Reset_p)
            CHA_Pword_flag_reg0<=0;
        else
            CHA_Pword_flag_reg0<=CHA_Pword_flag;

    always@(posedge CLK125M or posedge Reset_p)
        if(Reset_p)
            CHA_Pword_flag_reg1<=0;
        else
            CHA_Pword_flag_reg1<=CHA_Pword_flag_reg0;
    // CHB_Pword_flag打兩拍
    always@(posedge CLK125M or posedge Reset_p)
        if(Reset_p)
            CHB_Pword_flag_reg0<=0;
        else
            CHB_Pword_flag_reg0<=CHB_Pword_flag;

    always@(posedge CLK125M or posedge Reset_p)
        if(Reset_p)
            CHB_Pword_flag_reg1<=0;
        else
            CHB_Pword_flag_reg1<=CHB_Pword_flag_reg0;
    // Mode_SelA_flag打兩拍
    always@(posedge CLK125M or posedge Reset_p)
        if(Reset_p)
            Mode_SelA_flag_reg0<=0;
        else
            Mode_SelA_flag_reg0<=Mode_SelA_flag;

    always@(posedge CLK125M or posedge Reset_p)
        if(Reset_p)
            Mode_SelA_flag_reg1<=0;
        else
            Mode_SelA_flag_reg1<=Mode_SelA_flag_reg0;
    // Mode_SelB_flag打兩拍
    always@(posedge CLK125M or posedge Reset_p)
        if(Reset_p)
            Mode_SelB_flag_reg0<=0;
        else
            Mode_SelB_flag_reg0<=Mode_SelB_flag;

    always@(posedge CLK125M or posedge Reset_p)
        if(Reset_p)
            Mode_SelB_flag_reg1<=0;
        else
            Mode_SelB_flag_reg1<=Mode_SelB_flag_reg0;
    // vio訊號上升沿檢測
    wire CHA_Fword_posedge;
    wire CHB_Fword_posedge;
    wire CHA_Pword_posedge;
    wire CHB_Pword_posedge;
    wire Mode_SelA_posedge;
    wire Mode_SelB_posedge;

    assign CHA_Fword_posedge=(!CHA_Fword_flag_reg1)&(CHA_Fword_flag_reg0);
    assign CHB_Fword_posedge=(!CHB_Fword_flag_reg1)&(CHB_Fword_flag_reg0);
    assign CHA_Pword_posedge=(!CHA_Pword_flag_reg1)&(CHA_Pword_flag_reg0);
    assign CHB_Pword_posedge=(!CHB_Pword_flag_reg1)&(CHB_Pword_flag_reg0);
    assign Mode_SelA_posedge=(!Mode_SelA_flag_reg1)&(Mode_SelA_flag_reg0);
    assign Mode_SelB_posedge=(!Mode_SelB_flag_reg1)&(Mode_SelB_flag_reg0);
    // 每次vio訊號上升沿，選擇器+1
    always@(posedge CLK125M or posedge Reset_p)
        if(Reset_p)
`ifdef sim

            CHA_Fword_Sel<=4;
`else
            CHA_Fword_Sel<=0;
`endif

        else if(CHA_Fword_posedge)
            CHA_Fword_Sel<=CHA_Fword_Sel+1'b1;
        else
            CHA_Fword_Sel<=CHA_Fword_Sel;

    always@(posedge CLK125M or posedge Reset_p)
        if(Reset_p)
`ifdef sim

            CHB_Fword_Sel<=5;
`else
            CHB_Fword_Sel<=0;
`endif

        else if(CHB_Fword_posedge)
            CHB_Fword_Sel<=CHB_Fword_Sel+1'b1;
        else
            CHB_Fword_Sel<=CHB_Fword_Sel;


    always@(posedge CLK125M or posedge Reset_p)
        if(Reset_p)
`ifdef sim

            CHA_Pword_Sel<=0;
`else
            CHA_Pword_Sel<=0;
`endif

        else if(CHA_Pword_posedge)
            CHA_Pword_Sel<=CHA_Pword_Sel+1'b1;
        else
            CHA_Pword_Sel<=CHA_Pword_Sel;

    always@(posedge CLK125M or posedge Reset_p)
        if(Reset_p)
            CHB_Pword_Sel<=0;
        else if(CHB_Pword_posedge)
            CHB_Pword_Sel<=CHB_Pword_Sel+1'b1;
        else
            CHB_Pword_Sel<=CHB_Pword_Sel;

    // 選擇A波形類型
    always@(posedge CLK125M or posedge Reset_p)
        if(Reset_p)
            Mode_SelA<=0;
        else if(Mode_SelA_posedge)
            Mode_SelA<=Mode_SelA+1'b1;
        else
            Mode_SelA<=Mode_SelA;
    // 選擇B波形類型
    always@(posedge CLK125M or posedge Reset_p)
        if(Reset_p)
`ifdef sim

            Mode_SelB<=0;
`else
            Mode_SelB<=0;
`endif

        else if(Mode_SelB_posedge)
            Mode_SelB<=Mode_SelB+1'b1;
        else
            Mode_SelB<=Mode_SelB;
    always@(*)
    case (CHA_Fword_Sel)
        0:
            FwordA=34;// 2^32/125M
        1:
            FwordA=344;
        2:
            FwordA=3436;
        3:
            FwordA=34360;
        4:
            FwordA=343597;
        5:
            FwordA=3435974;
        6:
            FwordA=34359738;
        7:
            FwordA=343597384;
    endcase
    always@(*)
    case (CHB_Fword_Sel)
        0:
            FwordB=34;
        1:
            FwordB=344;
        2:
            FwordB=3436;
        3:
            FwordB=34360;
        4:
            FwordB=343597;
        5:
            FwordB=3435974;
        6:
            FwordB=34359738;
        7:
            FwordB=343597384;
    endcase
    always@(*)
    case (CHA_Pword_Sel)
        0:
            PwordA=0;// 0
        1:
            PwordA=341;// 4096/360*30 30度
        2:
            PwordA=683;// 60
        3:
            PwordA=1024;// 90
        4:
            PwordA=1707;// 150
        5:
            PwordA=2048;// 180
        6:
            PwordA=3072;// 270
        7:
            PwordA=3641;// 320
    endcase
    always@(*)
    case (CHB_Pword_Sel)
        0:
            PwordB=0;// 0
        1:
            PwordB=341;// 30
        2:
            PwordB=683;// 60
        3:
            PwordB=1024;// 90
        4:
            PwordB=1707;// 150
        5:
            PwordB=2048;// 180
        6:
            PwordB=3072;// 270
        7:
            PwordB=3641;// 320
    endcase
endmodule

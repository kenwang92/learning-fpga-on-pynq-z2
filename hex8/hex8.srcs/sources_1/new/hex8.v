module hex8 (
        Clk,
        Reset_p,
        Disp_Data,
        SEL,
        SEG
    );
    input Clk;
    input Reset_p;
    input [31:0]Disp_Data;
    // output reg [3:0]SEL;
    output reg [7:0]SEL;
    output reg [7:0]SEG;

    reg [16:0]div_cnt;
    reg [3:0]data_temp;
    parameter TIME_UNIT_MS = 1000;
    localparam MCNT = 125*TIME_UNIT_MS-1;
    // 1ms
    always @(posedge Clk or posedge Reset_p)
        if(Reset_p)
            div_cnt<=0;
        else if(div_cnt==MCNT)
            div_cnt<=0;
        else
            div_cnt<=div_cnt+1'd1;

    reg [2:0]cnt_sel;
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            cnt_sel<=0;
        else if(div_cnt==MCNT)
            // if(cnt_sel==3)
            //     cnt_sel<=0;
            // else
            cnt_sel<=cnt_sel+1'd1;

    always @(posedge Clk)
    case(cnt_sel)
        0:
            SEL<=8'b1111_1110;
        1:
            SEL<=8'b1111_1101;
        2:
            SEL<=8'b1111_1011;
        3:
            SEL<=8'b1111_0111;
        4:
            SEL<=8'b1110_1111;
        5:
            SEL<=8'b1101_1111;
        6:
            SEL<=8'b1011_1111;
        7:
            SEL<=8'b0111_1111;
    endcase
    always@(*)
    case (cnt_sel)
        0:
            data_temp<=Disp_Data[3:0];
        1:
            data_temp<=Disp_Data[7:4];
        2:
            data_temp<=Disp_Data[11:8];
        3:
            data_temp<=Disp_Data[15:12];
        4:
            data_temp<=Disp_Data[19:16];
        5:
            data_temp<=Disp_Data[23:20];
        6:
            data_temp<=Disp_Data[27:24];
        7:
            data_temp<=Disp_Data[31:28];
    endcase
    // LUT
    always@(posedge Clk)
        if(Reset_p)
            SEG<=0;
        else
        case (data_temp)
            0:
                SEG<=8'b0011_1111;
            1:
                SEG<=8'b0000_0110;
            2:
                SEG<=8'b0101_1011;
            3:
                SEG<=8'b0100_1111;
            4:
                SEG<=8'b0110_0110;
            5:
                SEG<=8'b0110_1101;
            6:
                SEG<=8'b0111_1101;
            7:
                SEG<=8'b0000_0111;
            8:
                SEG<=8'b0111_1111;
            9:
                SEG<=8'b0110_1111;
            10:
                SEG<= 8'b0111_0111;
            11:
                SEG<= 8'b0111_1100;
            12:
                SEG<= 8'b0011_1001;
            13:
                SEG<= 8'b0101_1110;
            14:
                SEG<= 8'b0111_1001;
            15:
                SEG<= 8'b0111_0001;
        endcase

endmodule

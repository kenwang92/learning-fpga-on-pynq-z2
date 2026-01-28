module hex8_homework (
        Clk,
        Reset_p,
        Disp_Data,
        SEL,
        SEG
    );
    input Clk;
    input Reset_p;
    input [31:0]Disp_Data;
    output [7:0]SEL;
    output reg [7:0]SEG;

    // parameter TIME_UNIT_MS = 1000;
    // reg [16:0]cnt;
    // localparam MCNT = 125*TIME_UNIT_MS-1;
    reg [19:0]cnt;
    localparam MCNT = 16*16-1;
    // 1ms
    always @(posedge Clk or posedge Reset_p)
        if(Reset_p)
            cnt<=0;
        else if(cnt==MCNT)
            cnt<=0;
        else
            cnt<=cnt+1'd1;

    reg [2:0]sel;
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            sel<=0;
        else if(cnt==MCNT)
                sel<=sel+1'd1;
    decoder_3_8 decoder_3_8_inst0(
                    .A0(sel[0]),
                    .A1(sel[1]),
                    .A2(sel[2]),
                    .Y0(SEL[0]),
                    .Y1(SEL[1]),
                    .Y2(SEL[2]),
                    .Y3(SEL[3]),
                    .Y4(SEL[4]),
                    .Y5(SEL[5]),
                    .Y6(SEL[6]),
                    .Y7(SEL[7])
                );
    reg [3:0]data_temp;
    always@(*)
    // always@(posedge Clk or posedge Reset_p)
        // if(Reset_p)
        //     data_temp<=0;
        // else if(cnt==MCNT)
        case (sel)
            3'b000:
                data_temp<=Disp_Data[3:0];
            3'b001:
                data_temp<=Disp_Data[7:4];
            3'b010:
                data_temp<=Disp_Data[11:8];
            3'b011:
                data_temp<=Disp_Data[15:12];
            3'b100:
                data_temp<=Disp_Data[19:16];
            3'b101:
                data_temp<=Disp_Data[23:20];
            3'b110:
                data_temp<=Disp_Data[27:24];
            3'b111:
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

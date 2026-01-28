module hex8_hc595_test (
        Clk,
        Reset_p,
        SW,
        SEL,
        SEG
        // DIO,
        // SRCLK,
        // RCLK
    );
    input Clk;
    input Reset_p;
    input [1:0]SW;
    // output [3:0]SEL;
    output [7:0]SEL;
    output [7:0]SEG;
    // output DIO;
    // output SRCLK;
    // output RCLK;

    // wire [7:0]SEL,SEG;
    reg [31:0]Disp_Data;

    hex8 hex8_inst0(
             .Clk(Clk),
             .Reset_p(Reset_p),
             .SEL(SEL),
             .SEG(SEG),
             .Disp_Data(Disp_Data)
         );

    // hc595_driver_example hc595_driver_example_inst0(
    //                          .Clk(Clk),
    //                          .Reset_p(Reset_p),
    //                          .SEL(SEL),
    //                          .SEG(SEG),
    //                          .DIO(DIO),
    //                          .SRCLK(SRCLK),
    //                          .RCLK(RCLK)
    //                      );
    always@(*)
    case (SW)
        0:
            Disp_Data<=32'h0123_4567;
        1:
            Disp_Data<=32'h89ab_cdef;
        2:
            Disp_Data<=32'h0246_8ace;
        3:
            Disp_Data<=32'h1357_9bdf;
    endcase


endmodule

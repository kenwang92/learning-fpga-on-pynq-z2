`timescale 1ns / 1ns
module DVP_Capture_tb;

    // Parameters

    //Ports
    reg         Reset_p;
    reg         PCLK;
    reg         Vsync;
    reg         Href;
    reg  [ 7:0] Data;
    wire        ImageState;
    wire        DataValid;
    wire [15:0] DataPixel;
    wire        DataHS;
    wire        DataVS;
    wire [11:0] Xaddr;
    wire [11:0] Yaddr;

    DVP_Capture DVP_Capture_inst0 (
        .Reset_p   (Reset_p),
        .PCLK      (PCLK),
        .Vsync     (Vsync),
        .Href      (Href),
        .Data      (Data),
        .ImageState(ImageState),
        .DataValid (DataValid),
        .DataPixel (DataPixel),
        .DataHS    (DataHS),
        .DataVS    (DataVS),
        .Xaddr     (Xaddr),
        .Yaddr     (Yaddr)
    );
    initial PCLK = 1;
    always #40 PCLK = ~PCLK;


    parameter WIDTH = 16;
    parameter HEIGHT = 12;
    integer i, j;

    initial begin
        Reset_p = 1;
        Vsync   = 0;
        Href    = 0;
        Data    = 8'h00;
        #805;
        Reset_p = 0;
        #400;
        repeat (15) begin
            Vsync = 1;
            #320;
            Vsync = 0;
            #800;
            for (i = 0; i < HEIGHT; i = i + 1) begin
                for (j = 0; j < WIDTH; j = j + 1) begin
                    Href = 1;
                    Data = Data - 1;
                    #80;
                end
                Href = 0;
                #800;
            end
        end
        $stop;
    end

endmodule

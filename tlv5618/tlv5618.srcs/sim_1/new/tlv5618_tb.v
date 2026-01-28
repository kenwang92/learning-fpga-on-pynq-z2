`timescale 1ns/1ns
module tlv5618_tb();
    reg Clk;
    reg Reset_p;
    reg [15:0]DAC_DATA;
    reg Set_Go;

    wire DIN;
    wire SCLK;
    wire CS_N;
    wire Set_Done;
    tlv5618_driver_homework tlv5618_inst0(
                                .Clk(Clk),
                                .Reset_p(Reset_p),
                                .CS_N(CS_N),
                                .SCLK(SCLK),
                                .DIN(DIN),
                                .DAC_DATA(DAC_DATA),
                                .Set_Go(Set_Go),
                                .Set_Done(Set_Done)
                            );
    initial
        Clk=1;
    always #4 Clk=~Clk;

    initial begin
        Reset_p=1;
        Set_Go=1'd0;
        DAC_DATA=0;
        #201;
        Reset_p=0;
        #200;

        DAC_DATA=16'hC_AAA;
        Set_Go=1;
        #8;
        Set_Go=0;
        #200;
        wait(Set_Done);
        #20001;

        DAC_DATA=16'h4_555;
        Set_Go=1;
        #8;
        Set_Go=0;
        #200;
        wait(Set_Done);
        #20001;

        $stop;
    end

endmodule

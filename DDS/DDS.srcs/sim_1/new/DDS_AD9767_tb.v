`timescale 1ns / 1ps
module DDS_AD9767_tb();
    reg Clk;
    reg Reset_p;
    wire [13:0]DataA;
    wire ClkA;
    wire WRTA;
    wire [13:0]DataB;
    wire ClkB;
    wire WRTB;

    DDS_AD9767 DDS_AD9767_inst0(
                   .Clk(Clk),
                   .Reset_p(Reset_p),
                   .DataA(DataA),
                   .ClkA(ClkA),
                   .WRTA(WRTA),
                   .DataB(DataB),
                   .ClkB(ClkB),
                   .WRTB(WRTB)
               );
    initial
        Clk=1;
    always #4 Clk=~Clk;
    // Fout=125M/((2^32)/343597)+0=10000Hz=100us
    initial begin
        Reset_p=1;
        #81;
        Reset_p=0;
        #2000000;
        $stop;
    end
endmodule

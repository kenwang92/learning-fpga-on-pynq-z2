`timescale 1ns/1ns
module DDS_tb ();
    reg Clk;
    reg Reset_p;
    reg [1:0]Mode_SelA,Mode_SelB;
    reg [31:0]FwordA,FwordB;
    reg [11:0]PwordA,PwordB;
    wire [13:0]DataA,DataB;
    DDS_Module_homework DDS_Module_inst0 (
                            .Clk(Clk),
                            .Reset_p(Reset_p),
                            .Mode_Sel(Mode_SelA),
                            .Fword(FwordA),
                            .Pword(PwordA),
                            .Data(DataA)
                        );
    DDS_Module_homework DDS_Module_inst1 (
                            .Clk(Clk),
                            .Reset_p(Reset_p),
                            .Mode_Sel(Mode_SelB),
                            .Fword(FwordB),
                            .Pword(PwordB),
                            .Data(DataB)
                        );

    initial
        Clk=1;
    always #4 Clk=~Clk;

    initial begin
        Reset_p=1;
        FwordA=65536;
        PwordA=0;
        FwordB=65536;
        PwordB=1024;// 相位90度
        Mode_SelA=2'b00;
        Mode_SelB=2'b00;
        #81;
        Reset_p=0;

        #5_000_000;
        FwordA=65536*1024;// 每2^26取一次
        FwordB=65536*1024;
        PwordA=0;
        PwordB=2048;// 相位180度
        #1_000_000;
        $stop;
    end

endmodule

module DDS_Module_homework (
        Clk,
        Reset_p,
        Mode_Sel,
        Fword,
        Pword,
        Data
    );
    input Clk;
    input Reset_p;
    input [1:0]Mode_Sel;
    input [31:0]Fword;
    input [11:0]Pword;
    output reg [13:0]Data;

    reg [31:0]Fword_r;
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            Fword_r<=0;
        else
            Fword_r<=Fword;
    reg [11:0]Pword_r;
    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            Pword_r<=0;
        else
            Pword_r<=Pword;

    reg [31:0]Freq_ACC;

    always@(posedge Clk or posedge Reset_p)
        if(Reset_p)
            Freq_ACC<=0;
        else
            Freq_ACC<=Freq_ACC+Fword_r;

    wire [11:0]Rom_Addr;
    assign Rom_Addr=Freq_ACC[31:20]+Pword_r;

    wire [13:0]Data_sine,Data_square,Data_triangular;
    rom_sine rom_sine_inst0 (
                 .clka(Clk),    // input wire clka
                 .addra(Rom_Addr),  // input wire [11 : 0] addra
                 .douta(Data_sine)  // output wire [13 : 0] douta
             );
    rom_square rom_square_inst0 (
                   .clka(Clk),    // input wire clka
                   .addra(Rom_Addr),  // input wire [11 : 0] addra
                   .douta(Data_square)  // output wire [13 : 0] douta
               );
    rom_triangular rom_triangular_inst0 (
                       .clka(Clk),    // input wire clka
                       .addra(Rom_Addr),  // input wire [11 : 0] addra
                       .douta(Data_triangular)  // output wire [13 : 0] douta
                   );

    always@(*)
    case (Mode_Sel)
        0:
            Data=Data_sine;
        1:
            Data=Data_square;
        2:
            Data=Data_triangular;
        3:
            Data=8192;
    endcase
endmodule

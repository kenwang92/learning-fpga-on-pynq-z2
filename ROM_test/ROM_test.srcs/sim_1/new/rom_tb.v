`timescale 1ns / 1ns
module rom_tb();
reg clka;
reg [9:0] addra;
wire [9:0] douta;

rom ROM (
  .clka(clka),    // input wire clka
  .addra(addra),  // input wire [9 : 0] addra
  .douta(douta)  // output wire [9 : 0] douta
);
initial clka=1;
always #4 clka=~clka;

initial begin
    addra = 100;
    #201;
    repeat(3000) begin
        addra = addra + 1'd1;
        #20;
    end
    #2000;
    $stop;
end
endmodule

`timescale 1ns/1ns

module FIFO_tb ();

    reg Clk;
    reg Reset;
    reg [7 : 0] din;
    reg wr_en;
    reg rd_en;
    wire [7 : 0] dout;
    wire full;
    wire almost_full;
    wire wr_ack;
    wire overflow;
    wire empty;
    wire almost_empty;
    wire valid;
    wire underflow;
    wire [7 : 0] data_count;

    bram_sync_fifo bram_sync_fifo_inst0 (
                       .clk(Clk),                    // input wire clk
                       .srst(Reset),                  // input wire srst
                       .din(din),                    // input wire [7 : 0] din
                       .wr_en(wr_en),                // input wire wr_en
                       .rd_en(rd_en),                // input wire rd_en
                       .dout(dout),                  // output wire [7 : 0] dout
                       .full(full),                  // output wire full
                       .almost_full(almost_full),    // output wire almost_full
                       .wr_ack(wr_ack),              // output wire wr_ack
                       .overflow(overflow),          // output wire overflow
                       .empty(empty),                // output wire empty
                       .almost_empty(almost_empty),  // output wire almost_empty
                       .valid(valid),                // output wire valid
                       .underflow(underflow),        // output wire underflow
                       .data_count(data_count)      // output wire [7 : 0] data_count
                   );

    initial
        Clk=1;
    always #4 Clk=~Clk;

    initial begin
        Reset=1'b1;
        wr_en=1'b0;
        rd_en=1'b0;
        din=8'hff;
        #9;
        Reset=1'b0;
        // write
        while (full==1'b0) begin
            @(posedge Clk);
            #1;
            wr_en=1'b1;
            din=din+1'b1;
        end

        // overflow
        din=8'hf0;
        @(posedge Clk);
        #1;
        wr_en=1'b0;
        #800;
        // underflow
        while (empty==1'b0) begin
            @(posedge Clk);
            #1;
            rd_en=1'b1;
            // dout=dout;
        end
        @(posedge Clk);
        #1;
        rd_en=1'b0;
        // Reset
        #80;
        Reset=1'b1;
        #9;
        Reset=1'b0;
        #800;
        $stop;
    end

endmodule

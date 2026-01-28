`timescale 1ns / 1ps

module ASYNC_FIFO_tb();
    reg Reset;
    reg wr_clk;
    reg rd_clk;
    reg [7 : 0] din;
    reg wr_en;
    reg rd_en;
    wire [15 : 0] dout;
    wire full;
    wire almost_full;
    wire wr_ack;
    wire overflow;
    wire empty;
    wire almost_empty;
    wire valid;
    wire underflow;
    wire [7 : 0] rd_data_count;
    wire [8 : 0] wr_data_count;
    wire wr_rst_busy;
    wire rd_rst_busy;
    bram_async_fifo your_instance_name (
                        .rst(Reset),                      // input wire rst
                        .wr_clk(wr_clk),                // input wire wr_clk
                        .rd_clk(rd_clk),                // input wire rd_clk
                        .din(din),                      // input wire [7 : 0] din
                        .wr_en(wr_en),                  // input wire wr_en
                        .rd_en(rd_en),                  // input wire rd_en
                        .dout(dout),                    // output wire [15 : 0] dout
                        .full(full),                    // output wire full
                        .almost_full(almost_full),      // output wire almost_full
                        .wr_ack(wr_ack),                // output wire wr_ack
                        .overflow(overflow),            // output wire overflow
                        .empty(empty),                  // output wire empty
                        .almost_empty(almost_empty),    // output wire almost_empty
                        .valid(valid),                  // output wire valid
                        .underflow(underflow),          // output wire underflow
                        .rd_data_count(rd_data_count),  // output wire [7 : 0] rd_data_count
                        .wr_data_count(wr_data_count),  // output wire [8 : 0] wr_data_count
                        .wr_rst_busy(wr_rst_busy),      // output wire wr_rst_busy
                        .rd_rst_busy(rd_rst_busy)      // output wire rd_rst_busy
                    );
    initial
        wr_clk=1;
    always #4 wr_clk=~wr_clk;
    initial
        rd_clk=1;
    always #2 rd_clk=~rd_clk;
    reg [5:0]cnt;
    always@(posedge rd_clk or posedge Reset)
        if(Reset)
            #1 cnt<=1'b0;
        else if(cnt>=6'd31)
            #1 cnt<=1'b0;
        else if(rd_en)
            #1 cnt<=cnt+1'b1;
    always@(posedge rd_clk or posedge Reset)
        if(Reset)
            #1 rd_en<=1'b0;
        else if(rd_data_count>=9'd31)
            #1 rd_en<=1'b1;
        else if(cnt>=6'd31)
            #1 rd_en<=1'b0;
    initial begin
        Reset=1'b1;
        wr_en=1'b0;
        din=8'hff;
        @(posedge wr_clk);
        @(posedge wr_clk);
        @(posedge wr_clk);
        #1;
        Reset=1'b0;
        @(negedge wr_rst_busy);
        wait(rd_rst_busy==1'b0);
        repeat(257) begin
            @(posedge wr_clk);
            #1;
            wr_en=1'b1;
            din=din+1'b1;
        end

        wr_en=1'b0;
        #1000;
        $stop;
    end
endmodule

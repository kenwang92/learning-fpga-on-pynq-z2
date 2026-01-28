module i2c_control_homework (
    Clk,
    Reset_p,
    write_byte_en,
    read_byte_en,
    addr,
    addr_mode,
    wrdata,
    rddata,
    device_id,
    RW_Done,
    ack,
    i2c_sclk,
    i2c_sdat
);
    input Clk;
    input Reset_p;
    input write_byte_en;
    input read_byte_en;
    input [15:0] addr;
    input [7:0] device_id;
    input [7:0] wrdata;
    output reg [7:0] rddata;
    output i2c_sclk;
    inout i2c_sdat;
    input addr_mode;
    output reg ack;
    output reg RW_Done;


    reg  [ 6:0] state;
    reg  [ 5:0] CMD;
    reg         Go;
    reg  [ 7:0] Tx_DATA;
    wire [ 7:0] Rx_DATA;
    reg  [ 7:0] cnt;
    wire [15:0] reg_addr;
    wire        Trans_Done;
    localparam
        IDLE=1,
        STARTUP_WRITE=       7'b0000010,
        WAIT_WR_DONE=        7'b0000100,
        WAIT_RD_DONE=        7'b0001000,
        WRITE_ONLY=          7'b0010000,
        WRITE_STOP=          7'b0100000,
        READ_NOACK_STOP=     7'b1000000;
    localparam
        WRITE=      6'b000001,
        STARTUP=     6'b000010,
        READ=      6'b000100,
        STOP=     6'b001000,
        ACK=     6'b010000,
        NOACK=    6'b100000;

    i2c_bit_shift_homework i2c_bit_shift (
        .Clk       (Clk),
        .Reset_p   (Reset_p),
        .CMD       (CMD),
        .Tx_DATA   (Tx_DATA),
        .Go        (Go),
        .ack_o     (ack_o),
        .Rx_DATA   (Rx_DATA),
        .Trans_Done(Trans_Done),
        .i2c_sclk  (i2c_sclk),
        .i2c_sdat  (i2c_sdat)
    );
    always @(posedge Clk)
        if (Reset_p) begin
            CMD <= 0;
        end else
            case (state)
                IDLE: begin
                    cnt     <= 0;
                    RW_Done <= 1;
                    ack     <= 0;
                    if (write_byte_en || read_byte_en) begin
                        state <= STARTUP_WRITE;
                    end else state <= IDLE;
                end
                STARTUP_WRITE: begin
                    CMD <= STARTUP | WRITE;
                    if (read_byte_en && cnt == 2) Tx_DATA <= device_id | 8'd1;
                    else Tx_DATA <= device_id;
                    Go <= 1;
                    if (write_byte_en) state <= WAIT_WR_DONE;
                    else if (read_byte_en) state <= WAIT_RD_DONE;
                end
                WAIT_WR_DONE: begin
                    Go <= 0;
                    if (Trans_Done) begin
                        case (cnt)
                            0:       state <= WRITE_ONLY;
                            1:       state <= WRITE_ONLY;
                            2:       state <= WRITE_STOP;
                            3: begin
                                RW_Done <= 1;
                                state   <= IDLE;
                            end
                            default: state <= IDLE;
                        endcase
                        if (cnt == 0) cnt <= addr_mode ? 1 : 2;
                        else cnt <= cnt + 1;
                    end
                end
                WAIT_RD_DONE: begin
                    Go <= 0;
                    if (Trans_Done) begin
                        case (cnt)
                            0:       state <= WRITE_ONLY;
                            1:       state <= WRITE_ONLY;
                            2:       state <= STARTUP_WRITE;
                            3:       state <= READ_NOACK_STOP;
                            4: begin
                                RW_Done <= 1;
                                rddata  <= Rx_DATA;
                                state   <= IDLE;
                            end
                            default: state <= IDLE;
                        endcase
                        if (cnt == 0) cnt <= addr_mode ? 1 : 2;
                        else cnt <= cnt + 1;
                    end
                end
                WRITE_ONLY: begin
                    CMD <= WRITE;
                    if (cnt == 0) Tx_DATA <= reg_addr[15:8];
                    else if (cnt == 1) Tx_DATA <= reg_addr[7:0];
                    Go <= 1;
                    if (write_byte_en) state <= WAIT_WR_DONE;
                    else if (read_byte_en) state <= WAIT_RD_DONE;
                end
                WRITE_STOP: begin
                    CMD     <= WRITE | STOP;
                    Tx_DATA <= wrdata;
                    Go      <= 1;
                    if (write_byte_en) state <= WAIT_WR_DONE;
                    else if (read_byte_en) state <= WAIT_RD_DONE;
                end
                READ_NOACK_STOP: begin
                    CMD <= READ | NOACK | STOP;
                    Go  <= 1;
                    if (write_byte_en) state <= WAIT_WR_DONE;
                    else if (read_byte_en) state <= WAIT_RD_DONE;
                end
                default: state <= IDLE;
            endcase
endmodule

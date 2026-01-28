module i2c_control (
    Clk,
    Reset_p,
    wrreg_req,
    rdreg_req,
    addr,
    addr_mode,
    wrdata,
    rddata,
    device_id,
    RW_Done,
    ack,
    i2c_dly_cnt_max,
    i2c_sclk,
    i2c_sdat
);
    input Clk;
    input Reset_p;
    input wrreg_req;
    input rdreg_req;
    input [15:0] addr;
    input addr_mode;
    input [7:0] wrdata;
    output reg [7:0] rddata;
    input [7:0] device_id;
    output reg RW_Done;
    output reg ack;
    input [31:0] i2c_dly_cnt_max;
    output i2c_sclk;
    inout i2c_sdat;

    reg  [ 5:0] Cmd;
    reg  [ 7:0] Tx_DATA;
    wire        Trans_Done;
    wire        ack_o;
    reg         Go;
    wire [15:0] reg_addr;

    assign reg_addr = addr_mode ? addr : {addr[7:0], addr[15:8]};
    wire [7:0] Rx_DATA;
    localparam
        WR=      6'b000001,
        STA=     6'b000010,
        RD=      6'b000100,
        STO=     6'b001000,
        ACK=     6'b010000,
        NACK=    6'b100000;

    i2c_bit_shift i2c_bit_shift_inst0 (
        .Clk       (Clk),
        .Reset_p   (Reset_p),
        .Cmd       (Cmd),
        .Tx_DATA   (Tx_DATA),
        .Go        (Go),
        .ack_o     (ack_o),
        .Rx_DATA   (Rx_DATA),
        .Trans_Done(Trans_Done),
        .i2c_sclk  (i2c_sclk),
        .i2c_sdat  (i2c_sdat)
    );

    reg [ 6:0] state;
    reg [ 7:0] cnt;

    reg [31:0] i2c_delay_cnt;

    localparam
        IDLE = 8'b00000001,
        WR_REG = 8'b00000010,
        WAIT_WR_DONE = 8'b00000100,
        WR_REG_DONE = 8'b00001000,
        RD_REG = 8'b00010000,
        WAIT_RD_DONE = 8'b00100000,
        RD_REG_DONE = 8'b01000000,
        WAIT_DLY = 8'b10000000;

    always @(posedge Clk or posedge Reset_p)
        if (Reset_p) begin
            Cmd     <= 6'b0;
            Tx_DATA <= 8'd0;
            Go      <= 1'b0;
            rddata  <= 0;
            state   <= IDLE;
            ack     <= 0;
            RW_Done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    cnt     <= 0;
                    ack     <= 0;
                    RW_Done <= 1'b0;
                    if (wrreg_req) state <= WR_REG;
                    else if (rdreg_req) state <= RD_REG;
                    else state <= IDLE;
                end
                WR_REG: begin
                    state <= WAIT_WR_DONE;
                    case (cnt)
                        0:       write_byte(WR | STA, device_id);
                        1:       write_byte(WR, reg_addr[15:8]);
                        2:       write_byte(WR, reg_addr[7:0]);
                        3:       write_byte(WR | STO, wrdata);
                        default: ;
                    endcase
                end
                WAIT_WR_DONE: begin
                    Go <= 0;
                    if (Trans_Done) begin
                        ack <= ack_o | ack;
                        case (cnt)
                            0: begin
                                cnt   <= 1;
                                state <= WR_REG;
                            end
                            1: begin
                                state <= WR_REG;
                                if (addr_mode) cnt <= 2;
                                else cnt <= 3;
                            end
                            2: begin
                                cnt   <= 3;
                                state <= WR_REG;
                            end
                            3:       state <= WR_REG_DONE;
                            default: state <= IDLE;
                        endcase
                    end
                end
                WR_REG_DONE: begin
                    // RW_Done <= 1;
                    // state   <= IDLE;
                    state <= WAIT_DLY;
                end
                RD_REG: begin
                    state <= WAIT_RD_DONE;
                    case (cnt)
                        0:       write_byte(WR | STA, device_id);
                        1:       write_byte(WR, reg_addr[15:8]);
                        2:       write_byte(WR, reg_addr[7:0]);
                        3:       write_byte(WR | STA, device_id | 8'd1);
                        4:       read_byte(RD | NACK | STO);
                        default: ;
                    endcase
                end
                WAIT_RD_DONE: begin
                    Go <= 0;
                    if (Trans_Done) begin
                        if (cnt <= 3) ack <= ack | ack_o;
                        case (cnt)
                            0: begin
                                cnt   <= 1;
                                state <= RD_REG;
                            end
                            1: begin
                                state <= RD_REG;
                                if (addr_mode) cnt <= 2;
                                else cnt <= 3;
                            end
                            2: begin
                                cnt   <= 3;
                                state <= RD_REG;
                            end
                            3: begin
                                cnt   <= 4;
                                state <= RD_REG;
                            end
                            4:       state <= RD_REG_DONE;
                            default: state <= IDLE;
                        endcase
                    end
                end
                RD_REG_DONE: begin
                    // RW_Done <= 1;
                    rddata <= Rx_DATA;
                    state  <= WAIT_DLY;
                end
                WAIT_DLY:
                if (i2c_delay_cnt <= i2c_dly_cnt_max) begin
                    i2c_delay_cnt <= i2c_delay_cnt + 1'b1;
                    state         <= WAIT_DLY;
                end else begin
                    i2c_delay_cnt <= 0;
                    RW_Done       <= 1'b1;
                    state         <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end

    task read_byte;
        input [5:0] Ctrl_Cmd;
        begin
            Cmd <= Ctrl_Cmd;
            Go  <= 1'b1;
        end
    endtask

    task write_byte;
        input [5:0] Ctrl_Cmd;
        input [7:0] Wr_Byte_Data;
        begin
            Cmd     <= Ctrl_Cmd;
            Tx_DATA <= Wr_Byte_Data;
            Go      <= 1'b1;
        end
    endtask
endmodule

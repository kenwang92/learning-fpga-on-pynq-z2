module uart (
        Clk,
        Reset_p,
        Led,
        Data,
        Uart_tx
    );
    input [7:0] Data;
    input Clk;
    input Reset_p;

    output reg Led;
    output reg Uart_tx;

    parameter TIME_UNIT_MS = 1000;
    parameter DELAY_MCNT = 125_000;  // 1s counter
    // parameter BAUD_MCNT = 13_021;// (1/9600)s counter
    parameter BAUD_MCNT = 13;  // (1/9600)s counter

    reg [26:0] delay_cnt;  // 1s counter
    reg [15:0] baud_div_cnt;  // (1/9600)s counter
    reg [3:0] data_cnt;  // counter 0-9
    reg [7:0] data_buffer;  // store Data[7:0]
    // 1s
    always @(posedge Clk or posedge Reset_p)
        if (Reset_p)
            delay_cnt <= 0;
        else if (delay_cnt == DELAY_MCNT * TIME_UNIT_MS - 1)
            delay_cnt <= 0;
        else
            delay_cnt <= delay_cnt + 1'd1;
    // (1/9600)s
    always @(posedge Clk or posedge Reset_p)
        if (Reset_p)
            baud_div_cnt <= 0;
        else if((baud_div_cnt==BAUD_MCNT*TIME_UNIT_MS-1)|(delay_cnt==DELAY_MCNT*TIME_UNIT_MS-1))
            baud_div_cnt <= 0;
        else
            baud_div_cnt <= baud_div_cnt + 1'd1;
    // data_cnt for 10bit data
    always @(posedge Clk or posedge Reset_p)
        if (Reset_p)
            data_cnt <= 0;
        else if (delay_cnt == DELAY_MCNT * TIME_UNIT_MS - 1)
            data_cnt <= 0;
        else if (baud_div_cnt == BAUD_MCNT * TIME_UNIT_MS - 1)
            if (data_cnt < 10)
                data_cnt <= data_cnt + 1'd1;
    // Data buffer store Data[7:0] to keep data not change when transfer
    always @(posedge Clk or posedge Reset_p)
        if (Reset_p)
            data_buffer <= 0;
        else if (delay_cnt == DELAY_MCNT * TIME_UNIT_MS - 1)
            data_buffer <= Data;
    always @(posedge Clk or posedge Reset_p)
        if (Reset_p)
            Led <= 0;
        else if ((data_cnt == 9) & (baud_div_cnt == BAUD_MCNT * TIME_UNIT_MS - 1))
            Led <= ~Led;
    // Send Data
    always @(posedge Clk or posedge Reset_p)
        if (Reset_p)
            Uart_tx <= 1;
        else
        case (data_cnt)
            0:
                Uart_tx <= 0;  // Start
            1:
                Uart_tx <= data_buffer[0];
            2:
                Uart_tx <= data_buffer[1];
            3:
                Uart_tx <= data_buffer[2];
            4:
                Uart_tx <= data_buffer[3];
            5:
                Uart_tx <= data_buffer[4];
            6:
                Uart_tx <= data_buffer[5];
            7:
                Uart_tx <= data_buffer[6];
            8:
                Uart_tx <= data_buffer[7];
            9:
                Uart_tx <= 1;  // Stop
            default:
                Uart_tx <= 1;
        endcase

endmodule

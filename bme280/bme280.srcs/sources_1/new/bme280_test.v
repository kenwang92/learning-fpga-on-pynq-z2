module bme280_test(
        Clk,
        Reset_p,
        SW,
        ADC_SCLK,
        ADC_CS_N,
        ADC_DIN,
        ADC_DOUT,
        Led,
        Key,
        Uart_tx
    );
    input Clk;
    input Reset_p;
    input [1:0]SW;
    input Key;

    output ADC_SCLK;
    output ADC_CS_N;
    output ADC_DIN;
    input ADC_DOUT;
    output reg Led;
    output Uart_tx;

    wire Conv_Done;
    wire Key_P_Flag;
    wire Conv_Go;
    wire [7:0]Data;
    reg [7:0]Addr;
    reg Send_Go;

    bme280_driver bme280_driver_inst0(
                      .Clk(Clk),
                      .Reset_p(Reset_p),
                      .Addr(Addr),
                      .Data(Data),
                      .Conv_Go(Conv_Go),
                      .Conv_Done(Conv_Done),
                      .ADC_CS_N(ADC_CS_N),
                      .ADC_SCLK(ADC_SCLK),
                      .ADC_DIN(ADC_DIN),
                      .ADC_DOUT(ADC_DOUT)
                  );

    key_filter key_filter_inst0(
                   .Clk(Clk),
                   .Reset_p(Reset_p),
                   .Key(Key),
                   .Key_R_Flag(),
                   .Key_P_Flag(Key_P_Flag),
                   .Key_State()
               );

    uart_example uart_inst0(
                     .Data(Data),
                     .Clk(Clk),
                     .Reset_p(Reset_p),
                     .Uart_tx(Uart_tx),
                     .Send_Go(Send_Go),
                     .Tx_Done()
                 );
    assign Conv_Go=Key_P_Flag;
    always@(*)
    case (SW)
        0:
            Addr<=8'hFD;// hum_msb
        1:
            Addr<=8'hFA;// temp_mcb
        2:
            Addr<=8'hF7;// press_msb
        3:
            Addr<=8'hD0;// chip_id
    endcase

    always@(posedge Clk or posedge Reset_p)
        if (Reset_p)
            Led<=0;
        else if(Conv_Done) begin
            Led<=~Led;
            Send_Go<=1'd1;
        end
        else
            Send_Go<=0;


endmodule

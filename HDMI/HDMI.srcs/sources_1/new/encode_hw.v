module encode_hw #(
    parameter CTL0 = 10'b1101010100,
    parameter CTL1 = 10'b0010101011,
    parameter CTL2 = 10'b0101010100,
    parameter CTL3 = 10'b1010101011
) (
    input            Clk,
    input            Reset_p,
    input      [7:0] din,
    input            c0,
    input            c1,
    input            de,
    output reg [9:0] dout
);
    reg [3:0] ones;
    reg [7:0] din_q;
    // 分別統計din前8bit的0和1個數
    // 給1 cycle時間計算多個加法，避免後續做判斷時路徑過長
    always @(posedge Clk) begin
        din_q <= din;  // din打一拍
        ones  <= din[0] + din[1] + din[2] + din[3] + din[4] + din[5] + din[6] + din[7];
    end

    wire [8:0] q_m;
    wire decision1;
    reg  [4:0] cnt;  // 偏移值，例如cnt=+1表示1比0數量多1個，cnt=-1表示0比1數量多1個，最高位是符號位
    /*
        Stage 1編碼目標：減少0、1切換次數
        1的數量多使用xnor編碼
        0的數量多使用xor編碼
        如果數量相同使用最後一位判定
    */
    assign decision1 = (ones > 4'd4) | ((ones == 4'd4) & (din_q[0] == 0));
    assign q_m[0]    = din_q[0];
    assign q_m[1]    = decision1 ? ~(q_m[0] ^ din_q[1]) : (q_m[0] ^ din_q[1]);
    assign q_m[2]    = decision1 ? ~(q_m[1] ^ din_q[2]) : (q_m[1] ^ din_q[2]);
    assign q_m[3]    = decision1 ? ~(q_m[2] ^ din_q[3]) : (q_m[2] ^ din_q[3]);
    assign q_m[4]    = decision1 ? ~(q_m[3] ^ din_q[4]) : (q_m[3] ^ din_q[4]);
    assign q_m[5]    = decision1 ? ~(q_m[4] ^ din_q[5]) : (q_m[4] ^ din_q[5]);
    assign q_m[6]    = decision1 ? ~(q_m[5] ^ din_q[6]) : (q_m[5] ^ din_q[6]);
    assign q_m[7]    = decision1 ? ~(q_m[6] ^ din_q[7]) : (q_m[6] ^ din_q[7]);
    assign q_m[8]    = ~decision1;

    reg [3:0] ones_q_m;
    reg [3:0] zeros_q_m;
    // 統計經過stage1編碼的1和0個數
    always @(posedge Clk) begin
        ones_q_m <= q_m[0] + q_m[1] + q_m[2] + q_m[3] + q_m[4] + q_m[5] + q_m[6] + q_m[7];
        zeros_q_m <= 4'd8 - (q_m[0] + q_m[1] + q_m[2] + q_m[3] + q_m[4] + q_m[5] + q_m[6] + q_m[7]);
    end

    wire decision2, decision3;
    // 判斷是否處於平衡狀態，1和0個數相等或是無偏移
    assign decision2 = (cnt == 0) | (ones_q_m == zeros_q_m);
    /*
        判斷cnt和(個數1-個數0)是否同為正或同為負
        不可寫成「cnt<0」，2補數表示-1為11111，小於0不會成立，需檢查MSB判斷正負
        (如果要寫cnt<0需將參與運算之變數皆改成signed，混合運算默認轉unsigned)
    */
    assign decision3 = (~cnt[4] & (ones_q_m > zeros_q_m)) | (cnt[4] & (zeros_q_m > ones_q_m));

    reg [1:0] de_r;
    reg [1:0] c0_r;
    reg [1:0] c1_r;
    reg [8:0] q_m_r;
    always @(posedge Clk) begin
        /*
            巧妙地打兩拍，把de_r當作移位暫存器，將新的值推入low bit，舊的值推入high bit
            打兩拍原因: stage1計算ones延遲 + stage2的q_m_r、ones_q_m延遲
            EX:
                第一拍：{?, 1}
                第二拍：{1, 0}
                取high bit得到打兩拍結果
        */
        de_r  <= {de_r[0], de};
        c0_r  <= {c0_r[0], c0};
        c1_r  <= {c1_r[0], c1};
        // 只打一拍，stage1已經過1 cycle
        q_m_r <= q_m;
    end

    wire signed weight_q8 = q_m_r[8] ? 2'sd1 : -2'sd1;
    wire signed weight_q9 = dout[9] ? 2'sd1 : -2'sd1;
    wire signed weight_data = ones_q_m - zeros_q_m;
    // Stage 2: DC balance
    always @(posedge Clk or posedge Reset_p) begin
        if (Reset_p) begin
            cnt  <= 0;
            dout <= 0;
        end else begin
            // de為正，發送data signal，反之發送control signal
            if (de_r[1]) begin
                if (decision2) begin
                    dout[9] <= ~q_m_r[8];  // 配合dout[8]達到DC平衡
                    dout[8] <= q_m_r[8];  // 0: XNOR(1多), 1: XOR(0多)
                    dout[7:0] <= q_m_r[8] ? q_m_r[7:0] : ~q_m_r[7:0];
                    cnt <= (~q_m[8]) ? (cnt + (zeros_q_m - ones_q_m)) : (cnt + (ones_q_m - zeros_q_m));
                end else begin
                    // 如果cnt和(個數1-個數0)皆為正或皆為負，避免更大偏移，反轉q_m_r前8bit，使個數差值為負
                    if (decision3) begin
                        dout[9]   <= 1'b1;  // 紀錄是否反轉
                        dout[8]   <= q_m_r[8];  // 紀錄stage1編碼方式
                        dout[7:0] <= ~q_m_r[7:0];
                        /*
                            減weight_data原因：
                            EX:
                                din=1111_1100, ones=6, zeros=2, weight_data=6-2=4
                            inv_din=0000_0011, ones=6(實際是0的數量), zeros=2(實際是1的數量)
                                所以要改成「-weight_data」才是真正的1的個數減去0的個數
                         */
                        cnt       <= cnt + weight_q9 + weight_q8 - weight_data;

                        // 範例優化：將q8和q9權重相加後，只有兩種可能+2或+0，剛好是q_m_r[8]兩倍
                        // cnt       <= cnt + {q_m_r[8], 1'b0} + (zeros_q_m - ones_q_m);
                    end else begin
                        dout[9]   <= 1'b0;
                        dout[8]   <= q_m_r[8];
                        dout[7:0] <= q_m_r[7:0];
                        cnt       <= cnt + weight_q9 + weight_q8 + weight_data;
                    end
                end
            end else begin
                cnt <= 0;
                case ({
                    c1_r[1], c0_r[1]
                })  // 依照c1,c0組成的2bit決定control signal內容
                    2'b00:   dout <= CTL0;
                    2'b01:   dout <= CTL1;
                    2'b10:   dout <= CTL2;
                    default: dout <= CTL3;
                endcase
            end
        end
    end


endmodule

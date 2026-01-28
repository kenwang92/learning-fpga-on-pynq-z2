module decoder_3_8 (
    A0,
    A1,
    A2,
    Y0,
    Y1,
    Y2,
    Y3,
    Y4,
    Y5,
    Y6,
    Y7
  );
  input A0;
  input A1;
  input A2;
  output reg Y0;
  output reg Y1;
  output reg Y2;
  output reg Y3;
  output reg Y4;
  output reg Y5;
  output reg Y6;
  output reg Y7;
  // always 過程
  always@(*)
  case ({A2,A1,A0})
    3'b000:
      {Y7,Y6,Y5,Y4,Y3,Y2,Y1,Y0} =8'b00000001;
    3'b001:
      {Y7,Y6,Y5,Y4,Y3,Y2,Y1,Y0} =8'b00000010;
    3'b010:
      {Y7,Y6,Y5,Y4,Y3,Y2,Y1,Y0} =8'b00000100;
    3'b011:
      {Y7,Y6,Y5,Y4,Y3,Y2,Y1,Y0} =8'b00001000;
    3'd4:
      {Y7,Y6,Y5,Y4,Y3,Y2,Y1,Y0} =8'b00010000;
    3'd5:
      {Y7,Y6,Y5,Y4,Y3,Y2,Y1,Y0} =8'b00100000;
    3'd6:
      {Y7,Y6,Y5,Y4,Y3,Y2,Y1,Y0} =8'b01000000;
    3'd7:
      {Y7,Y6,Y5,Y4,Y3,Y2,Y1,Y0} =8'b10000000;
    default:
      {Y7,Y6,Y5,Y4,Y3,Y2,Y1,Y0} =8'b00000000;
  endcase

endmodule

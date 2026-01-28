module mux2(
    a,
    b,
    sel,
    out
  );
  
  input a;
  input b;
  input sel;
  output out;

  assign out = sel?a:b;
endmodule

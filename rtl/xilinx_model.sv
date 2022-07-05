module BUFG(
  input        I,
  output logic O
);
  assign O = I;
endmodule

module BUFIO(
  input        I,
  output logic O
);
  assign O = I;
endmodule

module BUFR#(
  parameter BUFR_DIVIDE = "GENERIC"
)(
  input        I,
  output logic O,
  input        CE,
  input        CLR
);
  assign O = I;
endmodule

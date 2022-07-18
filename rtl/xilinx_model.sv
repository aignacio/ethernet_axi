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

module IDDR#(
  // target ("SIM", "GENERIC", "XILINX", "ALTERA")
  parameter TARGET = "GENERIC",
  // IODDR style ("IODDR", "IODDR2")
  // Use IODDR for Virtex-4, Virtex-5, Virtex-6, 7 Series, Ultrascale
  // Use IODDR2 for Spartan-6
  parameter IODDR_STYLE = "IODDR2",
  // Width of register in bits
  parameter WIDTH = 1,
  parameter DDR_CLK_EDGE = "SAME_EDGE_PIPELINED",
  parameter SRTYPE = "ASYNC"
)(
  input  wire             C,
  input  wire [WIDTH-1:0] D,
  output wire [WIDTH-1:0] Q1,
  output wire [WIDTH-1:0] Q2,
  input wire              R,
  input wire              S,
  input wire              CE
);
  reg [WIDTH-1:0] d_reg_1 = {WIDTH{1'b0}};
  reg [WIDTH-1:0] d_reg_2 = {WIDTH{1'b0}};

  reg [WIDTH-1:0] q_reg_1 = {WIDTH{1'b0}};
  reg [WIDTH-1:0] q_reg_2 = {WIDTH{1'b0}};

  always @(posedge C) begin
      d_reg_1 <= D;
  end

  always @(negedge C) begin
      d_reg_2 <= D;
  end

  always @(posedge C) begin
      q_reg_1 <= d_reg_1;
      q_reg_2 <= d_reg_2;
  end

  assign Q1 = q_reg_1;
  assign Q2 = q_reg_2;
endmodule

module ODDR#(
  // target ("SIM", "GENERIC", "XILINX", "ALTERA")
  parameter TARGET = "GENERIC",
  // IODDR style ("IODDR", "IODDR2")
  // Use IODDR for Virtex-4, Virtex-5, Virtex-6, 7 Series, Ultrascale
  // Use IODDR2 for Spartan-6
  parameter IODDR_STYLE = "IODDR2",
  // Width of register in bits
  parameter WIDTH = 1,
  parameter DDR_CLK_EDGE = "SAME_EDGE_PIPELINED",
  parameter SRTYPE = "ASYNC"

)(
  input  wire             C,
  input  wire [WIDTH-1:0] D1,
  input  wire [WIDTH-1:0] D2,
  input wire              R,
  input wire              S,
  input wire              CE,
  output wire [WIDTH-1:0] Q
);
  reg [WIDTH-1:0] d_reg_1 = {WIDTH{1'b0}};
  reg [WIDTH-1:0] d_reg_2 = {WIDTH{1'b0}};

  reg [WIDTH-1:0] q_reg = {WIDTH{1'b0}};

  always @(posedge C) begin
    d_reg_1 <= D1;
    d_reg_2 <= D2;
  end

  always @(posedge C) begin
    q_reg <= D1;
  end

  always @(negedge C) begin
    q_reg <= d_reg_2;
  end

  assign Q = q_reg;

endmodule

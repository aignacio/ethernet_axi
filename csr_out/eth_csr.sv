`ifndef rggen_connect_bit_field_if
  `define rggen_connect_bit_field_if(RIF, FIF, LSB, WIDTH) \
  assign  FIF.valid                 = RIF.valid; \
  assign  FIF.read_mask             = RIF.read_mask[LSB+:WIDTH]; \
  assign  FIF.write_mask            = RIF.write_mask[LSB+:WIDTH]; \
  assign  FIF.write_data            = RIF.write_data[LSB+:WIDTH]; \
  assign  RIF.read_data[LSB+:WIDTH] = FIF.read_data; \
  assign  RIF.value[LSB+:WIDTH]     = FIF.value;
`endif
`ifndef rggen_tie_off_unused_signals
  `define rggen_tie_off_unused_signals(WIDTH, VALID_BITS, RIF) \
  if (1) begin : __g_tie_off \
    genvar  __i; \
    for (__i = 0;__i < WIDTH;++__i) begin : g \
      if (!(((VALID_BITS) >> __i) & 1'b1)) begin : g \
        assign  RIF.read_data[__i]  = 1'b0; \
        assign  RIF.value[__i]      = 1'b0; \
      end \
    end \
  end
`endif
module eth_csr
  import rggen_rtl_pkg::*;
#(
  parameter int ADDRESS_WIDTH = 8,
  parameter bit PRE_DECODE = 0,
  parameter bit [ADDRESS_WIDTH-1:0] BASE_ADDRESS = '0,
  parameter bit ERROR_STATUS = 0,
  parameter bit [63:0] DEFAULT_READ_DATA = '0,
  parameter int ID_WIDTH = 0,
  parameter bit WRITE_FIRST = 1
)(
  input logic i_clk,
  input logic i_rst_n,
  rggen_axi4lite_if.slave axi4lite_if,
  output logic [47:0] o_eth_mac,
  output logic [31:0] o_eth_ip,
  output logic [31:0] o_gateway_ip,
  output logic [31:0] o_subnet_mask,
  input logic [47:0] i_recv_mac,
  input logic [31:0] i_recv_ip,
  input logic [15:0] i_recv_udp_length,
  output logic [47:0] o_send_mac,
  output logic [31:0] o_send_ip,
  output logic [15:0] o_send_udp_length,
  output logic o_send_pkt,
  output logic o_clear_irq,
  output logic o_clear_arp
);
  rggen_register_if #(8, 64, 64) register_if[13]();
  rggen_axi4lite_adapter #(
    .ID_WIDTH             (ID_WIDTH),
    .ADDRESS_WIDTH        (ADDRESS_WIDTH),
    .LOCAL_ADDRESS_WIDTH  (8),
    .BUS_WIDTH            (64),
    .REGISTERS            (13),
    .PRE_DECODE           (PRE_DECODE),
    .BASE_ADDRESS         (BASE_ADDRESS),
    .BYTE_SIZE            (256),
    .ERROR_STATUS         (ERROR_STATUS),
    .DEFAULT_READ_DATA    (DEFAULT_READ_DATA),
    .WRITE_FIRST          (WRITE_FIRST)
  ) u_adapter (
    .i_clk        (i_clk),
    .i_rst_n      (i_rst_n),
    .axi4lite_if  (axi4lite_if),
    .register_if  (register_if)
  );
  generate if (1) begin : g_eth_mac
    rggen_bit_field_if #(64) bit_field_if();
    `rggen_tie_off_unused_signals(64, 64'h0000ffffffffffff, bit_field_if)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h00),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk        (i_clk),
      .i_rst_n      (i_rst_n),
      .register_if  (register_if[0]),
      .bit_field_if (bit_field_if)
    );
    if (1) begin : g_eth_mac
      localparam bit [47:0] INITIAL_VALUE = 48'h1dee69def061;
      rggen_bit_field_if #(48) bit_field_sub_if();
      `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 48)
      rggen_bit_field #(
        .WIDTH          (48),
        .INITIAL_VALUE  (INITIAL_VALUE),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .bit_field_if       (bit_field_sub_if),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_sw_write_enable  ('1),
        .i_hw_write_enable  ('0),
        .i_hw_write_data    ('0),
        .i_hw_set           ('0),
        .i_hw_clear         ('0),
        .i_value            ('0),
        .i_mask             ('1),
        .o_value            (o_eth_mac),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_eth_ip
    rggen_bit_field_if #(64) bit_field_if();
    `rggen_tie_off_unused_signals(64, 64'h00000000ffffffff, bit_field_if)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h08),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk        (i_clk),
      .i_rst_n      (i_rst_n),
      .register_if  (register_if[1]),
      .bit_field_if (bit_field_if)
    );
    if (1) begin : g_eth_ip
      localparam bit [31:0] INITIAL_VALUE = 32'hc0a800d3;
      rggen_bit_field_if #(32) bit_field_sub_if();
      `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 32)
      rggen_bit_field #(
        .WIDTH          (32),
        .INITIAL_VALUE  (INITIAL_VALUE),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .bit_field_if       (bit_field_sub_if),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_sw_write_enable  ('1),
        .i_hw_write_enable  ('0),
        .i_hw_write_data    ('0),
        .i_hw_set           ('0),
        .i_hw_clear         ('0),
        .i_value            ('0),
        .i_mask             ('1),
        .o_value            (o_eth_ip),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_gateway_ip
    rggen_bit_field_if #(64) bit_field_if();
    `rggen_tie_off_unused_signals(64, 64'h00000000ffffffff, bit_field_if)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h10),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk        (i_clk),
      .i_rst_n      (i_rst_n),
      .register_if  (register_if[2]),
      .bit_field_if (bit_field_if)
    );
    if (1) begin : g_gateway_ip
      localparam bit [31:0] INITIAL_VALUE = 32'hc0a80001;
      rggen_bit_field_if #(32) bit_field_sub_if();
      `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 32)
      rggen_bit_field #(
        .WIDTH          (32),
        .INITIAL_VALUE  (INITIAL_VALUE),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .bit_field_if       (bit_field_sub_if),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_sw_write_enable  ('1),
        .i_hw_write_enable  ('0),
        .i_hw_write_data    ('0),
        .i_hw_set           ('0),
        .i_hw_clear         ('0),
        .i_value            ('0),
        .i_mask             ('1),
        .o_value            (o_gateway_ip),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_subnet_mask
    rggen_bit_field_if #(64) bit_field_if();
    `rggen_tie_off_unused_signals(64, 64'h00000000ffffffff, bit_field_if)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h18),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk        (i_clk),
      .i_rst_n      (i_rst_n),
      .register_if  (register_if[3]),
      .bit_field_if (bit_field_if)
    );
    if (1) begin : g_subnet_mask
      localparam bit [31:0] INITIAL_VALUE = 32'hffffff00;
      rggen_bit_field_if #(32) bit_field_sub_if();
      `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 32)
      rggen_bit_field #(
        .WIDTH          (32),
        .INITIAL_VALUE  (INITIAL_VALUE),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .bit_field_if       (bit_field_sub_if),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_sw_write_enable  ('1),
        .i_hw_write_enable  ('0),
        .i_hw_write_data    ('0),
        .i_hw_set           ('0),
        .i_hw_clear         ('0),
        .i_value            ('0),
        .i_mask             ('1),
        .o_value            (o_subnet_mask),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_recv_mac
    rggen_bit_field_if #(64) bit_field_if();
    `rggen_tie_off_unused_signals(64, 64'h0000ffffffffffff, bit_field_if)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (0),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h20),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk        (i_clk),
      .i_rst_n      (i_rst_n),
      .register_if  (register_if[4]),
      .bit_field_if (bit_field_if)
    );
    if (1) begin : g_recv_mac
      localparam bit [47:0] INITIAL_VALUE = 48'h000000000000;
      rggen_bit_field_if #(48) bit_field_sub_if();
      `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 48)
      rggen_bit_field #(
        .WIDTH              (48),
        .STORAGE            (0),
        .EXTERNAL_READ_DATA (1),
        .TRIGGER            (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .bit_field_if       (bit_field_sub_if),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_sw_write_enable  ('0),
        .i_hw_write_enable  ('0),
        .i_hw_write_data    ('0),
        .i_hw_set           ('0),
        .i_hw_clear         ('0),
        .i_value            (i_recv_mac),
        .i_mask             ('1),
        .o_value            (),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_recv_ip
    rggen_bit_field_if #(64) bit_field_if();
    `rggen_tie_off_unused_signals(64, 64'h00000000ffffffff, bit_field_if)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (0),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h28),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk        (i_clk),
      .i_rst_n      (i_rst_n),
      .register_if  (register_if[5]),
      .bit_field_if (bit_field_if)
    );
    if (1) begin : g_recv_ip
      localparam bit [31:0] INITIAL_VALUE = 32'h00000000;
      rggen_bit_field_if #(32) bit_field_sub_if();
      `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 32)
      rggen_bit_field #(
        .WIDTH              (32),
        .STORAGE            (0),
        .EXTERNAL_READ_DATA (1),
        .TRIGGER            (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .bit_field_if       (bit_field_sub_if),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_sw_write_enable  ('0),
        .i_hw_write_enable  ('0),
        .i_hw_write_data    ('0),
        .i_hw_set           ('0),
        .i_hw_clear         ('0),
        .i_value            (i_recv_ip),
        .i_mask             ('1),
        .o_value            (),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_recv_udp_length
    rggen_bit_field_if #(64) bit_field_if();
    `rggen_tie_off_unused_signals(64, 64'h000000000000ffff, bit_field_if)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (0),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h30),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk        (i_clk),
      .i_rst_n      (i_rst_n),
      .register_if  (register_if[6]),
      .bit_field_if (bit_field_if)
    );
    if (1) begin : g_recv_udp_length
      localparam bit [15:0] INITIAL_VALUE = 16'h0000;
      rggen_bit_field_if #(16) bit_field_sub_if();
      `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 16)
      rggen_bit_field #(
        .WIDTH              (16),
        .STORAGE            (0),
        .EXTERNAL_READ_DATA (1),
        .TRIGGER            (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .bit_field_if       (bit_field_sub_if),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_sw_write_enable  ('0),
        .i_hw_write_enable  ('0),
        .i_hw_write_data    ('0),
        .i_hw_set           ('0),
        .i_hw_clear         ('0),
        .i_value            (i_recv_udp_length),
        .i_mask             ('1),
        .o_value            (),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_send_mac
    rggen_bit_field_if #(64) bit_field_if();
    `rggen_tie_off_unused_signals(64, 64'h0000ffffffffffff, bit_field_if)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h38),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk        (i_clk),
      .i_rst_n      (i_rst_n),
      .register_if  (register_if[7]),
      .bit_field_if (bit_field_if)
    );
    if (1) begin : g_send_mac
      localparam bit [47:0] INITIAL_VALUE = 48'h000000000000;
      rggen_bit_field_if #(48) bit_field_sub_if();
      `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 48)
      rggen_bit_field #(
        .WIDTH          (48),
        .INITIAL_VALUE  (INITIAL_VALUE),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .bit_field_if       (bit_field_sub_if),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_sw_write_enable  ('1),
        .i_hw_write_enable  ('0),
        .i_hw_write_data    ('0),
        .i_hw_set           ('0),
        .i_hw_clear         ('0),
        .i_value            ('0),
        .i_mask             ('1),
        .o_value            (o_send_mac),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_send_ip
    rggen_bit_field_if #(64) bit_field_if();
    `rggen_tie_off_unused_signals(64, 64'h00000000ffffffff, bit_field_if)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h40),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk        (i_clk),
      .i_rst_n      (i_rst_n),
      .register_if  (register_if[8]),
      .bit_field_if (bit_field_if)
    );
    if (1) begin : g_send_ip
      localparam bit [31:0] INITIAL_VALUE = 32'h00000000;
      rggen_bit_field_if #(32) bit_field_sub_if();
      `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 32)
      rggen_bit_field #(
        .WIDTH          (32),
        .INITIAL_VALUE  (INITIAL_VALUE),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .bit_field_if       (bit_field_sub_if),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_sw_write_enable  ('1),
        .i_hw_write_enable  ('0),
        .i_hw_write_data    ('0),
        .i_hw_set           ('0),
        .i_hw_clear         ('0),
        .i_value            ('0),
        .i_mask             ('1),
        .o_value            (o_send_ip),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_send_udp_length
    rggen_bit_field_if #(64) bit_field_if();
    `rggen_tie_off_unused_signals(64, 64'h000000000000ffff, bit_field_if)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h48),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk        (i_clk),
      .i_rst_n      (i_rst_n),
      .register_if  (register_if[9]),
      .bit_field_if (bit_field_if)
    );
    if (1) begin : g_send_udp_length
      localparam bit [15:0] INITIAL_VALUE = 16'h0000;
      rggen_bit_field_if #(16) bit_field_sub_if();
      `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 16)
      rggen_bit_field #(
        .WIDTH          (16),
        .INITIAL_VALUE  (INITIAL_VALUE),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .bit_field_if       (bit_field_sub_if),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_sw_write_enable  ('1),
        .i_hw_write_enable  ('0),
        .i_hw_write_data    ('0),
        .i_hw_set           ('0),
        .i_hw_clear         ('0),
        .i_value            ('0),
        .i_mask             ('1),
        .o_value            (o_send_udp_length),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_send_pkt
    rggen_bit_field_if #(64) bit_field_if();
    `rggen_tie_off_unused_signals(64, 64'h0000000000000001, bit_field_if)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h50),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk        (i_clk),
      .i_rst_n      (i_rst_n),
      .register_if  (register_if[10]),
      .bit_field_if (bit_field_if)
    );
    if (1) begin : g_send_pkt
      localparam bit INITIAL_VALUE = 1'h0;
      rggen_bit_field_if #(1) bit_field_sub_if();
      `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 1)
      rggen_bit_field #(
        .WIDTH          (1),
        .INITIAL_VALUE  (INITIAL_VALUE),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .bit_field_if       (bit_field_sub_if),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_sw_write_enable  ('1),
        .i_hw_write_enable  ('0),
        .i_hw_write_data    ('0),
        .i_hw_set           ('0),
        .i_hw_clear         ('0),
        .i_value            ('0),
        .i_mask             ('1),
        .o_value            (o_send_pkt),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_clear_irq
    rggen_bit_field_if #(64) bit_field_if();
    `rggen_tie_off_unused_signals(64, 64'h0000000000000001, bit_field_if)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h58),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk        (i_clk),
      .i_rst_n      (i_rst_n),
      .register_if  (register_if[11]),
      .bit_field_if (bit_field_if)
    );
    if (1) begin : g_clear_irq
      localparam bit INITIAL_VALUE = 1'h0;
      rggen_bit_field_if #(1) bit_field_sub_if();
      `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 1)
      rggen_bit_field #(
        .WIDTH          (1),
        .INITIAL_VALUE  (INITIAL_VALUE),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .bit_field_if       (bit_field_sub_if),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_sw_write_enable  ('1),
        .i_hw_write_enable  ('0),
        .i_hw_write_data    ('0),
        .i_hw_set           ('0),
        .i_hw_clear         ('0),
        .i_value            ('0),
        .i_mask             ('1),
        .o_value            (o_clear_irq),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_clear_arp
    rggen_bit_field_if #(64) bit_field_if();
    `rggen_tie_off_unused_signals(64, 64'h0000000000000001, bit_field_if)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h60),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk        (i_clk),
      .i_rst_n      (i_rst_n),
      .register_if  (register_if[12]),
      .bit_field_if (bit_field_if)
    );
    if (1) begin : g_clear_arp
      localparam bit INITIAL_VALUE = 1'h0;
      rggen_bit_field_if #(1) bit_field_sub_if();
      `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 1)
      rggen_bit_field #(
        .WIDTH          (1),
        .INITIAL_VALUE  (INITIAL_VALUE),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .bit_field_if       (bit_field_sub_if),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_sw_write_enable  ('1),
        .i_hw_write_enable  ('0),
        .i_hw_write_data    ('0),
        .i_hw_set           ('0),
        .i_hw_clear         ('0),
        .i_value            ('0),
        .i_mask             ('1),
        .o_value            (o_clear_arp),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
endmodule

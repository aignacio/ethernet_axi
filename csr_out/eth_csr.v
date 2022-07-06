`include "rggen_rtl_macros.vh"
module eth_csr #(
  parameter ADDRESS_WIDTH = 8,
  parameter PRE_DECODE = 0,
  parameter [ADDRESS_WIDTH-1:0] BASE_ADDRESS = 0,
  parameter ERROR_STATUS = 0,
  parameter [63:0] DEFAULT_READ_DATA = 0,
  parameter ID_WIDTH = 0,
  parameter WRITE_FIRST = 1
)(
  input i_clk,
  input i_rst_n,
  input i_awvalid,
  output o_awready,
  input [((ID_WIDTH == 0) ? 1 : ID_WIDTH)-1:0] i_awid,
  input [ADDRESS_WIDTH-1:0] i_awaddr,
  input [2:0] i_awprot,
  input i_wvalid,
  output o_wready,
  input [63:0] i_wdata,
  input [7:0] i_wstrb,
  output o_bvalid,
  input i_bready,
  output [((ID_WIDTH == 0) ? 1 : ID_WIDTH)-1:0] o_bid,
  output [1:0] o_bresp,
  input i_arvalid,
  output o_arready,
  input [((ID_WIDTH == 0) ? 1 : ID_WIDTH)-1:0] i_arid,
  input [ADDRESS_WIDTH-1:0] i_araddr,
  input [2:0] i_arprot,
  output o_rvalid,
  input i_rready,
  output [((ID_WIDTH == 0) ? 1 : ID_WIDTH)-1:0] o_rid,
  output [63:0] o_rdata,
  output [1:0] o_rresp,
  output [23:0] o_eth_mac_low,
  output [23:0] o_eth_mac_high,
  output [31:0] o_eth_ip,
  output [31:0] o_gateway_ip,
  output [31:0] o_subnet_mask,
  input [23:0] i_recv_mac_low,
  input [23:0] i_recv_mac_high,
  input [31:0] i_recv_ip,
  input [15:0] i_recv_udp_length,
  output [23:0] o_send_mac_low,
  output [23:0] o_send_mac_high,
  output [31:0] o_send_ip,
  output [15:0] o_send_udp_length,
  output o_send_pkt,
  output o_clear_irq,
  output o_clear_irq_write_trigger,
  output o_clear_arp,
  output o_clear_arp_write_trigger
);
  wire w_register_valid;
  wire [1:0] w_register_access;
  wire [7:0] w_register_address;
  wire [63:0] w_register_write_data;
  wire [7:0] w_register_strobe;
  wire [15:0] w_register_active;
  wire [15:0] w_register_ready;
  wire [31:0] w_register_status;
  wire [1023:0] w_register_read_data;
  wire [1023:0] w_register_value;
  rggen_axi4lite_adapter #(
    .ID_WIDTH             (ID_WIDTH),
    .ADDRESS_WIDTH        (ADDRESS_WIDTH),
    .LOCAL_ADDRESS_WIDTH  (8),
    .BUS_WIDTH            (64),
    .REGISTERS            (16),
    .PRE_DECODE           (PRE_DECODE),
    .BASE_ADDRESS         (BASE_ADDRESS),
    .BYTE_SIZE            (256),
    .ERROR_STATUS         (ERROR_STATUS),
    .DEFAULT_READ_DATA    (DEFAULT_READ_DATA),
    .WRITE_FIRST          (WRITE_FIRST)
  ) u_adapter (
    .i_clk                  (i_clk),
    .i_rst_n                (i_rst_n),
    .i_awvalid              (i_awvalid),
    .o_awready              (o_awready),
    .i_awid                 (i_awid),
    .i_awaddr               (i_awaddr),
    .i_awprot               (i_awprot),
    .i_wvalid               (i_wvalid),
    .o_wready               (o_wready),
    .i_wdata                (i_wdata),
    .i_wstrb                (i_wstrb),
    .o_bvalid               (o_bvalid),
    .i_bready               (i_bready),
    .o_bid                  (o_bid),
    .o_bresp                (o_bresp),
    .i_arvalid              (i_arvalid),
    .o_arready              (o_arready),
    .i_arid                 (i_arid),
    .i_araddr               (i_araddr),
    .i_arprot               (i_arprot),
    .o_rvalid               (o_rvalid),
    .i_rready               (i_rready),
    .o_rid                  (o_rid),
    .o_rdata                (o_rdata),
    .o_rresp                (o_rresp),
    .o_register_valid       (w_register_valid),
    .o_register_access      (w_register_access),
    .o_register_address     (w_register_address),
    .o_register_write_data  (w_register_write_data),
    .o_register_strobe      (w_register_strobe),
    .i_register_active      (w_register_active),
    .i_register_ready       (w_register_ready),
    .i_register_status      (w_register_status),
    .i_register_read_data   (w_register_read_data)
  );
  generate if (1) begin : g_eth_mac_low
    wire w_bit_field_valid;
    wire [63:0] w_bit_field_read_mask;
    wire [63:0] w_bit_field_write_mask;
    wire [63:0] w_bit_field_write_data;
    wire [63:0] w_bit_field_read_data;
    wire [63:0] w_bit_field_value;
    `rggen_tie_off_unused_signals(64, 64'h0000000000ffffff, w_bit_field_read_data, w_bit_field_value)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h00),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk                  (i_clk),
      .i_rst_n                (i_rst_n),
      .i_register_valid       (w_register_valid),
      .i_register_access      (w_register_access),
      .i_register_address     (w_register_address),
      .i_register_write_data  (w_register_write_data),
      .i_register_strobe      (w_register_strobe),
      .o_register_active      (w_register_active[0+:1]),
      .o_register_ready       (w_register_ready[0+:1]),
      .o_register_status      (w_register_status[0+:2]),
      .o_register_read_data   (w_register_read_data[0+:64]),
      .o_register_value       (w_register_value[0+:64]),
      .o_bit_field_valid      (w_bit_field_valid),
      .o_bit_field_read_mask  (w_bit_field_read_mask),
      .o_bit_field_write_mask (w_bit_field_write_mask),
      .o_bit_field_write_data (w_bit_field_write_data),
      .i_bit_field_read_data  (w_bit_field_read_data),
      .i_bit_field_value      (w_bit_field_value)
    );
    if (1) begin : g_eth_mac_low
      rggen_bit_field #(
        .WIDTH          (24),
        .INITIAL_VALUE  (`rggen_slice(24'hdef061, 24, 0)),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .i_sw_valid         (w_bit_field_valid),
        .i_sw_read_mask     (w_bit_field_read_mask[0+:24]),
        .i_sw_write_enable  (1'b1),
        .i_sw_write_mask    (w_bit_field_write_mask[0+:24]),
        .i_sw_write_data    (w_bit_field_write_data[0+:24]),
        .o_sw_read_data     (w_bit_field_read_data[0+:24]),
        .o_sw_value         (w_bit_field_value[0+:24]),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_hw_write_enable  (1'b0),
        .i_hw_write_data    ({24{1'b0}}),
        .i_hw_set           ({24{1'b0}}),
        .i_hw_clear         ({24{1'b0}}),
        .i_value            ({24{1'b0}}),
        .i_mask             ({24{1'b1}}),
        .o_value            (o_eth_mac_low),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_eth_mac_high
    wire w_bit_field_valid;
    wire [63:0] w_bit_field_read_mask;
    wire [63:0] w_bit_field_write_mask;
    wire [63:0] w_bit_field_write_data;
    wire [63:0] w_bit_field_read_data;
    wire [63:0] w_bit_field_value;
    `rggen_tie_off_unused_signals(64, 64'h0000000000ffffff, w_bit_field_read_data, w_bit_field_value)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h08),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk                  (i_clk),
      .i_rst_n                (i_rst_n),
      .i_register_valid       (w_register_valid),
      .i_register_access      (w_register_access),
      .i_register_address     (w_register_address),
      .i_register_write_data  (w_register_write_data),
      .i_register_strobe      (w_register_strobe),
      .o_register_active      (w_register_active[1+:1]),
      .o_register_ready       (w_register_ready[1+:1]),
      .o_register_status      (w_register_status[2+:2]),
      .o_register_read_data   (w_register_read_data[64+:64]),
      .o_register_value       (w_register_value[64+:64]),
      .o_bit_field_valid      (w_bit_field_valid),
      .o_bit_field_read_mask  (w_bit_field_read_mask),
      .o_bit_field_write_mask (w_bit_field_write_mask),
      .o_bit_field_write_data (w_bit_field_write_data),
      .i_bit_field_read_data  (w_bit_field_read_data),
      .i_bit_field_value      (w_bit_field_value)
    );
    if (1) begin : g_eth_mac_high
      rggen_bit_field #(
        .WIDTH          (24),
        .INITIAL_VALUE  (`rggen_slice(24'h1dee69, 24, 0)),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .i_sw_valid         (w_bit_field_valid),
        .i_sw_read_mask     (w_bit_field_read_mask[0+:24]),
        .i_sw_write_enable  (1'b1),
        .i_sw_write_mask    (w_bit_field_write_mask[0+:24]),
        .i_sw_write_data    (w_bit_field_write_data[0+:24]),
        .o_sw_read_data     (w_bit_field_read_data[0+:24]),
        .o_sw_value         (w_bit_field_value[0+:24]),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_hw_write_enable  (1'b0),
        .i_hw_write_data    ({24{1'b0}}),
        .i_hw_set           ({24{1'b0}}),
        .i_hw_clear         ({24{1'b0}}),
        .i_value            ({24{1'b0}}),
        .i_mask             ({24{1'b1}}),
        .o_value            (o_eth_mac_high),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_eth_ip
    wire w_bit_field_valid;
    wire [63:0] w_bit_field_read_mask;
    wire [63:0] w_bit_field_write_mask;
    wire [63:0] w_bit_field_write_data;
    wire [63:0] w_bit_field_read_data;
    wire [63:0] w_bit_field_value;
    `rggen_tie_off_unused_signals(64, 64'h00000000ffffffff, w_bit_field_read_data, w_bit_field_value)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h10),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk                  (i_clk),
      .i_rst_n                (i_rst_n),
      .i_register_valid       (w_register_valid),
      .i_register_access      (w_register_access),
      .i_register_address     (w_register_address),
      .i_register_write_data  (w_register_write_data),
      .i_register_strobe      (w_register_strobe),
      .o_register_active      (w_register_active[2+:1]),
      .o_register_ready       (w_register_ready[2+:1]),
      .o_register_status      (w_register_status[4+:2]),
      .o_register_read_data   (w_register_read_data[128+:64]),
      .o_register_value       (w_register_value[128+:64]),
      .o_bit_field_valid      (w_bit_field_valid),
      .o_bit_field_read_mask  (w_bit_field_read_mask),
      .o_bit_field_write_mask (w_bit_field_write_mask),
      .o_bit_field_write_data (w_bit_field_write_data),
      .i_bit_field_read_data  (w_bit_field_read_data),
      .i_bit_field_value      (w_bit_field_value)
    );
    if (1) begin : g_eth_ip
      rggen_bit_field #(
        .WIDTH          (32),
        .INITIAL_VALUE  (`rggen_slice(32'hc0a800d3, 32, 0)),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .i_sw_valid         (w_bit_field_valid),
        .i_sw_read_mask     (w_bit_field_read_mask[0+:32]),
        .i_sw_write_enable  (1'b1),
        .i_sw_write_mask    (w_bit_field_write_mask[0+:32]),
        .i_sw_write_data    (w_bit_field_write_data[0+:32]),
        .o_sw_read_data     (w_bit_field_read_data[0+:32]),
        .o_sw_value         (w_bit_field_value[0+:32]),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_hw_write_enable  (1'b0),
        .i_hw_write_data    ({32{1'b0}}),
        .i_hw_set           ({32{1'b0}}),
        .i_hw_clear         ({32{1'b0}}),
        .i_value            ({32{1'b0}}),
        .i_mask             ({32{1'b1}}),
        .o_value            (o_eth_ip),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_gateway_ip
    wire w_bit_field_valid;
    wire [63:0] w_bit_field_read_mask;
    wire [63:0] w_bit_field_write_mask;
    wire [63:0] w_bit_field_write_data;
    wire [63:0] w_bit_field_read_data;
    wire [63:0] w_bit_field_value;
    `rggen_tie_off_unused_signals(64, 64'h00000000ffffffff, w_bit_field_read_data, w_bit_field_value)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h18),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk                  (i_clk),
      .i_rst_n                (i_rst_n),
      .i_register_valid       (w_register_valid),
      .i_register_access      (w_register_access),
      .i_register_address     (w_register_address),
      .i_register_write_data  (w_register_write_data),
      .i_register_strobe      (w_register_strobe),
      .o_register_active      (w_register_active[3+:1]),
      .o_register_ready       (w_register_ready[3+:1]),
      .o_register_status      (w_register_status[6+:2]),
      .o_register_read_data   (w_register_read_data[192+:64]),
      .o_register_value       (w_register_value[192+:64]),
      .o_bit_field_valid      (w_bit_field_valid),
      .o_bit_field_read_mask  (w_bit_field_read_mask),
      .o_bit_field_write_mask (w_bit_field_write_mask),
      .o_bit_field_write_data (w_bit_field_write_data),
      .i_bit_field_read_data  (w_bit_field_read_data),
      .i_bit_field_value      (w_bit_field_value)
    );
    if (1) begin : g_gateway_ip
      rggen_bit_field #(
        .WIDTH          (32),
        .INITIAL_VALUE  (`rggen_slice(32'hc0a80001, 32, 0)),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .i_sw_valid         (w_bit_field_valid),
        .i_sw_read_mask     (w_bit_field_read_mask[0+:32]),
        .i_sw_write_enable  (1'b1),
        .i_sw_write_mask    (w_bit_field_write_mask[0+:32]),
        .i_sw_write_data    (w_bit_field_write_data[0+:32]),
        .o_sw_read_data     (w_bit_field_read_data[0+:32]),
        .o_sw_value         (w_bit_field_value[0+:32]),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_hw_write_enable  (1'b0),
        .i_hw_write_data    ({32{1'b0}}),
        .i_hw_set           ({32{1'b0}}),
        .i_hw_clear         ({32{1'b0}}),
        .i_value            ({32{1'b0}}),
        .i_mask             ({32{1'b1}}),
        .o_value            (o_gateway_ip),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_subnet_mask
    wire w_bit_field_valid;
    wire [63:0] w_bit_field_read_mask;
    wire [63:0] w_bit_field_write_mask;
    wire [63:0] w_bit_field_write_data;
    wire [63:0] w_bit_field_read_data;
    wire [63:0] w_bit_field_value;
    `rggen_tie_off_unused_signals(64, 64'h00000000ffffffff, w_bit_field_read_data, w_bit_field_value)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h20),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk                  (i_clk),
      .i_rst_n                (i_rst_n),
      .i_register_valid       (w_register_valid),
      .i_register_access      (w_register_access),
      .i_register_address     (w_register_address),
      .i_register_write_data  (w_register_write_data),
      .i_register_strobe      (w_register_strobe),
      .o_register_active      (w_register_active[4+:1]),
      .o_register_ready       (w_register_ready[4+:1]),
      .o_register_status      (w_register_status[8+:2]),
      .o_register_read_data   (w_register_read_data[256+:64]),
      .o_register_value       (w_register_value[256+:64]),
      .o_bit_field_valid      (w_bit_field_valid),
      .o_bit_field_read_mask  (w_bit_field_read_mask),
      .o_bit_field_write_mask (w_bit_field_write_mask),
      .o_bit_field_write_data (w_bit_field_write_data),
      .i_bit_field_read_data  (w_bit_field_read_data),
      .i_bit_field_value      (w_bit_field_value)
    );
    if (1) begin : g_subnet_mask
      rggen_bit_field #(
        .WIDTH          (32),
        .INITIAL_VALUE  (`rggen_slice(32'hffffff00, 32, 0)),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .i_sw_valid         (w_bit_field_valid),
        .i_sw_read_mask     (w_bit_field_read_mask[0+:32]),
        .i_sw_write_enable  (1'b1),
        .i_sw_write_mask    (w_bit_field_write_mask[0+:32]),
        .i_sw_write_data    (w_bit_field_write_data[0+:32]),
        .o_sw_read_data     (w_bit_field_read_data[0+:32]),
        .o_sw_value         (w_bit_field_value[0+:32]),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_hw_write_enable  (1'b0),
        .i_hw_write_data    ({32{1'b0}}),
        .i_hw_set           ({32{1'b0}}),
        .i_hw_clear         ({32{1'b0}}),
        .i_value            ({32{1'b0}}),
        .i_mask             ({32{1'b1}}),
        .o_value            (o_subnet_mask),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_recv_mac_low
    wire w_bit_field_valid;
    wire [63:0] w_bit_field_read_mask;
    wire [63:0] w_bit_field_write_mask;
    wire [63:0] w_bit_field_write_data;
    wire [63:0] w_bit_field_read_data;
    wire [63:0] w_bit_field_value;
    `rggen_tie_off_unused_signals(64, 64'h0000000000ffffff, w_bit_field_read_data, w_bit_field_value)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (0),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h28),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk                  (i_clk),
      .i_rst_n                (i_rst_n),
      .i_register_valid       (w_register_valid),
      .i_register_access      (w_register_access),
      .i_register_address     (w_register_address),
      .i_register_write_data  (w_register_write_data),
      .i_register_strobe      (w_register_strobe),
      .o_register_active      (w_register_active[5+:1]),
      .o_register_ready       (w_register_ready[5+:1]),
      .o_register_status      (w_register_status[10+:2]),
      .o_register_read_data   (w_register_read_data[320+:64]),
      .o_register_value       (w_register_value[320+:64]),
      .o_bit_field_valid      (w_bit_field_valid),
      .o_bit_field_read_mask  (w_bit_field_read_mask),
      .o_bit_field_write_mask (w_bit_field_write_mask),
      .o_bit_field_write_data (w_bit_field_write_data),
      .i_bit_field_read_data  (w_bit_field_read_data),
      .i_bit_field_value      (w_bit_field_value)
    );
    if (1) begin : g_recv_mac_low
      rggen_bit_field #(
        .WIDTH              (24),
        .STORAGE            (0),
        .EXTERNAL_READ_DATA (1),
        .TRIGGER            (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .i_sw_valid         (w_bit_field_valid),
        .i_sw_read_mask     (w_bit_field_read_mask[0+:24]),
        .i_sw_write_enable  (1'b0),
        .i_sw_write_mask    (w_bit_field_write_mask[0+:24]),
        .i_sw_write_data    (w_bit_field_write_data[0+:24]),
        .o_sw_read_data     (w_bit_field_read_data[0+:24]),
        .o_sw_value         (w_bit_field_value[0+:24]),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_hw_write_enable  (1'b0),
        .i_hw_write_data    ({24{1'b0}}),
        .i_hw_set           ({24{1'b0}}),
        .i_hw_clear         ({24{1'b0}}),
        .i_value            (i_recv_mac_low),
        .i_mask             ({24{1'b1}}),
        .o_value            (),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_recv_mac_high
    wire w_bit_field_valid;
    wire [63:0] w_bit_field_read_mask;
    wire [63:0] w_bit_field_write_mask;
    wire [63:0] w_bit_field_write_data;
    wire [63:0] w_bit_field_read_data;
    wire [63:0] w_bit_field_value;
    `rggen_tie_off_unused_signals(64, 64'h0000000000ffffff, w_bit_field_read_data, w_bit_field_value)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (0),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h30),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk                  (i_clk),
      .i_rst_n                (i_rst_n),
      .i_register_valid       (w_register_valid),
      .i_register_access      (w_register_access),
      .i_register_address     (w_register_address),
      .i_register_write_data  (w_register_write_data),
      .i_register_strobe      (w_register_strobe),
      .o_register_active      (w_register_active[6+:1]),
      .o_register_ready       (w_register_ready[6+:1]),
      .o_register_status      (w_register_status[12+:2]),
      .o_register_read_data   (w_register_read_data[384+:64]),
      .o_register_value       (w_register_value[384+:64]),
      .o_bit_field_valid      (w_bit_field_valid),
      .o_bit_field_read_mask  (w_bit_field_read_mask),
      .o_bit_field_write_mask (w_bit_field_write_mask),
      .o_bit_field_write_data (w_bit_field_write_data),
      .i_bit_field_read_data  (w_bit_field_read_data),
      .i_bit_field_value      (w_bit_field_value)
    );
    if (1) begin : g_recv_mac_high
      rggen_bit_field #(
        .WIDTH              (24),
        .STORAGE            (0),
        .EXTERNAL_READ_DATA (1),
        .TRIGGER            (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .i_sw_valid         (w_bit_field_valid),
        .i_sw_read_mask     (w_bit_field_read_mask[0+:24]),
        .i_sw_write_enable  (1'b0),
        .i_sw_write_mask    (w_bit_field_write_mask[0+:24]),
        .i_sw_write_data    (w_bit_field_write_data[0+:24]),
        .o_sw_read_data     (w_bit_field_read_data[0+:24]),
        .o_sw_value         (w_bit_field_value[0+:24]),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_hw_write_enable  (1'b0),
        .i_hw_write_data    ({24{1'b0}}),
        .i_hw_set           ({24{1'b0}}),
        .i_hw_clear         ({24{1'b0}}),
        .i_value            (i_recv_mac_high),
        .i_mask             ({24{1'b1}}),
        .o_value            (),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_recv_ip
    wire w_bit_field_valid;
    wire [63:0] w_bit_field_read_mask;
    wire [63:0] w_bit_field_write_mask;
    wire [63:0] w_bit_field_write_data;
    wire [63:0] w_bit_field_read_data;
    wire [63:0] w_bit_field_value;
    `rggen_tie_off_unused_signals(64, 64'h00000000ffffffff, w_bit_field_read_data, w_bit_field_value)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (0),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h38),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk                  (i_clk),
      .i_rst_n                (i_rst_n),
      .i_register_valid       (w_register_valid),
      .i_register_access      (w_register_access),
      .i_register_address     (w_register_address),
      .i_register_write_data  (w_register_write_data),
      .i_register_strobe      (w_register_strobe),
      .o_register_active      (w_register_active[7+:1]),
      .o_register_ready       (w_register_ready[7+:1]),
      .o_register_status      (w_register_status[14+:2]),
      .o_register_read_data   (w_register_read_data[448+:64]),
      .o_register_value       (w_register_value[448+:64]),
      .o_bit_field_valid      (w_bit_field_valid),
      .o_bit_field_read_mask  (w_bit_field_read_mask),
      .o_bit_field_write_mask (w_bit_field_write_mask),
      .o_bit_field_write_data (w_bit_field_write_data),
      .i_bit_field_read_data  (w_bit_field_read_data),
      .i_bit_field_value      (w_bit_field_value)
    );
    if (1) begin : g_recv_ip
      rggen_bit_field #(
        .WIDTH              (32),
        .STORAGE            (0),
        .EXTERNAL_READ_DATA (1),
        .TRIGGER            (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .i_sw_valid         (w_bit_field_valid),
        .i_sw_read_mask     (w_bit_field_read_mask[0+:32]),
        .i_sw_write_enable  (1'b0),
        .i_sw_write_mask    (w_bit_field_write_mask[0+:32]),
        .i_sw_write_data    (w_bit_field_write_data[0+:32]),
        .o_sw_read_data     (w_bit_field_read_data[0+:32]),
        .o_sw_value         (w_bit_field_value[0+:32]),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_hw_write_enable  (1'b0),
        .i_hw_write_data    ({32{1'b0}}),
        .i_hw_set           ({32{1'b0}}),
        .i_hw_clear         ({32{1'b0}}),
        .i_value            (i_recv_ip),
        .i_mask             ({32{1'b1}}),
        .o_value            (),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_recv_udp_length
    wire w_bit_field_valid;
    wire [63:0] w_bit_field_read_mask;
    wire [63:0] w_bit_field_write_mask;
    wire [63:0] w_bit_field_write_data;
    wire [63:0] w_bit_field_read_data;
    wire [63:0] w_bit_field_value;
    `rggen_tie_off_unused_signals(64, 64'h000000000000ffff, w_bit_field_read_data, w_bit_field_value)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (0),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h40),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk                  (i_clk),
      .i_rst_n                (i_rst_n),
      .i_register_valid       (w_register_valid),
      .i_register_access      (w_register_access),
      .i_register_address     (w_register_address),
      .i_register_write_data  (w_register_write_data),
      .i_register_strobe      (w_register_strobe),
      .o_register_active      (w_register_active[8+:1]),
      .o_register_ready       (w_register_ready[8+:1]),
      .o_register_status      (w_register_status[16+:2]),
      .o_register_read_data   (w_register_read_data[512+:64]),
      .o_register_value       (w_register_value[512+:64]),
      .o_bit_field_valid      (w_bit_field_valid),
      .o_bit_field_read_mask  (w_bit_field_read_mask),
      .o_bit_field_write_mask (w_bit_field_write_mask),
      .o_bit_field_write_data (w_bit_field_write_data),
      .i_bit_field_read_data  (w_bit_field_read_data),
      .i_bit_field_value      (w_bit_field_value)
    );
    if (1) begin : g_recv_udp_length
      rggen_bit_field #(
        .WIDTH              (16),
        .STORAGE            (0),
        .EXTERNAL_READ_DATA (1),
        .TRIGGER            (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .i_sw_valid         (w_bit_field_valid),
        .i_sw_read_mask     (w_bit_field_read_mask[0+:16]),
        .i_sw_write_enable  (1'b0),
        .i_sw_write_mask    (w_bit_field_write_mask[0+:16]),
        .i_sw_write_data    (w_bit_field_write_data[0+:16]),
        .o_sw_read_data     (w_bit_field_read_data[0+:16]),
        .o_sw_value         (w_bit_field_value[0+:16]),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_hw_write_enable  (1'b0),
        .i_hw_write_data    ({16{1'b0}}),
        .i_hw_set           ({16{1'b0}}),
        .i_hw_clear         ({16{1'b0}}),
        .i_value            (i_recv_udp_length),
        .i_mask             ({16{1'b1}}),
        .o_value            (),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_send_mac_low
    wire w_bit_field_valid;
    wire [63:0] w_bit_field_read_mask;
    wire [63:0] w_bit_field_write_mask;
    wire [63:0] w_bit_field_write_data;
    wire [63:0] w_bit_field_read_data;
    wire [63:0] w_bit_field_value;
    `rggen_tie_off_unused_signals(64, 64'h0000000000ffffff, w_bit_field_read_data, w_bit_field_value)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h48),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk                  (i_clk),
      .i_rst_n                (i_rst_n),
      .i_register_valid       (w_register_valid),
      .i_register_access      (w_register_access),
      .i_register_address     (w_register_address),
      .i_register_write_data  (w_register_write_data),
      .i_register_strobe      (w_register_strobe),
      .o_register_active      (w_register_active[9+:1]),
      .o_register_ready       (w_register_ready[9+:1]),
      .o_register_status      (w_register_status[18+:2]),
      .o_register_read_data   (w_register_read_data[576+:64]),
      .o_register_value       (w_register_value[576+:64]),
      .o_bit_field_valid      (w_bit_field_valid),
      .o_bit_field_read_mask  (w_bit_field_read_mask),
      .o_bit_field_write_mask (w_bit_field_write_mask),
      .o_bit_field_write_data (w_bit_field_write_data),
      .i_bit_field_read_data  (w_bit_field_read_data),
      .i_bit_field_value      (w_bit_field_value)
    );
    if (1) begin : g_send_mac_low
      rggen_bit_field #(
        .WIDTH          (24),
        .INITIAL_VALUE  (`rggen_slice(24'h000000, 24, 0)),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .i_sw_valid         (w_bit_field_valid),
        .i_sw_read_mask     (w_bit_field_read_mask[0+:24]),
        .i_sw_write_enable  (1'b1),
        .i_sw_write_mask    (w_bit_field_write_mask[0+:24]),
        .i_sw_write_data    (w_bit_field_write_data[0+:24]),
        .o_sw_read_data     (w_bit_field_read_data[0+:24]),
        .o_sw_value         (w_bit_field_value[0+:24]),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_hw_write_enable  (1'b0),
        .i_hw_write_data    ({24{1'b0}}),
        .i_hw_set           ({24{1'b0}}),
        .i_hw_clear         ({24{1'b0}}),
        .i_value            ({24{1'b0}}),
        .i_mask             ({24{1'b1}}),
        .o_value            (o_send_mac_low),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_send_mac_high
    wire w_bit_field_valid;
    wire [63:0] w_bit_field_read_mask;
    wire [63:0] w_bit_field_write_mask;
    wire [63:0] w_bit_field_write_data;
    wire [63:0] w_bit_field_read_data;
    wire [63:0] w_bit_field_value;
    `rggen_tie_off_unused_signals(64, 64'h0000000000ffffff, w_bit_field_read_data, w_bit_field_value)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h50),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk                  (i_clk),
      .i_rst_n                (i_rst_n),
      .i_register_valid       (w_register_valid),
      .i_register_access      (w_register_access),
      .i_register_address     (w_register_address),
      .i_register_write_data  (w_register_write_data),
      .i_register_strobe      (w_register_strobe),
      .o_register_active      (w_register_active[10+:1]),
      .o_register_ready       (w_register_ready[10+:1]),
      .o_register_status      (w_register_status[20+:2]),
      .o_register_read_data   (w_register_read_data[640+:64]),
      .o_register_value       (w_register_value[640+:64]),
      .o_bit_field_valid      (w_bit_field_valid),
      .o_bit_field_read_mask  (w_bit_field_read_mask),
      .o_bit_field_write_mask (w_bit_field_write_mask),
      .o_bit_field_write_data (w_bit_field_write_data),
      .i_bit_field_read_data  (w_bit_field_read_data),
      .i_bit_field_value      (w_bit_field_value)
    );
    if (1) begin : g_send_mac_high
      rggen_bit_field #(
        .WIDTH          (24),
        .INITIAL_VALUE  (`rggen_slice(24'h000000, 24, 0)),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .i_sw_valid         (w_bit_field_valid),
        .i_sw_read_mask     (w_bit_field_read_mask[0+:24]),
        .i_sw_write_enable  (1'b1),
        .i_sw_write_mask    (w_bit_field_write_mask[0+:24]),
        .i_sw_write_data    (w_bit_field_write_data[0+:24]),
        .o_sw_read_data     (w_bit_field_read_data[0+:24]),
        .o_sw_value         (w_bit_field_value[0+:24]),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_hw_write_enable  (1'b0),
        .i_hw_write_data    ({24{1'b0}}),
        .i_hw_set           ({24{1'b0}}),
        .i_hw_clear         ({24{1'b0}}),
        .i_value            ({24{1'b0}}),
        .i_mask             ({24{1'b1}}),
        .o_value            (o_send_mac_high),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_send_ip
    wire w_bit_field_valid;
    wire [63:0] w_bit_field_read_mask;
    wire [63:0] w_bit_field_write_mask;
    wire [63:0] w_bit_field_write_data;
    wire [63:0] w_bit_field_read_data;
    wire [63:0] w_bit_field_value;
    `rggen_tie_off_unused_signals(64, 64'h00000000ffffffff, w_bit_field_read_data, w_bit_field_value)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h58),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk                  (i_clk),
      .i_rst_n                (i_rst_n),
      .i_register_valid       (w_register_valid),
      .i_register_access      (w_register_access),
      .i_register_address     (w_register_address),
      .i_register_write_data  (w_register_write_data),
      .i_register_strobe      (w_register_strobe),
      .o_register_active      (w_register_active[11+:1]),
      .o_register_ready       (w_register_ready[11+:1]),
      .o_register_status      (w_register_status[22+:2]),
      .o_register_read_data   (w_register_read_data[704+:64]),
      .o_register_value       (w_register_value[704+:64]),
      .o_bit_field_valid      (w_bit_field_valid),
      .o_bit_field_read_mask  (w_bit_field_read_mask),
      .o_bit_field_write_mask (w_bit_field_write_mask),
      .o_bit_field_write_data (w_bit_field_write_data),
      .i_bit_field_read_data  (w_bit_field_read_data),
      .i_bit_field_value      (w_bit_field_value)
    );
    if (1) begin : g_send_ip
      rggen_bit_field #(
        .WIDTH          (32),
        .INITIAL_VALUE  (`rggen_slice(32'h00000000, 32, 0)),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .i_sw_valid         (w_bit_field_valid),
        .i_sw_read_mask     (w_bit_field_read_mask[0+:32]),
        .i_sw_write_enable  (1'b1),
        .i_sw_write_mask    (w_bit_field_write_mask[0+:32]),
        .i_sw_write_data    (w_bit_field_write_data[0+:32]),
        .o_sw_read_data     (w_bit_field_read_data[0+:32]),
        .o_sw_value         (w_bit_field_value[0+:32]),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_hw_write_enable  (1'b0),
        .i_hw_write_data    ({32{1'b0}}),
        .i_hw_set           ({32{1'b0}}),
        .i_hw_clear         ({32{1'b0}}),
        .i_value            ({32{1'b0}}),
        .i_mask             ({32{1'b1}}),
        .o_value            (o_send_ip),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_send_udp_length
    wire w_bit_field_valid;
    wire [63:0] w_bit_field_read_mask;
    wire [63:0] w_bit_field_write_mask;
    wire [63:0] w_bit_field_write_data;
    wire [63:0] w_bit_field_read_data;
    wire [63:0] w_bit_field_value;
    `rggen_tie_off_unused_signals(64, 64'h000000000000ffff, w_bit_field_read_data, w_bit_field_value)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h60),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk                  (i_clk),
      .i_rst_n                (i_rst_n),
      .i_register_valid       (w_register_valid),
      .i_register_access      (w_register_access),
      .i_register_address     (w_register_address),
      .i_register_write_data  (w_register_write_data),
      .i_register_strobe      (w_register_strobe),
      .o_register_active      (w_register_active[12+:1]),
      .o_register_ready       (w_register_ready[12+:1]),
      .o_register_status      (w_register_status[24+:2]),
      .o_register_read_data   (w_register_read_data[768+:64]),
      .o_register_value       (w_register_value[768+:64]),
      .o_bit_field_valid      (w_bit_field_valid),
      .o_bit_field_read_mask  (w_bit_field_read_mask),
      .o_bit_field_write_mask (w_bit_field_write_mask),
      .o_bit_field_write_data (w_bit_field_write_data),
      .i_bit_field_read_data  (w_bit_field_read_data),
      .i_bit_field_value      (w_bit_field_value)
    );
    if (1) begin : g_send_udp_length
      rggen_bit_field #(
        .WIDTH          (16),
        .INITIAL_VALUE  (`rggen_slice(16'h0000, 16, 0)),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .i_sw_valid         (w_bit_field_valid),
        .i_sw_read_mask     (w_bit_field_read_mask[0+:16]),
        .i_sw_write_enable  (1'b1),
        .i_sw_write_mask    (w_bit_field_write_mask[0+:16]),
        .i_sw_write_data    (w_bit_field_write_data[0+:16]),
        .o_sw_read_data     (w_bit_field_read_data[0+:16]),
        .o_sw_value         (w_bit_field_value[0+:16]),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_hw_write_enable  (1'b0),
        .i_hw_write_data    ({16{1'b0}}),
        .i_hw_set           ({16{1'b0}}),
        .i_hw_clear         ({16{1'b0}}),
        .i_value            ({16{1'b0}}),
        .i_mask             ({16{1'b1}}),
        .o_value            (o_send_udp_length),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_send_pkt
    wire w_bit_field_valid;
    wire [63:0] w_bit_field_read_mask;
    wire [63:0] w_bit_field_write_mask;
    wire [63:0] w_bit_field_write_data;
    wire [63:0] w_bit_field_read_data;
    wire [63:0] w_bit_field_value;
    `rggen_tie_off_unused_signals(64, 64'h0000000000000001, w_bit_field_read_data, w_bit_field_value)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h68),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk                  (i_clk),
      .i_rst_n                (i_rst_n),
      .i_register_valid       (w_register_valid),
      .i_register_access      (w_register_access),
      .i_register_address     (w_register_address),
      .i_register_write_data  (w_register_write_data),
      .i_register_strobe      (w_register_strobe),
      .o_register_active      (w_register_active[13+:1]),
      .o_register_ready       (w_register_ready[13+:1]),
      .o_register_status      (w_register_status[26+:2]),
      .o_register_read_data   (w_register_read_data[832+:64]),
      .o_register_value       (w_register_value[832+:64]),
      .o_bit_field_valid      (w_bit_field_valid),
      .o_bit_field_read_mask  (w_bit_field_read_mask),
      .o_bit_field_write_mask (w_bit_field_write_mask),
      .o_bit_field_write_data (w_bit_field_write_data),
      .i_bit_field_read_data  (w_bit_field_read_data),
      .i_bit_field_value      (w_bit_field_value)
    );
    if (1) begin : g_send_pkt
      rggen_bit_field #(
        .WIDTH          (1),
        .INITIAL_VALUE  (`rggen_slice(1'h0, 1, 0)),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (0)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .i_sw_valid         (w_bit_field_valid),
        .i_sw_read_mask     (w_bit_field_read_mask[0+:1]),
        .i_sw_write_enable  (1'b1),
        .i_sw_write_mask    (w_bit_field_write_mask[0+:1]),
        .i_sw_write_data    (w_bit_field_write_data[0+:1]),
        .o_sw_read_data     (w_bit_field_read_data[0+:1]),
        .o_sw_value         (w_bit_field_value[0+:1]),
        .o_write_trigger    (),
        .o_read_trigger     (),
        .i_hw_write_enable  (1'b0),
        .i_hw_write_data    ({1{1'b0}}),
        .i_hw_set           ({1{1'b0}}),
        .i_hw_clear         ({1{1'b0}}),
        .i_value            ({1{1'b0}}),
        .i_mask             ({1{1'b1}}),
        .o_value            (o_send_pkt),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_clear_irq
    wire w_bit_field_valid;
    wire [63:0] w_bit_field_read_mask;
    wire [63:0] w_bit_field_write_mask;
    wire [63:0] w_bit_field_write_data;
    wire [63:0] w_bit_field_read_data;
    wire [63:0] w_bit_field_value;
    `rggen_tie_off_unused_signals(64, 64'h0000000000000001, w_bit_field_read_data, w_bit_field_value)
    rggen_default_register #(
      .READABLE       (0),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h70),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk                  (i_clk),
      .i_rst_n                (i_rst_n),
      .i_register_valid       (w_register_valid),
      .i_register_access      (w_register_access),
      .i_register_address     (w_register_address),
      .i_register_write_data  (w_register_write_data),
      .i_register_strobe      (w_register_strobe),
      .o_register_active      (w_register_active[14+:1]),
      .o_register_ready       (w_register_ready[14+:1]),
      .o_register_status      (w_register_status[28+:2]),
      .o_register_read_data   (w_register_read_data[896+:64]),
      .o_register_value       (w_register_value[896+:64]),
      .o_bit_field_valid      (w_bit_field_valid),
      .o_bit_field_read_mask  (w_bit_field_read_mask),
      .o_bit_field_write_mask (w_bit_field_write_mask),
      .o_bit_field_write_data (w_bit_field_write_data),
      .i_bit_field_read_data  (w_bit_field_read_data),
      .i_bit_field_value      (w_bit_field_value)
    );
    if (1) begin : g_clear_irq
      rggen_bit_field #(
        .WIDTH          (1),
        .INITIAL_VALUE  (`rggen_slice(1'h0, 1, 0)),
        .SW_READ_ACTION (`RGGEN_READ_NONE),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (1)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .i_sw_valid         (w_bit_field_valid),
        .i_sw_read_mask     (w_bit_field_read_mask[0+:1]),
        .i_sw_write_enable  (1'b1),
        .i_sw_write_mask    (w_bit_field_write_mask[0+:1]),
        .i_sw_write_data    (w_bit_field_write_data[0+:1]),
        .o_sw_read_data     (w_bit_field_read_data[0+:1]),
        .o_sw_value         (w_bit_field_value[0+:1]),
        .o_write_trigger    (o_clear_irq_write_trigger),
        .o_read_trigger     (),
        .i_hw_write_enable  (1'b0),
        .i_hw_write_data    ({1{1'b0}}),
        .i_hw_set           ({1{1'b0}}),
        .i_hw_clear         ({1{1'b0}}),
        .i_value            ({1{1'b0}}),
        .i_mask             ({1{1'b1}}),
        .o_value            (o_clear_irq),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
  generate if (1) begin : g_clear_arp
    wire w_bit_field_valid;
    wire [63:0] w_bit_field_read_mask;
    wire [63:0] w_bit_field_write_mask;
    wire [63:0] w_bit_field_write_data;
    wire [63:0] w_bit_field_read_data;
    wire [63:0] w_bit_field_value;
    `rggen_tie_off_unused_signals(64, 64'h0000000000000001, w_bit_field_read_data, w_bit_field_value)
    rggen_default_register #(
      .READABLE       (0),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h78),
      .BUS_WIDTH      (64),
      .DATA_WIDTH     (64),
      .REGISTER_INDEX (0)
    ) u_register (
      .i_clk                  (i_clk),
      .i_rst_n                (i_rst_n),
      .i_register_valid       (w_register_valid),
      .i_register_access      (w_register_access),
      .i_register_address     (w_register_address),
      .i_register_write_data  (w_register_write_data),
      .i_register_strobe      (w_register_strobe),
      .o_register_active      (w_register_active[15+:1]),
      .o_register_ready       (w_register_ready[15+:1]),
      .o_register_status      (w_register_status[30+:2]),
      .o_register_read_data   (w_register_read_data[960+:64]),
      .o_register_value       (w_register_value[960+:64]),
      .o_bit_field_valid      (w_bit_field_valid),
      .o_bit_field_read_mask  (w_bit_field_read_mask),
      .o_bit_field_write_mask (w_bit_field_write_mask),
      .o_bit_field_write_data (w_bit_field_write_data),
      .i_bit_field_read_data  (w_bit_field_read_data),
      .i_bit_field_value      (w_bit_field_value)
    );
    if (1) begin : g_clear_arp
      rggen_bit_field #(
        .WIDTH          (1),
        .INITIAL_VALUE  (`rggen_slice(1'h0, 1, 0)),
        .SW_READ_ACTION (`RGGEN_READ_NONE),
        .SW_WRITE_ONCE  (0),
        .TRIGGER        (1)
      ) u_bit_field (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .i_sw_valid         (w_bit_field_valid),
        .i_sw_read_mask     (w_bit_field_read_mask[0+:1]),
        .i_sw_write_enable  (1'b1),
        .i_sw_write_mask    (w_bit_field_write_mask[0+:1]),
        .i_sw_write_data    (w_bit_field_write_data[0+:1]),
        .o_sw_read_data     (w_bit_field_read_data[0+:1]),
        .o_sw_value         (w_bit_field_value[0+:1]),
        .o_write_trigger    (o_clear_arp_write_trigger),
        .o_read_trigger     (),
        .i_hw_write_enable  (1'b0),
        .i_hw_write_data    ({1{1'b0}}),
        .i_hw_set           ({1{1'b0}}),
        .i_hw_clear         ({1{1'b0}}),
        .i_value            ({1{1'b0}}),
        .i_mask             ({1{1'b1}}),
        .o_value            (o_clear_arp),
        .o_value_unmasked   ()
      );
    end
  end endgenerate
endmodule

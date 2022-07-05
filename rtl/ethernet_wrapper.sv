/**
 * File              : ethernet_wrapper.sv
 * License           : MIT license <Check LICENSE>
 * Author            : Anderson Ignacio da Silva (aignacio) <anderson@aignacio.com>
 * Date              : 03.07.2022
 * Last Modified Date: 05.07.2022
 */
module ethernet_wrapper
  import utils_pkg::*;
(
  input                 clk,
  input                 rst, // Active-High
  // CSR I/F
  input   s_axil_mosi_t eth_csr_mosi_i,
  output  s_axil_miso_t eth_csr_miso_o,
  // Slave FIFO I/F
  input   s_axi_mosi_t  eth_fifo_mosi_i,
  output  s_axi_miso_t  eth_fifo_miso_o,
  // Ethernet: 100BASE-T MII
  output  logic         phy_ref_clk, // 25MHz
  input                 phy_rx_clk,
  input   [3:0]         phy_rxd,
  input                 phy_rx_dv,
  input                 phy_rx_er,
  input                 phy_tx_clk,
  output  [3:0]         phy_txd,
  output                phy_tx_en,
  input                 phy_col,
  input                 phy_crs,
  output  logic         phy_reset_n,
  output  logic         pkt_recv_o
);
  s_eth_cfg_t local_cfg;

  // AXI between MAC and Ethernet modules
  logic [7:0]  rx_axis_tdata;
  logic        rx_axis_tvalid;
  logic        rx_axis_tready;
  logic        rx_axis_tlast;
  logic        rx_axis_tuser;

  logic [7:0]  tx_axis_tdata;
  logic        tx_axis_tvalid;
  logic        tx_axis_tready;
  logic        tx_axis_tlast;
  logic        tx_axis_tuser;

  // Ethernet frame between Ethernet modules and UDP stack
  logic        rx_eth_hdr_ready;
  logic        rx_eth_hdr_valid;
  logic [47:0] rx_eth_dest_mac;
  logic [47:0] rx_eth_src_mac;
  logic [15:0] rx_eth_type;
  logic [7:0]  rx_eth_payload_axis_tdata;
  logic        rx_eth_payload_axis_tvalid;
  logic        rx_eth_payload_axis_tready;
  logic        rx_eth_payload_axis_tlast;
  logic        rx_eth_payload_axis_tuser;

  logic        tx_eth_hdr_ready;
  logic        tx_eth_hdr_valid;
  logic [47:0] tx_eth_dest_mac;
  logic [47:0] tx_eth_src_mac;
  logic [15:0] tx_eth_type;
  logic [7:0]  tx_eth_payload_axis_tdata;
  logic        tx_eth_payload_axis_tvalid;
  logic        tx_eth_payload_axis_tready;
  logic        tx_eth_payload_axis_tlast;
  logic        tx_eth_payload_axis_tuser;

  assign phy_reset_n = !rst;
  // TODO: Added mmcm clock of 25MHz
  assign phy_ref_clk = clk;
  // TODO: IRQ packet received
  assign pkt_recv_o = 'b0;

  /* verilator lint_off WIDTH */
  eth_csr #(
    .ID_WIDTH                               (`AXI_TXN_ID_WIDTH),
  ) u_eth_csr (
    .i_clk                                  (clk),
    .i_rst_n                                (~rst),
    .i_awvalid                              (eth_csr_mosi_i.awvalid),
    .o_awready                              (eth_csr_miso_o.awready),
    .i_awid                                 (eth_csr_mosi_i.awid),
    .i_awaddr                               (eth_csr_mosi_i.awaddr),
    .i_awprot                               (eth_csr_mosi_i.awprot),
    .i_wvalid                               (eth_csr_mosi_i.wvalid),
    .o_wready                               (eth_csr_miso_o.wready),
    .i_wdata                                (eth_csr_mosi_i.wdata),
    .i_wstrb                                (eth_csr_mosi_i.wstrb),
    .o_bvalid                               (eth_csr_miso_o.bvalid),
    .i_bready                               (eth_csr_mosi_i.bready),
    .o_bid                                  (eth_csr_miso_o.bid),
    .o_bresp                                (eth_csr_miso_o.bresp),
    .i_arvalid                              (eth_csr_mosi_i.arvalid),
    .o_arready                              (eth_csr_miso_o.arready),
    .i_arid                                 (eth_csr_mosi_i.arid),
    .i_araddr                               (eth_csr_mosi_i.araddr),
    .i_arprot                               (eth_csr_mosi_i.arprot),
    .o_rvalid                               (eth_csr_miso_o.rvalid),
    .i_rready                               (eth_csr_mosi_i.rready),
    .o_rid                                  (eth_csr_miso_o.rid),
    .o_rdata                                (eth_csr_miso_o.rdata),
    .o_rresp                                (eth_csr_miso_o.rresp),
    // CSR connections
    .o_eth_mac                              (local_cfg.mac),
    .o_eth_ip                               (local_cfg.ip),
    .o_gateway_ip                           (local_cfg.gateway),
    .o_subnet_mask                          (local_cfg.subnet_mask),
    .i_recv_mac                             ('0),
    .i_recv_ip                              ('0),
    .i_recv_udp_length                      ('0),
    .o_send_mac                             (),
    .o_send_ip                              (),
    .o_send_udp_length                      (),
    .o_send_pkt                             (),
    .o_clear_irq                            (),
    .o_clear_arp                            ()
  );
  /* verilator lint_on WIDTH */

  eth_mac_mii_fifo #(
    .TARGET                                 ("XILINX"),
    .CLOCK_INPUT_STYLE                      ("BUFR"),
    .ENABLE_PADDING                         (1),
    .MIN_FRAME_LENGTH                       (64),
    .TX_FIFO_DEPTH                          (4096),
    .TX_FRAME_FIFO                          (1),
    .RX_FIFO_DEPTH                          (4096),
    .RX_FRAME_FIFO                          (1)
  ) eth_mac_inst (
    .rst                                    (rst),
    .logic_clk                              (clk),
    .logic_rst                              (rst),

    .tx_axis_tdata                          (tx_axis_tdata),
    .tx_axis_tvalid                         (tx_axis_tvalid),
    .tx_axis_tready                         (tx_axis_tready),
    .tx_axis_tlast                          (tx_axis_tlast),
    .tx_axis_tuser                          (tx_axis_tuser),
    .tx_axis_tkeep                          ('1),

    .rx_axis_tdata                          (rx_axis_tdata),
    .rx_axis_tvalid                         (rx_axis_tvalid),
    .rx_axis_tready                         (rx_axis_tready),
    .rx_axis_tlast                          (rx_axis_tlast),
    .rx_axis_tuser                          (rx_axis_tuser),
    .rx_axis_tkeep                          (),

    .mii_rx_clk                             (phy_rx_clk),
    .mii_rxd                                (phy_rxd),
    .mii_rx_dv                              (phy_rx_dv),
    .mii_rx_er                              (phy_rx_er),
    .mii_tx_clk                             (phy_tx_clk),
    .mii_txd                                (phy_txd),
    .mii_tx_en                              (phy_tx_en),
    .mii_tx_er                              (),

    .tx_fifo_overflow                       (),
    .tx_fifo_bad_frame                      (),
    .tx_fifo_good_frame                     (),
    .rx_error_bad_frame                     (),
    .rx_error_bad_fcs                       (),
    .rx_fifo_overflow                       (),
    .rx_fifo_bad_frame                      (),
    .rx_fifo_good_frame                     (),

    .ifg_delay                              (12),
    .tx_error_underflow                     ()
  );

  eth_axis_rx u_eth_axis_rx (
    .clk                                    (clk),
    .rst                                    (rst),
    // AXI input
    .s_axis_tdata                           (rx_axis_tdata),
    .s_axis_tvalid                          (rx_axis_tvalid),
    .s_axis_tready                          (rx_axis_tready),
    .s_axis_tlast                           (rx_axis_tlast),
    .s_axis_tuser                           (rx_axis_tuser),
    .s_axis_tkeep                           ('1),
    // Ethernet frame output
    .m_eth_hdr_valid                        (rx_eth_hdr_valid),
    .m_eth_hdr_ready                        (rx_eth_hdr_ready),
    .m_eth_dest_mac                         (rx_eth_dest_mac),
    .m_eth_src_mac                          (rx_eth_src_mac),
    .m_eth_type                             (rx_eth_type),
    .m_eth_payload_axis_tdata               (rx_eth_payload_axis_tdata),
    .m_eth_payload_axis_tvalid              (rx_eth_payload_axis_tvalid),
    .m_eth_payload_axis_tready              (rx_eth_payload_axis_tready),
    .m_eth_payload_axis_tlast               (rx_eth_payload_axis_tlast),
    .m_eth_payload_axis_tuser               (rx_eth_payload_axis_tuser),
    .m_eth_payload_axis_tkeep               (),
    // Status signals
    .busy                                   (),
    .error_header_early_termination         ()
  );

  eth_axis_tx u_eth_axis_tx (
    .clk                                    (clk),
    .rst                                    (rst),
    // Ethernet frame input
    .s_eth_hdr_valid                        (tx_eth_hdr_valid),
    .s_eth_hdr_ready                        (tx_eth_hdr_ready),
    .s_eth_dest_mac                         (tx_eth_dest_mac),
    .s_eth_src_mac                          (tx_eth_src_mac),
    .s_eth_type                             (tx_eth_type),
    .s_eth_payload_axis_tdata               (tx_eth_payload_axis_tdata),
    .s_eth_payload_axis_tvalid              (tx_eth_payload_axis_tvalid),
    .s_eth_payload_axis_tready              (tx_eth_payload_axis_tready),
    .s_eth_payload_axis_tlast               (tx_eth_payload_axis_tlast),
    .s_eth_payload_axis_tuser               (tx_eth_payload_axis_tuser),
    .s_eth_payload_axis_tkeep               ('1),
    // AXI output
    .m_axis_tdata                           (tx_axis_tdata),
    .m_axis_tvalid                          (tx_axis_tvalid),
    .m_axis_tready                          (tx_axis_tready),
    .m_axis_tlast                           (tx_axis_tlast),
    .m_axis_tuser                           (tx_axis_tuser),
    .m_axis_tkeep                           (),
    // Status signals
    .busy                                   ()
  );

  udp_complete #(
    .ARP_CACHE_ADDR_WIDTH                   (ARP_CACHE_ADDR_WIDTH           ),
    .ARP_REQUEST_RETRY_COUNT                (ARP_REQUEST_RETRY_COUNT        ),
    .ARP_REQUEST_RETRY_INTERVAL             (ARP_REQUEST_RETRY_INTERVAL     ),
    .ARP_REQUEST_TIMEOUT                    (ARP_REQUEST_TIMEOUT            ),
    .UDP_CHECKSUM_GEN_ENABLE                (UDP_CHECKSUM_GEN_ENABLE        ),
    .UDP_CHECKSUM_PAYLOAD_FIFO_DEPTH        (UDP_CHECKSUM_PAYLOAD_FIFO_DEPTH),
    .UDP_CHECKSUM_HEADER_FIFO_DEPTH         (UDP_CHECKSUM_HEADER_FIFO_DEPTH )
  ) u_udp_complete (
    .clk                                    (clk),
    .rst                                    (rst),
    // Ethernet frame input
    .s_eth_hdr_valid                        (rx_eth_hdr_valid),
    .s_eth_hdr_ready                        (rx_eth_hdr_ready),
    .s_eth_dest_mac                         (rx_eth_dest_mac),
    .s_eth_src_mac                          (rx_eth_src_mac),
    .s_eth_type                             (rx_eth_type),
    .s_eth_payload_axis_tdata               (rx_eth_payload_axis_tdata),
    .s_eth_payload_axis_tvalid              (rx_eth_payload_axis_tvalid),
    .s_eth_payload_axis_tready              (rx_eth_payload_axis_tready),
    .s_eth_payload_axis_tlast               (rx_eth_payload_axis_tlast),
    .s_eth_payload_axis_tuser               (rx_eth_payload_axis_tuser),
    // Ethernet frame output
    .m_eth_hdr_valid                        (tx_eth_hdr_valid),
    .m_eth_hdr_ready                        (tx_eth_hdr_ready),
    .m_eth_dest_mac                         (tx_eth_dest_mac),
    .m_eth_src_mac                          (tx_eth_src_mac),
    .m_eth_type                             (tx_eth_type),
    .m_eth_payload_axis_tdata               (tx_eth_payload_axis_tdata),
    .m_eth_payload_axis_tvalid              (tx_eth_payload_axis_tvalid),
    .m_eth_payload_axis_tready              (tx_eth_payload_axis_tready),
    .m_eth_payload_axis_tlast               (tx_eth_payload_axis_tlast),
    .m_eth_payload_axis_tuser               (tx_eth_payload_axis_tuser),
    // IP frame input
    .s_ip_hdr_valid                         ('0),
    .s_ip_hdr_ready                         (),
    .s_ip_dscp                              ('0),
    .s_ip_ecn                               ('0),
    .s_ip_length                            ('0),
    .s_ip_ttl                               ('0),
    .s_ip_protocol                          ('0),
    .s_ip_source_ip                         ('0),
    .s_ip_dest_ip                           ('0),
    .s_ip_payload_axis_tdata                ('0),
    .s_ip_payload_axis_tvalid               ('0),
    .s_ip_payload_axis_tready               (),
    .s_ip_payload_axis_tlast                ('0),
    .s_ip_payload_axis_tuser                ('0),
    // IP frame output
    .m_ip_hdr_valid                         (),
    .m_ip_hdr_ready                         ('1),
    .m_ip_eth_dest_mac                      (),
    .m_ip_eth_src_mac                       (),
    .m_ip_eth_type                          (),
    .m_ip_version                           (),
    .m_ip_ihl                               (),
    .m_ip_dscp                              (),
    .m_ip_ecn                               (),
    .m_ip_length                            (),
    .m_ip_identification                    (),
    .m_ip_flags                             (),
    .m_ip_fragment_offset                   (),
    .m_ip_ttl                               (),
    .m_ip_protocol                          (),
    .m_ip_header_checksum                   (),
    .m_ip_source_ip                         (),
    .m_ip_dest_ip                           (),
    .m_ip_payload_axis_tdata                (),
    .m_ip_payload_axis_tvalid               (),
    .m_ip_payload_axis_tready               ('1),
    .m_ip_payload_axis_tlast                (),
    .m_ip_payload_axis_tuser                (),
    // UDP frame input
    .s_udp_hdr_valid                        ('0),
    .s_udp_hdr_ready                        (),
    .s_udp_ip_dscp                          ('0),
    .s_udp_ip_ecn                           ('0),
    .s_udp_ip_ttl                           ('0),
    .s_udp_ip_source_ip                     ('0),
    .s_udp_ip_dest_ip                       ('0),
    .s_udp_source_port                      ('0),
    .s_udp_dest_port                        ('0),
    .s_udp_length                           ('0),
    .s_udp_checksum                         ('0),
    .s_udp_payload_axis_tdata               ('0),
    .s_udp_payload_axis_tvalid              ('0),
    .s_udp_payload_axis_tready              (),
    .s_udp_payload_axis_tlast               ('0),
    .s_udp_payload_axis_tuser               ('0),
    // UDP frame output
    .m_udp_hdr_valid                        (),
    .m_udp_hdr_ready                        ('1),
    .m_udp_eth_dest_mac                     (),
    .m_udp_eth_src_mac                      (),
    .m_udp_eth_type                         (),
    .m_udp_ip_version                       (),
    .m_udp_ip_ihl                           (),
    .m_udp_ip_dscp                          (),
    .m_udp_ip_ecn                           (),
    .m_udp_ip_length                        (),
    .m_udp_ip_identification                (),
    .m_udp_ip_flags                         (),
    .m_udp_ip_fragment_offset               (),
    .m_udp_ip_ttl                           (),
    .m_udp_ip_protocol                      (),
    .m_udp_ip_header_checksum               (),
    .m_udp_ip_source_ip                     (),
    .m_udp_ip_dest_ip                       (),
    .m_udp_source_port                      (),
    .m_udp_dest_port                        (),
    .m_udp_length                           (),
    .m_udp_checksum                         (),
    .m_udp_payload_axis_tdata               (),
    .m_udp_payload_axis_tvalid              (),
    .m_udp_payload_axis_tready              ('1),
    .m_udp_payload_axis_tlast               (),
    .m_udp_payload_axis_tuser               (),
    // Status signals
    .ip_rx_busy                             (),
    .ip_tx_busy                             (),
    .udp_rx_busy                            (),
    .udp_tx_busy                            (),
    .ip_rx_error_header_early_termination   (),
    .ip_rx_error_payload_early_termination  (),
    .ip_rx_error_invalid_header             (),
    .ip_rx_error_invalid_checksum           (),
    .ip_tx_error_payload_early_termination  (),
    .ip_tx_error_arp_failed                 (),
    .udp_rx_error_header_early_termination  (),
    .udp_rx_error_payload_early_termination (),
    .udp_tx_error_payload_early_termination (),
    // Configuration
    .local_mac                              (local_cfg.mac),
    .local_ip                               (local_cfg.ip),
    .gateway_ip                             (local_cfg.gateway),
    .subnet_mask                            (local_cfg.subnet_mask),
    .clear_arp_cache                        ()
  );

endmodule

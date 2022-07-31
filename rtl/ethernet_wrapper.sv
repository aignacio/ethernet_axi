/**
 * File              : ethernet_wrapper.sv
 * License           : MIT license <Check LICENSE>
 * Author            : Anderson Ignacio da Silva (aignacio) <anderson@aignacio.com>
 * Date              : 03.07.2022
 * Last Modified Date: 31.07.2022
 */
module ethernet_wrapper
  import utils_pkg::*;
(
`ifdef ETH_TARGET_FPGA_ARTY
  input                 clk_src,  // 100MHz
`elsif ETH_TARGET_FPGA_NEXYSV
  input                 clk_src,  // 100MHz
`elsif ETH_TARGET_FPGA_KINTEX
  input                 clk_in_p, // 200MHz
  input                 clk_in_n, // 200MHz
`endif
  input                 clk_axi,  // Clk of the AXI bus
  input                 rst_axi,  // Active-High
  // CSR I/F
  input   s_axil_mosi_t eth_csr_mosi_i,
  output  s_axil_miso_t eth_csr_miso_o,
  // Slave inFIFO I/F
  input   s_axi_mosi_t  eth_infifo_mosi_i,
  output  s_axi_miso_t  eth_infifo_miso_o,
  // Slave outFIFO I/F
  input   s_axi_mosi_t  eth_outfifo_mosi_i,
  output  s_axi_miso_t  eth_outfifo_miso_o,
`ifdef ETH_TARGET_FPGA_ARTY
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
`elsif ETH_TARGET_FPGA_NEXYSV
  // Ethernet: 1000BASE-T RGMII
  input                 phy_rx_clk,
  input   [3:0]         phy_rxd,
  input                 phy_rx_ctl,
  output                phy_tx_clk,
  output  [3:0]         phy_txd,
  output                phy_tx_ctl,
  output                phy_reset_n,
  input                 phy_int_n,
  input                 phy_pme_n,
`elsif ETH_TARGET_FPGA_KINTEX
  // Ethernet: 1000BASE-T GMII
  input                 phy_rx_clk,
  input   [7:0]         phy_rxd,
  input                 phy_rx_dv,
  input                 phy_rx_er,
  output                phy_gtx_clk,
  input                 phy_tx_clk,
  output  [7:0]         phy_txd,
  output                phy_tx_en,
  output                phy_tx_er,
  output                phy_reset_n,
  input                 phy_int_n,
`endif
  // IRQs
  output  logic         pkt_recv_o,
  output  logic         pkt_sent_o
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

  logic        udp_hdr_valid;
  logic        clk_200MHz;
  logic        clk_125MHz; // Internal clock
  logic        clk_90MHz;
  logic        clk_25MHz;
  logic        clk_locked;
  logic        rst_int;

  assign phy_reset_n = !rst_int;

`ifdef VERILATOR
  assign clk_200MHz = clk_src;
  assign clk_125MHz = clk_src;
  assign clk_90MHz  = clk_src;
  assign clk_25MHz  = clk_src;
  assign rst_int    = rst_axi;
`else
  sync_reset #(
    .N            (4)
  ) sync_reset_inst (
    .clk          (clk_125MHz),
    .rst          (~clk_locked),
    .out          (rst_int)
  );

  clk_mgmt_eth u_clk_mgmt_eth(
  `ifdef ETH_TARGET_FPGA_KINTEX
    .clk_in_p     (clk_in_p),
    .clk_in_n     (clk_in_n),
  `else
    .clk_in       (clk_src),  // 100MHz
  `endif
    .rst_in       (rst_axi),
    .clk_125MHz   (clk_125MHz),
  `ifdef ETH_TARGET_FPGA_NEXYSV
    .clk_90MHz    (clk_90MHz),
    .clk_200MHz   (clk_200MHz),
  `endif
  `ifdef ETH_TARGET_FPGA_ARTY
    .clk_25MHz    (phy_ref_clk),
  `endif
    .clk_locked   (clk_locked)
  );
`endif
  /* verilator lint_off WIDTH */
  eth_csr #(
    .ID_WIDTH                               (`AXI_TXN_ID_WIDTH)
  ) u_eth_csr (
    .i_clk                                  (clk_axi),
    .i_rst_n                                (~rst_axi),
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
    .o_eth_mac_low                          (local_cfg.mac[23:0]),
    .o_eth_mac_high                         (local_cfg.mac[47:24]),
    .o_eth_ip                               (local_cfg.ip),
    .o_gateway_ip                           (local_cfg.gateway),
    .o_subnet_mask                          (local_cfg.subnet_mask),
    .i_recv_mac_low                         (recv_udp_ff.mac[23:0]),
    .i_recv_mac_high                        (recv_udp_ff.mac[47:24]),
    .i_recv_ip                              (recv_udp_ff.ip),
    .i_recv_udp_length                      (recv_udp_ff.length-'d8),
    .i_recv_udp_src_port                    (recv_udp_ff.src_port),
    .i_recv_udp_dst_port                    (recv_udp_ff.dst_port),
    .o_recv_fifo_clear                      (),
    .o_recv_fifo_clear_write_trigger        (infifo_cmd.clear),
    .i_recv_fifo_rd_ptr                     (infifo_status.rd_ptr),
    .i_recv_fifo_wr_ptr                     (infifo_status.wr_ptr),
    .i_recv_fifo_full                       (infifo_status.full),
    .i_recv_fifo_empty                      (infifo_status.empty),

    .o_send_mac_low                         (send_udp.mac[23:0]),
    .o_send_mac_high                        (send_udp.mac[47:24]),
    .o_send_ip                              (send_udp.ip),
    .o_send_udp_length                      (send_udp.length),
    .o_send_src_port                        (send_udp.src_port),
    .o_send_dst_port                        (send_udp.dst_port),
    .o_send_pkt                             (),
    .o_send_pkt_write_trigger               (send_pkt),
    .o_clear_irq                            (),
    .o_clear_irq_write_trigger              (clear_irq),
    .o_clear_arp                            (),
    .o_clear_arp_write_trigger              (clear_arp_cache),
    .o_send_fifo_clear                      (),
    .o_send_fifo_clear_write_trigger        (outfifo_cmd.clear),
    .i_send_fifo_rd_ptr                     (outfifo_status.rd_ptr),
    .i_send_fifo_wr_ptr                     (outfifo_status.wr_ptr),
    .i_send_fifo_full                       (outfifo_status.full),
    .i_send_fifo_empty                      (outfifo_status.empty),

    .i_irq_pkt_recv                         (irq_rx_ff),
    .i_irq_pkt_sent                         (irq_tx_ff)
  );
  /* verilator lint_on WIDTH */

`ifdef ETH_TARGET_FPGA_ARTY
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
    .rst                                    (rst_int),
    .logic_clk                              (clk_125MHz),
    .logic_rst                              (rst_int),

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
`elsif ETH_TARGET_FPGA_NEXYSV
  // IODELAY elements for RGMII interface to PHY
  logic [3:0] phy_rxd_delay;
  logic       phy_rx_ctl_delay;

  IDELAYCTRL idelayctrl_inst(
    .REFCLK       (clk_200MHz),
    .RST          (rst_int),
    .RDY          ()
  );

  IDELAYE2 #(
    .IDELAY_TYPE  ("FIXED")
  ) phy_rxd_idelay_0 (
    .IDATAIN      (phy_rxd[0]),
    .DATAOUT      (phy_rxd_delay[0]),
    .DATAIN       ('0),
    .C            ('0),
    .CE           ('0),
    .INC          ('0),
    .CINVCTRL     ('0),
    .CNTVALUEIN   ('0),
    .CNTVALUEOUT  (),
    .LD           ('0),
    .LDPIPEEN     ('0),
    .REGRST       ('0)
  );

  IDELAYE2 #(
    .IDELAY_TYPE  ("FIXED")
  ) phy_rxd_idelay_1 (
    .IDATAIN      (phy_rxd[1]),
    .DATAOUT      (phy_rxd_delay[1]),
    .DATAIN       ('0),
    .C            ('0),
    .CE           ('0),
    .INC          ('0),
    .CINVCTRL     ('0),
    .CNTVALUEIN   ('0),
    .CNTVALUEOUT  (),
    .LD           ('0),
    .LDPIPEEN     ('0),
    .REGRST       ('0)
  );

  IDELAYE2 #(
    .IDELAY_TYPE  ("FIXED")
  ) phy_rxd_idelay_2 (
    .IDATAIN      (phy_rxd[2]),
    .DATAOUT      (phy_rxd_delay[2]),
    .DATAIN       ('0),
    .C            ('0),
    .CE           ('0),
    .INC          ('0),
    .CINVCTRL     ('0),
    .CNTVALUEIN   ('0),
    .CNTVALUEOUT  (),
    .LD           ('0),
    .LDPIPEEN     ('0),
    .REGRST       ('0)
  );

  IDELAYE2 #(
    .IDELAY_TYPE  ("FIXED")
  ) phy_rxd_idelay_3 (
    .IDATAIN      (phy_rxd[3]),
    .DATAOUT      (phy_rxd_delay[3]),
    .DATAIN       ('0),
    .C            ('0),
    .CE           ('0),
    .INC          ('0),
    .CINVCTRL     ('0),
    .CNTVALUEIN   ('0),
    .CNTVALUEOUT  (),
    .LD           ('0),
    .LDPIPEEN     ('0),
    .REGRST       ('0)
  );

  IDELAYE2 #(
    .IDELAY_TYPE  ("FIXED")
  ) phy_rx_ctl_idelay (
    .IDATAIN      (phy_rx_ctl),
    .DATAOUT      (phy_rx_ctl_delay),
    .DATAIN       ('0),
    .C            ('0),
    .CE           ('0),
    .INC          ('0),
    .CINVCTRL     ('0),
    .CNTVALUEIN   ('0),
    .CNTVALUEOUT  (),
    .LD           ('0),
    .LDPIPEEN     ('0),
    .REGRST       ('0)
  );

  eth_mac_1g_rgmii_fifo #(
    .TARGET                                 ("XILINX"),
    .IODDR_STYLE                            ("IODDR"),
    .CLOCK_INPUT_STYLE                      ("BUFR"),
    .USE_CLK90                              ("TRUE"),
    .ENABLE_PADDING                         (1),
    .MIN_FRAME_LENGTH                       (64),
    .TX_FIFO_DEPTH                          (4096),
    .TX_FRAME_FIFO                          (1),
    .RX_FIFO_DEPTH                          (4096),
    .RX_FRAME_FIFO                          (1)
  ) eth_mac_inst (
    .gtx_clk                                (clk_125MHz),
    .gtx_clk90                              (clk_90MHz),
    .gtx_rst                                (rst_int),
    .logic_clk                              (clk_axi),
    .logic_rst                              (rst_axi),

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

    .rgmii_rx_clk                           (phy_rx_clk),
    .rgmii_rxd                              (phy_rxd_delay),
    .rgmii_rx_ctl                           (phy_rx_ctl_delay),
    .rgmii_tx_clk                           (phy_tx_clk),
    .rgmii_txd                              (phy_txd),
    .rgmii_tx_ctl                           (phy_tx_ctl),

    .tx_fifo_overflow                       (),
    .tx_fifo_bad_frame                      (),
    .tx_fifo_good_frame                     (),
    .rx_error_bad_frame                     (),
    .rx_error_bad_fcs                       (),
    .rx_fifo_overflow                       (),
    .rx_fifo_bad_frame                      (),
    .rx_fifo_good_frame                     (),
    .speed                                  (),
    .tx_error_underflow                     (),

    .ifg_delay                              (12)
  );
`elsif ETH_TARGET_FPGA_KINTEX
  eth_mac_1g_gmii_fifo #(
    .TARGET                                 ("XILINX"),
    .IODDR_STYLE                            ("IODDR"),
    .CLOCK_INPUT_STYLE                      ("BUFR"),
    .ENABLE_PADDING                         (1),
    .MIN_FRAME_LENGTH                       (64),
    .TX_FIFO_DEPTH                          (4096),
    .TX_FRAME_FIFO                          (1),
    .RX_FIFO_DEPTH                          (4096),
    .RX_FRAME_FIFO                          (1)
  ) eth_mac_inst (
    .gtx_clk                                (clk_125MHz),
    .gtx_rst                                (rst_int),
    .logic_clk                              (clk_axi),
    .logic_rst                              (rst_axi),

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

    .gmii_rx_clk                            (phy_rx_clk),
    .gmii_rxd                               (phy_rxd),
    .gmii_rx_dv                             (phy_rx_dv),
    .gmii_rx_er                             (phy_rx_er),
    .gmii_tx_clk                            (phy_gtx_clk),
    .mii_tx_clk                             (phy_tx_clk),
    .gmii_txd                               (phy_txd),
    .gmii_tx_en                             (phy_tx_en),
    .gmii_tx_er                             (phy_tx_er),

    .tx_fifo_overflow                       (),
    .tx_fifo_bad_frame                      (),
    .tx_fifo_good_frame                     (),
    .rx_error_bad_frame                     (),
    .rx_error_bad_fcs                       (),
    .rx_fifo_overflow                       (),
    .rx_fifo_bad_frame                      (),
    .rx_fifo_good_frame                     (),
    .speed                                  (),
    .tx_error_underflow                     (),

    .ifg_delay                              (12)
  );
`endif

  eth_axis_rx u_eth_axis_rx (
    .clk                                    (clk_axi),
    .rst                                    (rst_axi),
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
    .clk                                    (clk_axi),
    .rst                                    (rst_axi),
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
    .clk                                    (clk_axi),
    .rst                                    (rst_axi),
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
    .s_udp_hdr_valid                        (send_pkt_ff),
    .s_udp_hdr_ready                        (udp_hdr_ready),
    .s_udp_ip_dscp                          ('0),
    .s_udp_ip_ecn                           ('0),
    .s_udp_ip_ttl                           ('d64),
    .s_udp_ip_source_ip                     (local_cfg.ip),
    .s_udp_ip_dest_ip                       (send_udp.ip),
    .s_udp_source_port                      (send_udp.src_port),
    .s_udp_dest_port                        (send_udp.dst_port),
    .s_udp_length                           (send_udp.length+'d8),
    .s_udp_checksum                         ('0),
    .s_udp_payload_axis_tdata               (axis_mosi_frame_input.tdata),
    .s_udp_payload_axis_tvalid              (axis_mosi_frame_input.tvalid),
    .s_udp_payload_axis_tready              (axis_miso_frame_input.tready),
    .s_udp_payload_axis_tlast               (axis_mosi_frame_input.tlast),
    .s_udp_payload_axis_tuser               (axis_mosi_frame_input.tuser),
    // UDP frame output
    .m_udp_hdr_valid                        (udp_hdr_valid),
    .m_udp_hdr_ready                        ('1),
    .m_udp_eth_dest_mac                     (),
    .m_udp_eth_src_mac                      (recv_udp.mac),
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
    .m_udp_ip_source_ip                     (recv_udp.ip),
    .m_udp_ip_dest_ip                       (),
    .m_udp_source_port                      (recv_udp.src_port),
    .m_udp_dest_port                        (recv_udp.dst_port),
    .m_udp_length                           (recv_udp.length),
    .m_udp_checksum                         (),
    .m_udp_payload_axis_tdata               (axis_mosi_frame_output.tdata),
    .m_udp_payload_axis_tvalid              (axis_mosi_frame_output.tvalid),
    .m_udp_payload_axis_tready              (axis_miso_frame_output.tready),
    .m_udp_payload_axis_tlast               (axis_mosi_frame_output.tlast),
    .m_udp_payload_axis_tuser               (axis_mosi_frame_output.tuser),
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
    .clear_arp_cache                        (clear_arp_cache)
  );

  s_axis_mosi_t axis_mosi_frame_input;
  s_axis_miso_t axis_miso_frame_input;

  s_axis_mosi_t axis_mosi_frame_output;
  s_axis_miso_t axis_miso_frame_output;

  pkt_fifo #(
    .FIFO_TYPE("IN")
  ) u_infifo (
    .clk_axi       (clk_axi),
    .rst_axi       (rst_axi),
    .clk_eth       (clk_axi),
    .rst_eth       (rst_axi),
    // Slave AXI I/F
    .axi_mosi      (eth_infifo_mosi_i),
    .axi_miso      (eth_infifo_miso_o),
    // UDP Stream_In I/F
    .axis_sin_mosi (axis_mosi_frame_output),
    .axis_sin_miso (axis_miso_frame_output),
    // UDP Stream_Out I/F
    .axis_sout_mosi(),
    .axis_sout_miso('0),
    // FIFO status
    .fifo_st_o     (infifo_status),
    .fifo_cmd_i    (infifo_cmd)
  );

  pkt_fifo #(
    .FIFO_TYPE("OUT")
  ) u_outfifo (
    .clk_axi       (clk_axi),
    .rst_axi       (rst_axi),
    .clk_eth       (clk_axi),
    .rst_eth       (rst_axi),
    // Slave AXI I/F
    .axi_mosi      (eth_outfifo_mosi_i),
    .axi_miso      (eth_outfifo_miso_o),
    // UDP Stream_In I/F
    .axis_sin_mosi ('0),
    .axis_sin_miso (),
    // UDP Stream_Out I/F
    .axis_sout_mosi(axis_mosi_frame_input),
    .axis_sout_miso(axis_miso_frame_input),
    // FIFO status
    .fifo_st_o     (outfifo_status),
    .fifo_cmd_i    (outfifo_cmd)
  );

  s_eth_udp_t  recv_udp_ff, next_recv;
  s_eth_udp_t  recv_udp;
  s_eth_udp_t  send_udp;
  logic        clear_irq;
  logic        clear_arp_cache;
  logic        send_pkt;
  logic        send_pkt_ff, next_send_pkt;
  logic        udp_hdr_ready;
  logic        irq_rx_ff, next_rx_irq;
  logic        irq_tx_ff, next_tx_irq;
  s_fifo_st_t  infifo_status;
  s_fifo_st_t  outfifo_status;
  s_fifo_cmd_t infifo_cmd;
  s_fifo_cmd_t outfifo_cmd;

  always_comb begin
    next_rx_irq = irq_rx_ff;
    pkt_recv_o = irq_rx_ff;
    next_recv = recv_udp_ff;
    infifo_cmd.start = 1'b0;

    // Receive pkt
    if (udp_hdr_valid) begin
      next_recv = recv_udp;
    end

    if (infifo_status.done) begin
      next_rx_irq = 1'b1;
    end

    if (clear_irq) begin
      next_rx_irq = 1'b0;
    end

    // Send PKt
    next_send_pkt = send_pkt_ff;
    next_tx_irq = irq_tx_ff;
    pkt_sent_o = irq_tx_ff;
    outfifo_cmd.start = send_pkt_ff;
    outfifo_cmd.length = send_udp.length;

    if (send_pkt) begin
      next_send_pkt = 1'b1;
    end

    if (send_pkt_ff) begin
      next_send_pkt = udp_hdr_ready ? 1'b0 : 1'b1;
    end

    if (outfifo_status.done) begin
      next_tx_irq = 1'b1;
    end

    if (clear_irq) begin
      next_tx_irq = 1'b0;
    end
  end

  always_ff @ (posedge clk_axi) begin
    if (rst_axi) begin
      recv_udp_ff <= s_eth_udp_t'('0);
      irq_rx_ff   <= 1'b0;
      irq_tx_ff   <= 1'b0;
      send_pkt_ff <= 1'b0;
    end
    else begin
      recv_udp_ff <= next_recv;
      irq_rx_ff   <= next_rx_irq;
      irq_tx_ff   <= next_tx_irq;
      send_pkt_ff <= next_send_pkt;
    end
  end
endmodule

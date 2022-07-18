/**
 * File              : tb_eth.sv
 * License           : MIT license <Check LICENSE>
 * Author            : Anderson Ignacio da Silva (aignacio) <anderson@aignacio.com>
 * Date              : 05.06.2022
 * Last Modified Date: 18.07.2022
 */
module tb_eth
  import utils_pkg::*;
(
  input                   clk,
  input                   rst,

  // Slave AXI4 lite - ETH CSR I/F
  input   axi_tid_t       eth_csr_awid,
  input   axi_addr_t      eth_csr_awaddr,
  input   axi_prot_t      eth_csr_awprot,
  input                   eth_csr_awvalid,
  input   axi_data_t      eth_csr_wdata,
  input   axi_wr_strb_t   eth_csr_wstrb,
  input                   eth_csr_wvalid,
  input                   eth_csr_bready,
  input   axi_tid_t       eth_csr_arid,
  input   axi_addr_t      eth_csr_araddr,
  input   axi_prot_t      eth_csr_arprot,
  input                   eth_csr_arvalid,
  input                   eth_csr_rready,

  output                  eth_csr_awready,
  output                  eth_csr_wready,
  output  axi_tid_t       eth_csr_bid,
  output  axi_error_t     eth_csr_bresp,
  output                  eth_csr_bvalid,
  output                  eth_csr_arready,
  output  axi_tid_t       eth_csr_rid,
  output  axi_data_t      eth_csr_rdata,
  output  axi_error_t     eth_csr_rresp,
  output                  eth_csr_rvalid,

  // Slave INFIFO AXI4 I/F
  input   axi_tid_t       eth_infifo_s_awid,
  input   axi_addr_t      eth_infifo_s_awaddr,
  input   axi_alen_t      eth_infifo_s_awlen,
  input   axi_size_t      eth_infifo_s_awsize,
  input   axi_burst_t     eth_infifo_s_awburst,
  input                   eth_infifo_s_awlock,
  input   [3:0]           eth_infifo_s_awcache,
  input   axi_prot_t      eth_infifo_s_awprot,
  input   [3:0]           eth_infifo_s_awqos,
  input   [3:0]           eth_infifo_s_awregion,
  input   axi_user_req_t  eth_infifo_s_awuser,
  input                   eth_infifo_s_awvalid,
  input   axi_data_t      eth_infifo_s_wdata,
  input   axi_wr_strb_t   eth_infifo_s_wstrb,
  input                   eth_infifo_s_wlast,
  input   axi_user_data_t eth_infifo_s_wuser,
  input                   eth_infifo_s_wvalid,
  input                   eth_infifo_s_bready,
  input   axi_tid_t       eth_infifo_s_arid,
  input   axi_addr_t      eth_infifo_s_araddr,
  input   axi_alen_t      eth_infifo_s_arlen,
  input   axi_size_t      eth_infifo_s_arsize,
  input   axi_burst_t     eth_infifo_s_arburst,
  input                   eth_infifo_s_arlock,
  input   [3:0]           eth_infifo_s_arcache,
  input   axi_prot_t      eth_infifo_s_arprot,
  input   [3:0]           eth_infifo_s_arqos,
  input   [3:0]           eth_infifo_s_arregion,
  input   axi_user_req_t  eth_infifo_s_aruser,
  input                   eth_infifo_s_arvalid,
  input                   eth_infifo_s_rready,

  output                  eth_infifo_s_awready,
  output                  eth_infifo_s_wready,
  output  axi_tid_t       eth_infifo_s_bid,
  output  axi_error_t     eth_infifo_s_bresp,
  output  axi_user_rsp_t  eth_infifo_s_buser,
  output                  eth_infifo_s_bvalid,
  output                  eth_infifo_s_arready,
  output  axi_tid_t       eth_infifo_s_rid,
  output  axi_data_t      eth_infifo_s_rdata,
  output  axi_error_t     eth_infifo_s_rresp,
  output                  eth_infifo_s_rlast,
  output  axi_user_data_t eth_infifo_s_ruser,
  output                  eth_infifo_s_rvalid,

  // Slave OUTFIFO AXI4 I/F
  input   axi_tid_t       eth_outfifo_s_awid,
  input   axi_addr_t      eth_outfifo_s_awaddr,
  input   axi_alen_t      eth_outfifo_s_awlen,
  input   axi_size_t      eth_outfifo_s_awsize,
  input   axi_burst_t     eth_outfifo_s_awburst,
  input                   eth_outfifo_s_awlock,
  input   [3:0]           eth_outfifo_s_awcache,
  input   axi_prot_t      eth_outfifo_s_awprot,
  input   [3:0]           eth_outfifo_s_awqos,
  input   [3:0]           eth_outfifo_s_awregion,
  input   axi_user_req_t  eth_outfifo_s_awuser,
  input                   eth_outfifo_s_awvalid,
  input   axi_data_t      eth_outfifo_s_wdata,
  input   axi_wr_strb_t   eth_outfifo_s_wstrb,
  input                   eth_outfifo_s_wlast,
  input   axi_user_data_t eth_outfifo_s_wuser,
  input                   eth_outfifo_s_wvalid,
  input                   eth_outfifo_s_bready,
  input   axi_tid_t       eth_outfifo_s_arid,
  input   axi_addr_t      eth_outfifo_s_araddr,
  input   axi_alen_t      eth_outfifo_s_arlen,
  input   axi_size_t      eth_outfifo_s_arsize,
  input   axi_burst_t     eth_outfifo_s_arburst,
  input                   eth_outfifo_s_arlock,
  input   [3:0]           eth_outfifo_s_arcache,
  input   axi_prot_t      eth_outfifo_s_arprot,
  input   [3:0]           eth_outfifo_s_arqos,
  input   [3:0]           eth_outfifo_s_arregion,
  input   axi_user_req_t  eth_outfifo_s_aruser,
  input                   eth_outfifo_s_arvalid,
  input                   eth_outfifo_s_rready,

  output                  eth_outfifo_s_awready,
  output                  eth_outfifo_s_wready,
  output  axi_tid_t       eth_outfifo_s_bid,
  output  axi_error_t     eth_outfifo_s_bresp,
  output  axi_user_rsp_t  eth_outfifo_s_buser,
  output                  eth_outfifo_s_bvalid,
  output                  eth_outfifo_s_arready,
  output  axi_tid_t       eth_outfifo_s_rid,
  output  axi_data_t      eth_outfifo_s_rdata,
  output  axi_error_t     eth_outfifo_s_rresp,
  output                  eth_outfifo_s_rlast,
  output  axi_user_data_t eth_outfifo_s_ruser,
  output                  eth_outfifo_s_rvalid,

`ifdef ETH_TARGET_FPGA_ARTY
  // Ethernet: 100BASE-T MII
  output  logic           phy_ref_clk, // 25MHz
  input                   phy_rx_clk,
  input   [3:0]           phy_rxd,
  input                   phy_rx_dv,
  input                   phy_rx_er,
  input                   phy_tx_clk,
  output  [3:0]           phy_txd,
  output                  phy_tx_en,
  input                   phy_col,
  input                   phy_crs,
  output  logic           phy_reset_n,
`elsif ETH_TARGET_FPGA_NEXYSV
  // Ethernet: 1000BASE-T RGMII
  input                   phy_rx_clk,
  input   [3:0]           phy_rxd,
  input                   phy_rx_ctl,
  output                  phy_tx_clk,
  output  [3:0]           phy_txd,
  output                  phy_tx_ctl,
  output                  phy_reset_n,
  input                   phy_int_n,
  input                   phy_pme_n,
`endif

  // IRQ
  output                  pkt_recv,
  output                  pkt_sent
);
  s_axil_mosi_t eth_csr_mosi;
  s_axil_miso_t eth_csr_miso;
  s_axi_mosi_t  eth_infifo_mosi;
  s_axi_miso_t  eth_infifo_miso;
  s_axi_mosi_t  eth_outfifo_mosi;
  s_axi_miso_t  eth_outfifo_miso;

  always_comb begin
    // Slave AXI4 lite - ETH CSR I/F
    eth_csr_mosi.awid    = eth_csr_awid;
    eth_csr_mosi.awaddr  = eth_csr_awaddr;
    eth_csr_mosi.awprot  = eth_csr_awprot;
    eth_csr_mosi.awvalid = eth_csr_awvalid;
    eth_csr_mosi.wdata   = eth_csr_wdata;
    eth_csr_mosi.wstrb   = eth_csr_wstrb;
    eth_csr_mosi.wvalid  = eth_csr_wvalid;
    eth_csr_mosi.bready  = eth_csr_bready;
    eth_csr_mosi.arid    = eth_csr_arid;
    eth_csr_mosi.araddr  = eth_csr_araddr;
    eth_csr_mosi.arprot  = eth_csr_arprot;
    eth_csr_mosi.arvalid = eth_csr_arvalid;
    eth_csr_mosi.rready  = eth_csr_rready;

    eth_csr_awready = eth_csr_miso.awready;
    eth_csr_wready  = eth_csr_miso.wready;
    eth_csr_bid     = eth_csr_miso.bid;
    eth_csr_bresp   = eth_csr_miso.bresp;
    eth_csr_bvalid  = eth_csr_miso.bvalid;
    eth_csr_arready = eth_csr_miso.arready;
    eth_csr_rid     = eth_csr_miso.rid;
    eth_csr_rdata   = eth_csr_miso.rdata;
    eth_csr_rresp   = eth_csr_miso.rresp;
    eth_csr_rvalid  = eth_csr_miso.rvalid;

    // Slave INFIFO AXI4 I/F
    eth_infifo_mosi.awid     = eth_infifo_s_awid;
    eth_infifo_mosi.awaddr   = eth_infifo_s_awaddr;
    eth_infifo_mosi.awlen    = eth_infifo_s_awlen;
    eth_infifo_mosi.awsize   = eth_infifo_s_awsize;
    eth_infifo_mosi.awburst  = eth_infifo_s_awburst;
    eth_infifo_mosi.awlock   = eth_infifo_s_awlock;
    eth_infifo_mosi.awcache  = eth_infifo_s_awcache;
    eth_infifo_mosi.awprot   = eth_infifo_s_awprot;
    eth_infifo_mosi.awqos    = eth_infifo_s_awqos;
    eth_infifo_mosi.awregion = eth_infifo_s_awregion;
    eth_infifo_mosi.awuser   = eth_infifo_s_awuser;
    eth_infifo_mosi.awvalid  = eth_infifo_s_awvalid;
    eth_infifo_mosi.wdata    = eth_infifo_s_wdata;
    eth_infifo_mosi.wstrb    = eth_infifo_s_wstrb;
    eth_infifo_mosi.wlast    = eth_infifo_s_wlast;
    eth_infifo_mosi.wuser    = eth_infifo_s_wuser;
    eth_infifo_mosi.wvalid   = eth_infifo_s_wvalid;
    eth_infifo_mosi.bready   = eth_infifo_s_bready;
    eth_infifo_mosi.arid     = eth_infifo_s_arid;
    eth_infifo_mosi.araddr   = eth_infifo_s_araddr;
    eth_infifo_mosi.arlen    = eth_infifo_s_arlen;
    eth_infifo_mosi.arsize   = eth_infifo_s_arsize;
    eth_infifo_mosi.arburst  = eth_infifo_s_arburst;
    eth_infifo_mosi.arlock   = eth_infifo_s_arlock;
    eth_infifo_mosi.arcache  = eth_infifo_s_arcache;
    eth_infifo_mosi.arprot   = eth_infifo_s_arprot;
    eth_infifo_mosi.arqos    = eth_infifo_s_arqos;
    eth_infifo_mosi.arregion = eth_infifo_s_arregion;
    eth_infifo_mosi.aruser   = eth_infifo_s_aruser;
    eth_infifo_mosi.arvalid  = eth_infifo_s_arvalid;
    eth_infifo_mosi.rready   = eth_infifo_s_rready;

    eth_infifo_s_awready = eth_infifo_miso.awready;
    eth_infifo_s_wready  = eth_infifo_miso.wready;
    eth_infifo_s_bid     = eth_infifo_miso.bid;
    eth_infifo_s_bresp   = eth_infifo_miso.bresp;
    eth_infifo_s_buser   = eth_infifo_miso.buser;
    eth_infifo_s_bvalid  = eth_infifo_miso.bvalid;
    eth_infifo_s_arready = eth_infifo_miso.arready;
    eth_infifo_s_rid     = eth_infifo_miso.rid;
    eth_infifo_s_rdata   = eth_infifo_miso.rdata;
    eth_infifo_s_rresp   = eth_infifo_miso.rresp;
    eth_infifo_s_rlast   = eth_infifo_miso.rlast;
    eth_infifo_s_ruser   = eth_infifo_miso.ruser;
    eth_infifo_s_rvalid  = eth_infifo_miso.rvalid;

    // Slave OUTFIFO AXI4 I/F
    eth_outfifo_mosi.awid     = eth_outfifo_s_awid;
    eth_outfifo_mosi.awaddr   = eth_outfifo_s_awaddr;
    eth_outfifo_mosi.awlen    = eth_outfifo_s_awlen;
    eth_outfifo_mosi.awsize   = eth_outfifo_s_awsize;
    eth_outfifo_mosi.awburst  = eth_outfifo_s_awburst;
    eth_outfifo_mosi.awlock   = eth_outfifo_s_awlock;
    eth_outfifo_mosi.awcache  = eth_outfifo_s_awcache;
    eth_outfifo_mosi.awprot   = eth_outfifo_s_awprot;
    eth_outfifo_mosi.awqos    = eth_outfifo_s_awqos;
    eth_outfifo_mosi.awregion = eth_outfifo_s_awregion;
    eth_outfifo_mosi.awuser   = eth_outfifo_s_awuser;
    eth_outfifo_mosi.awvalid  = eth_outfifo_s_awvalid;
    eth_outfifo_mosi.wdata    = eth_outfifo_s_wdata;
    eth_outfifo_mosi.wstrb    = eth_outfifo_s_wstrb;
    eth_outfifo_mosi.wlast    = eth_outfifo_s_wlast;
    eth_outfifo_mosi.wuser    = eth_outfifo_s_wuser;
    eth_outfifo_mosi.wvalid   = eth_outfifo_s_wvalid;
    eth_outfifo_mosi.bready   = eth_outfifo_s_bready;
    eth_outfifo_mosi.arid     = eth_outfifo_s_arid;
    eth_outfifo_mosi.araddr   = eth_outfifo_s_araddr;
    eth_outfifo_mosi.arlen    = eth_outfifo_s_arlen;
    eth_outfifo_mosi.arsize   = eth_outfifo_s_arsize;
    eth_outfifo_mosi.arburst  = eth_outfifo_s_arburst;
    eth_outfifo_mosi.arlock   = eth_outfifo_s_arlock;
    eth_outfifo_mosi.arcache  = eth_outfifo_s_arcache;
    eth_outfifo_mosi.arprot   = eth_outfifo_s_arprot;
    eth_outfifo_mosi.arqos    = eth_outfifo_s_arqos;
    eth_outfifo_mosi.arregion = eth_outfifo_s_arregion;
    eth_outfifo_mosi.aruser   = eth_outfifo_s_aruser;
    eth_outfifo_mosi.arvalid  = eth_outfifo_s_arvalid;
    eth_outfifo_mosi.rready   = eth_outfifo_s_rready;

    eth_outfifo_s_awready = eth_outfifo_miso.awready;
    eth_outfifo_s_wready  = eth_outfifo_miso.wready;
    eth_outfifo_s_bid     = eth_outfifo_miso.bid;
    eth_outfifo_s_bresp   = eth_outfifo_miso.bresp;
    eth_outfifo_s_buser   = eth_outfifo_miso.buser;
    eth_outfifo_s_bvalid  = eth_outfifo_miso.bvalid;
    eth_outfifo_s_arready = eth_outfifo_miso.arready;
    eth_outfifo_s_rid     = eth_outfifo_miso.rid;
    eth_outfifo_s_rdata   = eth_outfifo_miso.rdata;
    eth_outfifo_s_rresp   = eth_outfifo_miso.rresp;
    eth_outfifo_s_rlast   = eth_outfifo_miso.rlast;
    eth_outfifo_s_ruser   = eth_outfifo_miso.ruser;
    eth_outfifo_s_rvalid  = eth_outfifo_miso.rvalid;
  end

  ethernet_wrapper u_eth(
    .clk               (clk),
    .rst               (rst),
    // CSR AXIL I/F
    .eth_csr_mosi_i    (eth_csr_mosi),
    .eth_csr_miso_o    (eth_csr_miso),
    // Slave AXI FIFOs
    .eth_infifo_mosi_i (eth_infifo_mosi),
    .eth_infifo_miso_o (eth_infifo_miso),
    .eth_outfifo_mosi_i(eth_outfifo_mosi),
    .eth_outfifo_miso_o(eth_outfifo_miso),
`ifdef ETH_TARGET_FPGA_ARTY
    // Ethernet: 100BASE-T MII
    .phy_ref_clk       (phy_ref_clk),
    .phy_rx_clk        (phy_rx_clk),
    .phy_rxd           (phy_rxd),
    .phy_rx_dv         (phy_rx_dv),
    .phy_rx_er         (phy_rx_er),
    .phy_tx_clk        (phy_tx_clk),
    .phy_txd           (phy_txd),
    .phy_tx_en         (phy_tx_en),
    .phy_col           (phy_col),
    .phy_crs           (phy_crs),
    .phy_reset_n       (phy_reset_n),
`elsif ETH_TARGET_FPGA_NEXYSV
    // Ethernet: 1000BASE-T RGMII
    .phy_rx_clk        (phy_rx_clk),
    .phy_rxd           (phy_rxd),
    .phy_rx_ctl        (phy_rx_ctl),
    .phy_tx_clk        (phy_tx_clk),
    .phy_txd           (phy_txd),
    .phy_tx_ctl        (phy_tx_ctl),
    .phy_reset_n       (phy_reset_n),
    .phy_int_n         (phy_int_n),
    .phy_pme_n         (phy_pme_n),
`endif
    // IRQ
    .pkt_recv_o        (pkt_recv),
    .pkt_sent_o        (pkt_sent)
  );
endmodule

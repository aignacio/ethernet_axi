/**
 * File              : tb_eth.sv
 * License           : MIT license <Check LICENSE>
 * Author            : Anderson Ignacio da Silva (aignacio) <anderson@aignacio.com>
 * Date              : 05.06.2022
 * Last Modified Date: 05.07.2022
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

  // Slave AXI4 I/F
  input   axi_tid_t       eth_fifo_s_awid,
  input   axi_addr_t      eth_fifo_s_awaddr,
  input   axi_alen_t      eth_fifo_s_awlen,
  input   axi_size_t      eth_fifo_s_awsize,
  input   axi_burst_t     eth_fifo_s_awburst,
  input                   eth_fifo_s_awlock,
  input   [3:0]           eth_fifo_s_awcache,
  input   axi_prot_t      eth_fifo_s_awprot,
  input   [3:0]           eth_fifo_s_awqos,
  input   [3:0]           eth_fifo_s_awregion,
  input   axi_user_req_t  eth_fifo_s_awuser,
  input                   eth_fifo_s_awvalid,
  input   axi_data_t      eth_fifo_s_wdata,
  input   axi_wr_strb_t   eth_fifo_s_wstrb,
  input                   eth_fifo_s_wlast,
  input   axi_user_data_t eth_fifo_s_wuser,
  input                   eth_fifo_s_wvalid,
  input                   eth_fifo_s_bready,
  input   axi_tid_t       eth_fifo_s_arid,
  input   axi_addr_t      eth_fifo_s_araddr,
  input   axi_alen_t      eth_fifo_s_arlen,
  input   axi_size_t      eth_fifo_s_arsize,
  input   axi_burst_t     eth_fifo_s_arburst,
  input                   eth_fifo_s_arlock,
  input   [3:0]           eth_fifo_s_arcache,
  input   axi_prot_t      eth_fifo_s_arprot,
  input   [3:0]           eth_fifo_s_arqos,
  input   [3:0]           eth_fifo_s_arregion,
  input   axi_user_req_t  eth_fifo_s_aruser,
  input                   eth_fifo_s_arvalid,
  input                   eth_fifo_s_rready,

  output                  eth_fifo_s_awready,
  output                  eth_fifo_s_wready,
  output  axi_tid_t       eth_fifo_s_bid,
  output  axi_error_t     eth_fifo_s_bresp,
  output  axi_user_rsp_t  eth_fifo_s_buser,
  output                  eth_fifo_s_bvalid,
  output                  eth_fifo_s_arready,
  output  axi_tid_t       eth_fifo_s_rid,
  output  axi_data_t      eth_fifo_s_rdata,
  output  axi_error_t     eth_fifo_s_rresp,
  output                  eth_fifo_s_rlast,
  output  axi_user_data_t eth_fifo_s_ruser,
  output                  eth_fifo_s_rvalid,

  // Ethernet: 100BASE-T MII
  output                  phy_ref_clk,
  input                   phy_rx_clk,
  input   [3:0]           phy_rxd,
  input                   phy_rx_dv,
  input                   phy_rx_er,
  input                   phy_tx_clk,
  output  [3:0]           phy_txd,
  output                  phy_tx_en,
  input                   phy_col,
  input                   phy_crs,
  output                  phy_reset_n,

  // IRQ
  output                  pkt_recv
);
  s_axil_mosi_t eth_csr_mosi;
  s_axil_miso_t eth_csr_miso;
  s_axi_mosi_t  eth_fifo_mosi;
  s_axi_miso_t  eth_fifo_miso;

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

    // Slave AXI4 I/F
    eth_fifo_mosi.awid     = eth_fifo_s_awid;
    eth_fifo_mosi.awaddr   = eth_fifo_s_awaddr;
    eth_fifo_mosi.awlen    = eth_fifo_s_awlen;
    eth_fifo_mosi.awsize   = eth_fifo_s_awsize;
    eth_fifo_mosi.awburst  = eth_fifo_s_awburst;
    eth_fifo_mosi.awlock   = eth_fifo_s_awlock;
    eth_fifo_mosi.awcache  = eth_fifo_s_awcache;
    eth_fifo_mosi.awprot   = eth_fifo_s_awprot;
    eth_fifo_mosi.awqos    = eth_fifo_s_awqos;
    eth_fifo_mosi.awregion = eth_fifo_s_awregion;
    eth_fifo_mosi.awuser   = eth_fifo_s_awuser;
    eth_fifo_mosi.awvalid  = eth_fifo_s_awvalid;
    eth_fifo_mosi.wdata    = eth_fifo_s_wdata;
    eth_fifo_mosi.wstrb    = eth_fifo_s_wstrb;
    eth_fifo_mosi.wlast    = eth_fifo_s_wlast;
    eth_fifo_mosi.wuser    = eth_fifo_s_wuser;
    eth_fifo_mosi.wvalid   = eth_fifo_s_wvalid;
    eth_fifo_mosi.bready   = eth_fifo_s_bready;
    eth_fifo_mosi.arid     = eth_fifo_s_arid;
    eth_fifo_mosi.araddr   = eth_fifo_s_araddr;
    eth_fifo_mosi.arlen    = eth_fifo_s_arlen;
    eth_fifo_mosi.arsize   = eth_fifo_s_arsize;
    eth_fifo_mosi.arburst  = eth_fifo_s_arburst;
    eth_fifo_mosi.arlock   = eth_fifo_s_arlock;
    eth_fifo_mosi.arcache  = eth_fifo_s_arcache;
    eth_fifo_mosi.arprot   = eth_fifo_s_arprot;
    eth_fifo_mosi.arqos    = eth_fifo_s_arqos;
    eth_fifo_mosi.arregion = eth_fifo_s_arregion;
    eth_fifo_mosi.aruser   = eth_fifo_s_aruser;
    eth_fifo_mosi.arvalid  = eth_fifo_s_arvalid;
    eth_fifo_mosi.rready   = eth_fifo_s_rready;

    eth_fifo_s_awready = eth_fifo_miso.awready;
    eth_fifo_s_wready  = eth_fifo_miso.wready;
    eth_fifo_s_bid     = eth_fifo_miso.bid;
    eth_fifo_s_bresp   = eth_fifo_miso.bresp;
    eth_fifo_s_buser   = eth_fifo_miso.buser;
    eth_fifo_s_bvalid  = eth_fifo_miso.bvalid;
    eth_fifo_s_arready = eth_fifo_miso.arready;
    eth_fifo_s_rid     = eth_fifo_miso.rid;
    eth_fifo_s_rdata   = eth_fifo_miso.rdata;
    eth_fifo_s_rresp   = eth_fifo_miso.rresp;
    eth_fifo_s_rlast   = eth_fifo_miso.rlast;
    eth_fifo_s_ruser   = eth_fifo_miso.ruser;
    eth_fifo_s_rvalid  = eth_fifo_miso.rvalid;
  end

  ethernet_wrapper u_eth(
    .clk             (clk),
    .rst             (rst),
    // CSR AXIL I/F
    .eth_csr_mosi_i  (eth_csr_mosi),
    .eth_csr_miso_o  (eth_csr_miso),
    // Slave AXI FIFO
    .eth_fifo_mosi_i (eth_fifo_mosi),
    .eth_fifo_miso_o (eth_fifo_miso),
    // Ethernet: 100BASE-T MII
    .phy_ref_clk     (phy_ref_clk),
    .phy_rx_clk      (phy_rx_clk),
    .phy_rxd         (phy_rxd),
    .phy_rx_dv       (phy_rx_dv),
    .phy_rx_er       (phy_rx_er),
    .phy_tx_clk      (phy_tx_clk),
    .phy_txd         (phy_txd),
    .phy_tx_en       (phy_tx_en),
    .phy_col         (phy_col),
    .phy_crs         (phy_crs),
    .phy_reset_n     (phy_reset_n),
    .pkt_recv_o      (pkt_recv)
  );
endmodule

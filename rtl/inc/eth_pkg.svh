`ifndef _ETH_PKG_
`define _ETH_PKG_
  typedef logic [47:0] mac_addr_t;
  typedef logic [31:0] ip_addr_t;
  typedef logic [15:0] udp_length_t;
  typedef logic [31:0] subnet_mask_t;

  typedef struct packed {
    mac_addr_t    mac;
    ip_addr_t     ip;
    ip_addr_t     gateway;
    subnet_mask_t subnet_mask;
  } s_eth_cfg_t;

  typedef struct packed {
    mac_addr_t    mac;
    ip_addr_t     ip;
    udp_length_t  length;
  } s_eth_udp_t;

  localparam ARP_CACHE_ADDR_WIDTH            = 9;
  localparam ARP_REQUEST_RETRY_COUNT         = 4;
  localparam ARP_REQUEST_RETRY_INTERVAL      = 125000000*2;
  localparam ARP_REQUEST_TIMEOUT             = 125000000*30;
  localparam UDP_CHECKSUM_GEN_ENABLE         = 1;
  localparam UDP_CHECKSUM_PAYLOAD_FIFO_DEPTH = 2048;
  localparam UDP_CHECKSUM_HEADER_FIFO_DEPTH  = 8;
`endif

package eth_csr_ral_pkg;
  import uvm_pkg::*;
  import rggen_ral_pkg::*;
  `include "uvm_macros.svh"
  `include "rggen_ral_macros.svh"
  class eth_mac_low_reg_model extends rggen_ral_reg;
    rand rggen_ral_field eth_mac_low;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(eth_mac_low, 0, 24, "RW", 0, 24'hdef061, 1, -1, "")
    endfunction
  endclass
  class eth_mac_high_reg_model extends rggen_ral_reg;
    rand rggen_ral_field eth_mac_high;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(eth_mac_high, 0, 24, "RW", 0, 24'h1dee69, 1, -1, "")
    endfunction
  endclass
  class eth_ip_reg_model extends rggen_ral_reg;
    rand rggen_ral_field eth_ip;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(eth_ip, 0, 32, "RW", 0, 32'hc0a800d3, 1, -1, "")
    endfunction
  endclass
  class gateway_ip_reg_model extends rggen_ral_reg;
    rand rggen_ral_field gateway_ip;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(gateway_ip, 0, 32, "RW", 0, 32'hc0a80001, 1, -1, "")
    endfunction
  endclass
  class subnet_mask_reg_model extends rggen_ral_reg;
    rand rggen_ral_field subnet_mask;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(subnet_mask, 0, 32, "RW", 0, 32'hffffff00, 1, -1, "")
    endfunction
  endclass
  class recv_mac_low_reg_model extends rggen_ral_reg;
    rand rggen_ral_field recv_mac_low;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(recv_mac_low, 0, 24, "RO", 1, 24'h000000, 1, -1, "")
    endfunction
  endclass
  class recv_mac_high_reg_model extends rggen_ral_reg;
    rand rggen_ral_field recv_mac_high;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(recv_mac_high, 0, 24, "RO", 1, 24'h000000, 1, -1, "")
    endfunction
  endclass
  class recv_ip_reg_model extends rggen_ral_reg;
    rand rggen_ral_field recv_ip;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(recv_ip, 0, 32, "RO", 1, 32'h00000000, 1, -1, "")
    endfunction
  endclass
  class recv_udp_length_reg_model extends rggen_ral_reg;
    rand rggen_ral_field recv_udp_length;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(recv_udp_length, 0, 16, "RO", 1, 16'h0000, 1, -1, "")
    endfunction
  endclass
  class recv_udp_src_port_reg_model extends rggen_ral_reg;
    rand rggen_ral_field recv_udp_src_port;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(recv_udp_src_port, 0, 16, "RO", 1, 16'h0000, 1, -1, "")
    endfunction
  endclass
  class recv_udp_dst_port_reg_model extends rggen_ral_reg;
    rand rggen_ral_field recv_udp_dst_port;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(recv_udp_dst_port, 0, 16, "RO", 1, 16'h0000, 1, -1, "")
    endfunction
  endclass
  class recv_fifo_clear_reg_model extends rggen_ral_reg;
    rand rggen_ral_field recv_fifo_clear;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(recv_fifo_clear, 0, 1, "WO", 0, 1'h0, 1, -1, "")
    endfunction
  endclass
  class recv_fifo_rd_ptr_reg_model extends rggen_ral_reg;
    rand rggen_ral_field recv_fifo_rd_ptr;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(recv_fifo_rd_ptr, 0, 32, "RO", 1, 32'h00000000, 1, -1, "")
    endfunction
  endclass
  class recv_fifo_wr_ptr_reg_model extends rggen_ral_reg;
    rand rggen_ral_field recv_fifo_wr_ptr;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(recv_fifo_wr_ptr, 0, 32, "RO", 1, 32'h00000000, 1, -1, "")
    endfunction
  endclass
  class recv_fifo_full_reg_model extends rggen_ral_reg;
    rand rggen_ral_field recv_fifo_full;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(recv_fifo_full, 0, 1, "RO", 1, 1'h0, 1, -1, "")
    endfunction
  endclass
  class recv_fifo_empty_reg_model extends rggen_ral_reg;
    rand rggen_ral_field recv_fifo_empty;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(recv_fifo_empty, 0, 32, "RO", 1, 32'h00000000, 1, -1, "")
    endfunction
  endclass
  class send_mac_low_reg_model extends rggen_ral_reg;
    rand rggen_ral_field send_mac_low;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(send_mac_low, 0, 24, "RW", 0, 24'h000000, 1, -1, "")
    endfunction
  endclass
  class send_mac_high_reg_model extends rggen_ral_reg;
    rand rggen_ral_field send_mac_high;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(send_mac_high, 0, 24, "RW", 0, 24'h000000, 1, -1, "")
    endfunction
  endclass
  class send_ip_reg_model extends rggen_ral_reg;
    rand rggen_ral_field send_ip;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(send_ip, 0, 32, "RW", 0, 32'h00000000, 1, -1, "")
    endfunction
  endclass
  class send_udp_length_reg_model extends rggen_ral_reg;
    rand rggen_ral_field send_udp_length;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(send_udp_length, 0, 16, "RW", 0, 16'h0000, 1, -1, "")
    endfunction
  endclass
  class send_src_port_reg_model extends rggen_ral_reg;
    rand rggen_ral_field send_src_port;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(send_src_port, 0, 16, "RW", 0, 16'h0000, 1, -1, "")
    endfunction
  endclass
  class send_dst_port_reg_model extends rggen_ral_reg;
    rand rggen_ral_field send_dst_port;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(send_dst_port, 0, 16, "RW", 0, 16'h0000, 1, -1, "")
    endfunction
  endclass
  class send_fifo_clear_reg_model extends rggen_ral_reg;
    rand rggen_ral_field send_fifo_clear;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(send_fifo_clear, 0, 1, "WO", 0, 1'h0, 1, -1, "")
    endfunction
  endclass
  class send_fifo_rd_ptr_reg_model extends rggen_ral_reg;
    rand rggen_ral_field send_fifo_rd_ptr;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(send_fifo_rd_ptr, 0, 32, "RO", 1, 32'h00000000, 1, -1, "")
    endfunction
  endclass
  class send_fifo_wr_ptr_reg_model extends rggen_ral_reg;
    rand rggen_ral_field send_fifo_wr_ptr;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(send_fifo_wr_ptr, 0, 32, "RO", 1, 32'h00000000, 1, -1, "")
    endfunction
  endclass
  class send_fifo_full_reg_model extends rggen_ral_reg;
    rand rggen_ral_field send_fifo_full;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(send_fifo_full, 0, 1, "RO", 1, 1'h0, 1, -1, "")
    endfunction
  endclass
  class send_fifo_empty_reg_model extends rggen_ral_reg;
    rand rggen_ral_field send_fifo_empty;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(send_fifo_empty, 0, 32, "RO", 1, 32'h00000000, 1, -1, "")
    endfunction
  endclass
  class send_pkt_reg_model extends rggen_ral_reg;
    rand rggen_ral_field send_pkt;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(send_pkt, 0, 1, "WO", 0, 1'h0, 1, -1, "")
    endfunction
  endclass
  class clear_irq_reg_model extends rggen_ral_reg;
    rand rggen_ral_field clear_irq;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(clear_irq, 0, 1, "WO", 0, 1'h0, 1, -1, "")
    endfunction
  endclass
  class clear_arp_reg_model extends rggen_ral_reg;
    rand rggen_ral_field clear_arp;
    function new(string name);
      super.new(name, 32, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(clear_arp, 0, 1, "WO", 0, 1'h0, 1, -1, "")
    endfunction
  endclass
  class eth_csr_block_model extends rggen_ral_block;
    rand eth_mac_low_reg_model eth_mac_low;
    rand eth_mac_high_reg_model eth_mac_high;
    rand eth_ip_reg_model eth_ip;
    rand gateway_ip_reg_model gateway_ip;
    rand subnet_mask_reg_model subnet_mask;
    rand recv_mac_low_reg_model recv_mac_low;
    rand recv_mac_high_reg_model recv_mac_high;
    rand recv_ip_reg_model recv_ip;
    rand recv_udp_length_reg_model recv_udp_length;
    rand recv_udp_src_port_reg_model recv_udp_src_port;
    rand recv_udp_dst_port_reg_model recv_udp_dst_port;
    rand recv_fifo_clear_reg_model recv_fifo_clear;
    rand recv_fifo_rd_ptr_reg_model recv_fifo_rd_ptr;
    rand recv_fifo_wr_ptr_reg_model recv_fifo_wr_ptr;
    rand recv_fifo_full_reg_model recv_fifo_full;
    rand recv_fifo_empty_reg_model recv_fifo_empty;
    rand send_mac_low_reg_model send_mac_low;
    rand send_mac_high_reg_model send_mac_high;
    rand send_ip_reg_model send_ip;
    rand send_udp_length_reg_model send_udp_length;
    rand send_src_port_reg_model send_src_port;
    rand send_dst_port_reg_model send_dst_port;
    rand send_fifo_clear_reg_model send_fifo_clear;
    rand send_fifo_rd_ptr_reg_model send_fifo_rd_ptr;
    rand send_fifo_wr_ptr_reg_model send_fifo_wr_ptr;
    rand send_fifo_full_reg_model send_fifo_full;
    rand send_fifo_empty_reg_model send_fifo_empty;
    rand send_pkt_reg_model send_pkt;
    rand clear_irq_reg_model clear_irq;
    rand clear_arp_reg_model clear_arp;
    function new(string name);
      super.new(name, 4, 0);
    endfunction
    function void build();
      `rggen_ral_create_reg(eth_mac_low, '{}, 8'h00, "RW", "g_eth_mac_low.u_register")
      `rggen_ral_create_reg(eth_mac_high, '{}, 8'h04, "RW", "g_eth_mac_high.u_register")
      `rggen_ral_create_reg(eth_ip, '{}, 8'h08, "RW", "g_eth_ip.u_register")
      `rggen_ral_create_reg(gateway_ip, '{}, 8'h0c, "RW", "g_gateway_ip.u_register")
      `rggen_ral_create_reg(subnet_mask, '{}, 8'h10, "RW", "g_subnet_mask.u_register")
      `rggen_ral_create_reg(recv_mac_low, '{}, 8'h14, "RO", "g_recv_mac_low.u_register")
      `rggen_ral_create_reg(recv_mac_high, '{}, 8'h18, "RO", "g_recv_mac_high.u_register")
      `rggen_ral_create_reg(recv_ip, '{}, 8'h1c, "RO", "g_recv_ip.u_register")
      `rggen_ral_create_reg(recv_udp_length, '{}, 8'h20, "RO", "g_recv_udp_length.u_register")
      `rggen_ral_create_reg(recv_udp_src_port, '{}, 8'h24, "RO", "g_recv_udp_src_port.u_register")
      `rggen_ral_create_reg(recv_udp_dst_port, '{}, 8'h28, "RO", "g_recv_udp_dst_port.u_register")
      `rggen_ral_create_reg(recv_fifo_clear, '{}, 8'h2c, "WO", "g_recv_fifo_clear.u_register")
      `rggen_ral_create_reg(recv_fifo_rd_ptr, '{}, 8'h30, "RO", "g_recv_fifo_rd_ptr.u_register")
      `rggen_ral_create_reg(recv_fifo_wr_ptr, '{}, 8'h34, "RO", "g_recv_fifo_wr_ptr.u_register")
      `rggen_ral_create_reg(recv_fifo_full, '{}, 8'h38, "RO", "g_recv_fifo_full.u_register")
      `rggen_ral_create_reg(recv_fifo_empty, '{}, 8'h3c, "RO", "g_recv_fifo_empty.u_register")
      `rggen_ral_create_reg(send_mac_low, '{}, 8'h40, "RW", "g_send_mac_low.u_register")
      `rggen_ral_create_reg(send_mac_high, '{}, 8'h44, "RW", "g_send_mac_high.u_register")
      `rggen_ral_create_reg(send_ip, '{}, 8'h48, "RW", "g_send_ip.u_register")
      `rggen_ral_create_reg(send_udp_length, '{}, 8'h4c, "RW", "g_send_udp_length.u_register")
      `rggen_ral_create_reg(send_src_port, '{}, 8'h50, "RW", "g_send_src_port.u_register")
      `rggen_ral_create_reg(send_dst_port, '{}, 8'h54, "RW", "g_send_dst_port.u_register")
      `rggen_ral_create_reg(send_fifo_clear, '{}, 8'h58, "WO", "g_send_fifo_clear.u_register")
      `rggen_ral_create_reg(send_fifo_rd_ptr, '{}, 8'h5c, "RO", "g_send_fifo_rd_ptr.u_register")
      `rggen_ral_create_reg(send_fifo_wr_ptr, '{}, 8'h60, "RO", "g_send_fifo_wr_ptr.u_register")
      `rggen_ral_create_reg(send_fifo_full, '{}, 8'h64, "RO", "g_send_fifo_full.u_register")
      `rggen_ral_create_reg(send_fifo_empty, '{}, 8'h68, "RO", "g_send_fifo_empty.u_register")
      `rggen_ral_create_reg(send_pkt, '{}, 8'h6c, "WO", "g_send_pkt.u_register")
      `rggen_ral_create_reg(clear_irq, '{}, 8'h70, "WO", "g_clear_irq.u_register")
      `rggen_ral_create_reg(clear_arp, '{}, 8'h74, "WO", "g_clear_arp.u_register")
    endfunction
  endclass
endpackage

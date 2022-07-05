package eth_csr_ral_pkg;
  import uvm_pkg::*;
  import rggen_ral_pkg::*;
  `include "uvm_macros.svh"
  `include "rggen_ral_macros.svh"
  class eth_mac_reg_model extends rggen_ral_reg;
    rand rggen_ral_field eth_mac;
    function new(string name);
      super.new(name, 64, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(eth_mac, 0, 48, "RW", 0, 48'h1dee69def061, 1, -1, "")
    endfunction
  endclass
  class eth_ip_reg_model extends rggen_ral_reg;
    rand rggen_ral_field eth_ip;
    function new(string name);
      super.new(name, 64, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(eth_ip, 0, 32, "RW", 0, 32'hc0a800d3, 1, -1, "")
    endfunction
  endclass
  class gateway_ip_reg_model extends rggen_ral_reg;
    rand rggen_ral_field gateway_ip;
    function new(string name);
      super.new(name, 64, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(gateway_ip, 0, 32, "RW", 0, 32'hc0a80001, 1, -1, "")
    endfunction
  endclass
  class subnet_mask_reg_model extends rggen_ral_reg;
    rand rggen_ral_field subnet_mask;
    function new(string name);
      super.new(name, 64, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(subnet_mask, 0, 32, "RW", 0, 32'hffffff00, 1, -1, "")
    endfunction
  endclass
  class recv_mac_reg_model extends rggen_ral_reg;
    rand rggen_ral_field recv_mac;
    function new(string name);
      super.new(name, 64, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(recv_mac, 0, 48, "RO", 1, 48'h000000000000, 1, -1, "")
    endfunction
  endclass
  class recv_ip_reg_model extends rggen_ral_reg;
    rand rggen_ral_field recv_ip;
    function new(string name);
      super.new(name, 64, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(recv_ip, 0, 32, "RO", 1, 32'h00000000, 1, -1, "")
    endfunction
  endclass
  class recv_udp_length_reg_model extends rggen_ral_reg;
    rand rggen_ral_field recv_udp_length;
    function new(string name);
      super.new(name, 64, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(recv_udp_length, 0, 16, "RO", 1, 16'h0000, 1, -1, "")
    endfunction
  endclass
  class send_mac_reg_model extends rggen_ral_reg;
    rand rggen_ral_field send_mac;
    function new(string name);
      super.new(name, 64, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(send_mac, 0, 48, "RW", 0, 48'h000000000000, 1, -1, "")
    endfunction
  endclass
  class send_ip_reg_model extends rggen_ral_reg;
    rand rggen_ral_field send_ip;
    function new(string name);
      super.new(name, 64, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(send_ip, 0, 32, "RW", 0, 32'h00000000, 1, -1, "")
    endfunction
  endclass
  class send_udp_length_reg_model extends rggen_ral_reg;
    rand rggen_ral_field send_udp_length;
    function new(string name);
      super.new(name, 64, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(send_udp_length, 0, 16, "RW", 0, 16'h0000, 1, -1, "")
    endfunction
  endclass
  class send_pkt_reg_model extends rggen_ral_reg;
    rand rggen_ral_field send_pkt;
    function new(string name);
      super.new(name, 64, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(send_pkt, 0, 1, "RW", 0, 1'h0, 1, -1, "")
    endfunction
  endclass
  class clear_irq_reg_model extends rggen_ral_reg;
    rand rggen_ral_field clear_irq;
    function new(string name);
      super.new(name, 64, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(clear_irq, 0, 1, "RW", 0, 1'h0, 1, -1, "")
    endfunction
  endclass
  class clear_arp_reg_model extends rggen_ral_reg;
    rand rggen_ral_field clear_arp;
    function new(string name);
      super.new(name, 64, 0);
    endfunction
    function void build();
      `rggen_ral_create_field(clear_arp, 0, 1, "RW", 0, 1'h0, 1, -1, "")
    endfunction
  endclass
  class eth_csr_block_model extends rggen_ral_block;
    rand eth_mac_reg_model eth_mac;
    rand eth_ip_reg_model eth_ip;
    rand gateway_ip_reg_model gateway_ip;
    rand subnet_mask_reg_model subnet_mask;
    rand recv_mac_reg_model recv_mac;
    rand recv_ip_reg_model recv_ip;
    rand recv_udp_length_reg_model recv_udp_length;
    rand send_mac_reg_model send_mac;
    rand send_ip_reg_model send_ip;
    rand send_udp_length_reg_model send_udp_length;
    rand send_pkt_reg_model send_pkt;
    rand clear_irq_reg_model clear_irq;
    rand clear_arp_reg_model clear_arp;
    function new(string name);
      super.new(name, 8, 0);
    endfunction
    function void build();
      `rggen_ral_create_reg(eth_mac, '{}, 8'h00, "RW", "g_eth_mac.u_register")
      `rggen_ral_create_reg(eth_ip, '{}, 8'h08, "RW", "g_eth_ip.u_register")
      `rggen_ral_create_reg(gateway_ip, '{}, 8'h10, "RW", "g_gateway_ip.u_register")
      `rggen_ral_create_reg(subnet_mask, '{}, 8'h18, "RW", "g_subnet_mask.u_register")
      `rggen_ral_create_reg(recv_mac, '{}, 8'h20, "RO", "g_recv_mac.u_register")
      `rggen_ral_create_reg(recv_ip, '{}, 8'h28, "RO", "g_recv_ip.u_register")
      `rggen_ral_create_reg(recv_udp_length, '{}, 8'h30, "RO", "g_recv_udp_length.u_register")
      `rggen_ral_create_reg(send_mac, '{}, 8'h38, "RW", "g_send_mac.u_register")
      `rggen_ral_create_reg(send_ip, '{}, 8'h40, "RW", "g_send_ip.u_register")
      `rggen_ral_create_reg(send_udp_length, '{}, 8'h48, "RW", "g_send_udp_length.u_register")
      `rggen_ral_create_reg(send_pkt, '{}, 8'h50, "RW", "g_send_pkt.u_register")
      `rggen_ral_create_reg(clear_irq, '{}, 8'h58, "RW", "g_clear_irq.u_register")
      `rggen_ral_create_reg(clear_arp, '{}, 8'h60, "RW", "g_clear_arp.u_register")
    endfunction
  endclass
endpackage

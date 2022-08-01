## eth_csr

* byte_size
    * 256

|name|offset_address|
|:--|:--|
|[eth_mac_low](#eth_csr-eth_mac_low)|0x00|
|[eth_mac_high](#eth_csr-eth_mac_high)|0x04|
|[eth_ip](#eth_csr-eth_ip)|0x08|
|[gateway_ip](#eth_csr-gateway_ip)|0x0c|
|[subnet_mask](#eth_csr-subnet_mask)|0x10|
|[recv_mac_low](#eth_csr-recv_mac_low)|0x14|
|[recv_mac_high](#eth_csr-recv_mac_high)|0x18|
|[recv_ip](#eth_csr-recv_ip)|0x1c|
|[recv_udp_length](#eth_csr-recv_udp_length)|0x20|
|[recv_udp_src_port](#eth_csr-recv_udp_src_port)|0x24|
|[recv_udp_dst_port](#eth_csr-recv_udp_dst_port)|0x28|
|[recv_fifo_clear](#eth_csr-recv_fifo_clear)|0x2c|
|[recv_fifo_rd_ptr](#eth_csr-recv_fifo_rd_ptr)|0x30|
|[recv_fifo_wr_ptr](#eth_csr-recv_fifo_wr_ptr)|0x34|
|[recv_fifo_full](#eth_csr-recv_fifo_full)|0x38|
|[recv_fifo_empty](#eth_csr-recv_fifo_empty)|0x3c|
|[send_mac_low](#eth_csr-send_mac_low)|0x40|
|[send_mac_high](#eth_csr-send_mac_high)|0x44|
|[send_ip](#eth_csr-send_ip)|0x48|
|[send_udp_length](#eth_csr-send_udp_length)|0x4c|
|[send_src_port](#eth_csr-send_src_port)|0x50|
|[send_dst_port](#eth_csr-send_dst_port)|0x54|
|[send_fifo_clear](#eth_csr-send_fifo_clear)|0x58|
|[send_fifo_rd_ptr](#eth_csr-send_fifo_rd_ptr)|0x5c|
|[send_fifo_wr_ptr](#eth_csr-send_fifo_wr_ptr)|0x60|
|[send_fifo_full](#eth_csr-send_fifo_full)|0x64|
|[send_fifo_empty](#eth_csr-send_fifo_empty)|0x68|
|[send_pkt](#eth_csr-send_pkt)|0x6c|
|[clear_irq](#eth_csr-clear_irq)|0x70|
|[clear_arp](#eth_csr-clear_arp)|0x74|
|[irq_pkt_recv](#eth_csr-irq_pkt_recv)|0x78|
|[irq_pkt_sent](#eth_csr-irq_pkt_sent)|0x7c|
|[irq_pkt_recv_full](#eth_csr-irq_pkt_recv_full)|0x80|
|[recv_set_port_en](#eth_csr-recv_set_port_en)|0x84|
|[recv_set_port](#eth_csr-recv_set_port)|0x88|

### <div id="eth_csr-eth_mac_low"></div>eth_mac_low

* offset_address
    * 0x00
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|eth_mac_low|[23:0]|rw|0xdef061||Ethernet MAC address - 3x LSB|

### <div id="eth_csr-eth_mac_high"></div>eth_mac_high

* offset_address
    * 0x04
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|eth_mac_high|[23:0]|rw|0x1dee69||Ethernet MAC address - 3x MSB|

### <div id="eth_csr-eth_ip"></div>eth_ip

* offset_address
    * 0x08
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|eth_ip|[31:0]|rw|0xc0a800d3||Ethernet IP Address - Def. 192.168.0.211|

### <div id="eth_csr-gateway_ip"></div>gateway_ip

* offset_address
    * 0x0c
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|gateway_ip|[31:0]|rw|0xc0a80001||Gateway IP - Def. 192.168.0.1|

### <div id="eth_csr-subnet_mask"></div>subnet_mask

* offset_address
    * 0x10
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|subnet_mask|[31:0]|rw|0xffffff00||Network subnet mask - Def. 255.255.255.0|

### <div id="eth_csr-recv_mac_low"></div>recv_mac_low

* offset_address
    * 0x14
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|recv_mac_low|[23:0]|ro|0x000000||Received MAC addr - 3x LSB|

### <div id="eth_csr-recv_mac_high"></div>recv_mac_high

* offset_address
    * 0x18
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|recv_mac_high|[23:0]|ro|0x000000||Received MAC addr- 3x MSB|

### <div id="eth_csr-recv_ip"></div>recv_ip

* offset_address
    * 0x1c
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|recv_ip|[31:0]|ro|0x00000000||Received IP addr|

### <div id="eth_csr-recv_udp_length"></div>recv_udp_length

* offset_address
    * 0x20
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|recv_udp_length|[15:0]|ro|0x0000||Received UDP length|

### <div id="eth_csr-recv_udp_src_port"></div>recv_udp_src_port

* offset_address
    * 0x24
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|recv_udp_src_port|[15:0]|ro|0x0000||Received UDP src port|

### <div id="eth_csr-recv_udp_dst_port"></div>recv_udp_dst_port

* offset_address
    * 0x28
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|recv_udp_dst_port|[15:0]|ro|0x0000||Received UDP dest port|

### <div id="eth_csr-recv_fifo_clear"></div>recv_fifo_clear

* offset_address
    * 0x2c
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|recv_fifo_clear|[0]|wotrg|0x0||Clear FIFO ptrs|

### <div id="eth_csr-recv_fifo_rd_ptr"></div>recv_fifo_rd_ptr

* offset_address
    * 0x30
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|recv_fifo_rd_ptr|[31:0]|ro|0x00000000||InFIFO Read ptr|

### <div id="eth_csr-recv_fifo_wr_ptr"></div>recv_fifo_wr_ptr

* offset_address
    * 0x34
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|recv_fifo_wr_ptr|[31:0]|ro|0x00000000||InFIFO Write ptr|

### <div id="eth_csr-recv_fifo_full"></div>recv_fifo_full

* offset_address
    * 0x38
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|recv_fifo_full|[0]|ro|0x0||InFIFO Full status|

### <div id="eth_csr-recv_fifo_empty"></div>recv_fifo_empty

* offset_address
    * 0x3c
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|recv_fifo_empty|[0]|ro|0x0||InFIFO Empty status|

### <div id="eth_csr-send_mac_low"></div>send_mac_low

* offset_address
    * 0x40
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_mac_low|[23:0]|rw|0x000000||Send MAC addr - 3x LSB|

### <div id="eth_csr-send_mac_high"></div>send_mac_high

* offset_address
    * 0x44
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_mac_high|[23:0]|rw|0x000000||Send MAC addr - 3x MSB|

### <div id="eth_csr-send_ip"></div>send_ip

* offset_address
    * 0x48
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_ip|[31:0]|rw|0x00000000||Send IP addr|

### <div id="eth_csr-send_udp_length"></div>send_udp_length

* offset_address
    * 0x4c
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_udp_length|[15:0]|rw|0x0000||Send UDP length|

### <div id="eth_csr-send_src_port"></div>send_src_port

* offset_address
    * 0x50
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_src_port|[15:0]|rw|0x0000||Send src port|

### <div id="eth_csr-send_dst_port"></div>send_dst_port

* offset_address
    * 0x54
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_dst_port|[15:0]|rw|0x0000||Send dst port|

### <div id="eth_csr-send_fifo_clear"></div>send_fifo_clear

* offset_address
    * 0x58
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_fifo_clear|[0]|wotrg|0x0||Clear FIFO ptrs|

### <div id="eth_csr-send_fifo_rd_ptr"></div>send_fifo_rd_ptr

* offset_address
    * 0x5c
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_fifo_rd_ptr|[31:0]|ro|0x00000000||OutFIFO Read ptr|

### <div id="eth_csr-send_fifo_wr_ptr"></div>send_fifo_wr_ptr

* offset_address
    * 0x60
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_fifo_wr_ptr|[31:0]|ro|0x00000000||OutFIFO Write ptr|

### <div id="eth_csr-send_fifo_full"></div>send_fifo_full

* offset_address
    * 0x64
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_fifo_full|[0]|ro|0x0||OutFIFO Full status|

### <div id="eth_csr-send_fifo_empty"></div>send_fifo_empty

* offset_address
    * 0x68
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_fifo_empty|[0]|ro|0x0||OutFIFO Empty status|

### <div id="eth_csr-send_pkt"></div>send_pkt

* offset_address
    * 0x6c
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_pkt|[0]|wotrg|0x0||Send pkt|

### <div id="eth_csr-clear_irq"></div>clear_irq

* offset_address
    * 0x70
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|clear_irq|[0]|wotrg|0x0||Clear IRQ recv/sent pkt|

### <div id="eth_csr-clear_arp"></div>clear_arp

* offset_address
    * 0x74
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|clear_arp|[0]|wotrg|0x0||Clear ARP table|

### <div id="eth_csr-irq_pkt_recv"></div>irq_pkt_recv

* offset_address
    * 0x78
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|irq_pkt_recv|[0]|ro|0x0||Received pkt IRQ|

### <div id="eth_csr-irq_pkt_sent"></div>irq_pkt_sent

* offset_address
    * 0x7c
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|irq_pkt_sent|[0]|ro|0x0||Pkt sent IRQ|

### <div id="eth_csr-irq_pkt_recv_full"></div>irq_pkt_recv_full

* offset_address
    * 0x80
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|irq_pkt_recv_full|[0]|ro|0x0||Recv FIFO full IRQ|

### <div id="eth_csr-recv_set_port_en"></div>recv_set_port_en

* offset_address
    * 0x84
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|recv_set_port_en|[0]|rw|0x0||Once set, it only recv pkt from specific port|

### <div id="eth_csr-recv_set_port"></div>recv_set_port

* offset_address
    * 0x88
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|recv_set_port|[15:0]|rw|0x0000||Specific port to filter|

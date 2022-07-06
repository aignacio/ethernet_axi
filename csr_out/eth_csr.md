## eth_csr

* byte_size
    * 256

|name|offset_address|
|:--|:--|
|[eth_mac_low](#eth_csr-eth_mac_low)|0x00|
|[eth_mac_high](#eth_csr-eth_mac_high)|0x08|
|[eth_ip](#eth_csr-eth_ip)|0x10|
|[gateway_ip](#eth_csr-gateway_ip)|0x18|
|[subnet_mask](#eth_csr-subnet_mask)|0x20|
|[recv_mac_low](#eth_csr-recv_mac_low)|0x28|
|[recv_mac_high](#eth_csr-recv_mac_high)|0x30|
|[recv_ip](#eth_csr-recv_ip)|0x38|
|[recv_udp_length](#eth_csr-recv_udp_length)|0x40|
|[send_mac_low](#eth_csr-send_mac_low)|0x48|
|[send_mac_high](#eth_csr-send_mac_high)|0x50|
|[send_ip](#eth_csr-send_ip)|0x58|
|[send_udp_length](#eth_csr-send_udp_length)|0x60|
|[send_pkt](#eth_csr-send_pkt)|0x68|
|[clear_irq](#eth_csr-clear_irq)|0x70|
|[clear_arp](#eth_csr-clear_arp)|0x78|

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
    * 0x08
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|eth_mac_high|[23:0]|rw|0x1dee69||Ethernet MAC address - 3x MSB|

### <div id="eth_csr-eth_ip"></div>eth_ip

* offset_address
    * 0x10
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|eth_ip|[31:0]|rw|0xc0a800d3||Ethernet IP Address - Def. 192.168.0.211|

### <div id="eth_csr-gateway_ip"></div>gateway_ip

* offset_address
    * 0x18
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|gateway_ip|[31:0]|rw|0xc0a80001||Gateway IP - Def. 192.168.0.1|

### <div id="eth_csr-subnet_mask"></div>subnet_mask

* offset_address
    * 0x20
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|subnet_mask|[31:0]|rw|0xffffff00||Network subnet mask - Def. 255.255.255.0|

### <div id="eth_csr-recv_mac_low"></div>recv_mac_low

* offset_address
    * 0x28
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|recv_mac_low|[23:0]|ro|0x000000||Received MAC addr - 3x LSB|

### <div id="eth_csr-recv_mac_high"></div>recv_mac_high

* offset_address
    * 0x30
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|recv_mac_high|[23:0]|ro|0x000000||Received MAC addr- 3x MSB|

### <div id="eth_csr-recv_ip"></div>recv_ip

* offset_address
    * 0x38
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|recv_ip|[31:0]|ro|0x00000000||Received IP addr|

### <div id="eth_csr-recv_udp_length"></div>recv_udp_length

* offset_address
    * 0x40
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|recv_udp_length|[15:0]|ro|0x0000||Received UDP length|

### <div id="eth_csr-send_mac_low"></div>send_mac_low

* offset_address
    * 0x48
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_mac_low|[23:0]|rw|0x000000||Send MAC addr - 3x LSB|

### <div id="eth_csr-send_mac_high"></div>send_mac_high

* offset_address
    * 0x50
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_mac_high|[23:0]|rw|0x000000||Send MAC addr - 3x MSB|

### <div id="eth_csr-send_ip"></div>send_ip

* offset_address
    * 0x58
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_ip|[31:0]|rw|0x00000000||Send IP addr|

### <div id="eth_csr-send_udp_length"></div>send_udp_length

* offset_address
    * 0x60
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_udp_length|[15:0]|rw|0x0000||Send UDP length|

### <div id="eth_csr-send_pkt"></div>send_pkt

* offset_address
    * 0x68
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_pkt|[0]|rw|0x0||Send pkt|

### <div id="eth_csr-clear_irq"></div>clear_irq

* offset_address
    * 0x70
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|clear_irq|[0]|wotrg|0x0||Clear IRQ recv pkt|

### <div id="eth_csr-clear_arp"></div>clear_arp

* offset_address
    * 0x78
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|clear_arp|[0]|wotrg|0x0||Clear ARP table|

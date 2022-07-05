## eth_csr

* byte_size
    * 256

|name|offset_address|
|:--|:--|
|[eth_mac](#eth_csr-eth_mac)|0x00|
|[eth_ip](#eth_csr-eth_ip)|0x08|
|[gateway_ip](#eth_csr-gateway_ip)|0x10|
|[subnet_mask](#eth_csr-subnet_mask)|0x18|
|[recv_mac](#eth_csr-recv_mac)|0x20|
|[recv_ip](#eth_csr-recv_ip)|0x28|
|[recv_udp_length](#eth_csr-recv_udp_length)|0x30|
|[send_mac](#eth_csr-send_mac)|0x38|
|[send_ip](#eth_csr-send_ip)|0x40|
|[send_udp_length](#eth_csr-send_udp_length)|0x48|
|[send_pkt](#eth_csr-send_pkt)|0x50|
|[clear_irq](#eth_csr-clear_irq)|0x58|
|[clear_arp](#eth_csr-clear_arp)|0x60|

### <div id="eth_csr-eth_mac"></div>eth_mac

* offset_address
    * 0x00
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|eth_mac|[47:0]|rw|0x1dee69def061||Ethernet MAC address|

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
    * 0x10
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|gateway_ip|[31:0]|rw|0xc0a80001||Gateway IP - Def. 192.168.0.1|

### <div id="eth_csr-subnet_mask"></div>subnet_mask

* offset_address
    * 0x18
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|subnet_mask|[31:0]|rw|0xffffff00||Network subnet mask - Def. 255.255.255.0|

### <div id="eth_csr-recv_mac"></div>recv_mac

* offset_address
    * 0x20
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|recv_mac|[47:0]|ro|0x000000000000||Received MAC addr|

### <div id="eth_csr-recv_ip"></div>recv_ip

* offset_address
    * 0x28
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|recv_ip|[31:0]|ro|0x00000000||Received IP addr|

### <div id="eth_csr-recv_udp_length"></div>recv_udp_length

* offset_address
    * 0x30
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|recv_udp_length|[15:0]|ro|0x0000||Received UDP length|

### <div id="eth_csr-send_mac"></div>send_mac

* offset_address
    * 0x38
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_mac|[47:0]|rw|0x000000000000||Send MAC addr|

### <div id="eth_csr-send_ip"></div>send_ip

* offset_address
    * 0x40
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_ip|[31:0]|rw|0x00000000||Send IP addr|

### <div id="eth_csr-send_udp_length"></div>send_udp_length

* offset_address
    * 0x48
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_udp_length|[15:0]|rw|0x0000||Send UDP length|

### <div id="eth_csr-send_pkt"></div>send_pkt

* offset_address
    * 0x50
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|send_pkt|[0]|rw|0x0||Send pkt|

### <div id="eth_csr-clear_irq"></div>clear_irq

* offset_address
    * 0x58
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|clear_irq|[0]|rw|0x0||Clear IRQ recv pkt|

### <div id="eth_csr-clear_arp"></div>clear_arp

* offset_address
    * 0x60
* type
    * default

|name|bit_assignments|type|initial_value|reference|comment|
|:--|:--|:--|:--|:--|:--|
|clear_arp|[0]|rw|0x0||Clear ARP table|

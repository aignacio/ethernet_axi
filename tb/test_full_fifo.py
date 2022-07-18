#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# File              : test_full_fifo.py
# License           : MIT license <Check LICENSE>
# Author            : Anderson Ignacio da Silva (aignacio) <anderson@aignacio.com>
# Date              : 03.06.2022
# Last Modified Date: 18.07.2022
# Last Modified By  : Anderson Ignacio da Silva (aignacio) <anderson@aignacio.com>
import cocotb
import pytest
import itertools
import os
import logging

from common.constants import cfg_const
from cocotb.regression import TestFactory
from cocotb_test.simulator import run
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, with_timeout, Event, RisingEdge
from cocotbext.axi import AxiBus, AxiLiteBus
from cocotbext.axi import AxiMaster, AxiLiteMaster
from cocotbext.eth import GmiiFrame, MiiPhy, RgmiiPhy
from scapy.layers.l2 import Ether, ARP
from scapy.layers.inet import IP, UDP
from cocotb.result import TestFailure

async def run_test(dut, config_clk="100MHz", idle_inserter=None, backpressure_inserter=None):
    eth_flavor = os.getenv("FLAVOR")

    log = logging.getLogger(f"cocotb.eth")
    await cocotb.start(Clock(dut.clk, *cfg_const.CLK_100MHz).start())
    dut.rst.setimmediatevalue(1)
    await ClockCycles(dut.clk, 3)
    dut.rst.setimmediatevalue(0)
    await cocotb.start(Clock(dut.clk, *cfg_const.CLK_100MHz).start())
    dut.rst.setimmediatevalue(1)
    await ClockCycles(dut.clk, 3)
    dut.rst.setimmediatevalue(0)

    eth_csr_if     = AxiLiteMaster(AxiLiteBus.from_prefix(dut, "eth_csr"), dut.clk, dut.rst)
    eth_infifo_if  = AxiMaster(AxiBus.from_prefix(dut, "eth_infifo_s"), dut.clk, dut.rst)
    eth_outfifo_if = AxiMaster(AxiBus.from_prefix(dut, "eth_outfifo_s"), dut.clk, dut.rst)

    if eth_flavor == 'nexys':
        phy_if = RgmiiPhy(dut.phy_txd, dut.phy_tx_ctl, dut.phy_tx_clk,
                            dut.phy_rxd, dut.phy_rx_ctl, dut.phy_rx_clk, speed=1000e6)
        dut.phy_int_n.setimmediatevalue(1)
        dut.phy_pme_n.setimmediatevalue(1)
    else:
        phy_if = MiiPhy(dut.phy_txd, None, dut.phy_tx_en, dut.phy_tx_clk,
                            dut.phy_rxd, dut.phy_rx_er, dut.phy_rx_dv, dut.phy_rx_clk, speed=100e6)
        dut.phy_crs.setimmediatevalue(0)
        dut.phy_col.setimmediatevalue(0)

    if idle_inserter:
        eth_infifo_if.write_if.aw_channel.set_pause_generator(idle_inserter())
        eth_infifo_if.write_if.w_channel.set_pause_generator(idle_inserter())
        eth_infifo_if.read_if.ar_channel.set_pause_generator(idle_inserter())

        eth_outfifo_if.write_if.aw_channel.set_pause_generator(idle_inserter())
        eth_outfifo_if.write_if.w_channel.set_pause_generator(idle_inserter())
        eth_outfifo_if.read_if.ar_channel.set_pause_generator(idle_inserter())

    if backpressure_inserter:
        eth_infifo_if.write_if.b_channel.set_pause_generator(backpressure_inserter())
        eth_infifo_if.read_if.r_channel.set_pause_generator(backpressure_inserter())

        eth_outfifo_if.write_if.b_channel.set_pause_generator(backpressure_inserter())
        eth_outfifo_if.read_if.r_channel.set_pause_generator(backpressure_inserter())

    #############################
    #    ETH CSR read access    #
    #############################
    eth_csr = {}
    for i in range(30):
        eth_csr['csr_'+str(i)] = i*0x4
    for csr in eth_csr:
        log.info("CSR [Addr: %s]", hex(eth_csr[csr]))
        read = eth_csr_if.init_read(address=eth_csr[csr], length=4)
        await with_timeout(read.wait(), *cfg_const.TIMEOUT_AXI)
        csr_data = int.from_bytes(read.data.data, byteorder='little', signed=False)
        log.info("Data = %s", hex(csr_data))

    log.info("Test UDP RX packet")
    payload = bytes([x % 256 for x in range(1024)])
    eth = Ether(src='5a:51:52:53:54:55', dst='1d:ee:69:de:f0:61')
    ip = IP(src='192.168.0.100', dst='192.168.0.211')
    udp = UDP(sport=5678, dport=1234)
    test_pkt = eth / ip / udp / payload
    test_frame = GmiiFrame.from_payload(test_pkt.build(), tx_complete=Event())
    await phy_if.rx.send(test_frame)
    await test_frame.tx_complete.wait()
    timeout_cnt = 0
    while int(dut.pkt_recv) == 0:
       await RisingEdge(dut.clk)
       if timeout_cnt == (cfg_const.TIMEOUT_VAL*4):
           log.error("Timeout on waiting for an IRQ")
           raise TestFailure("Timeout on waiting for an IRQ")
       else:
           timeout_cnt += 1

    read = eth_infifo_if.init_read(address=0x00, length=1024)
    await with_timeout(read.wait(), *cfg_const.TIMEOUT_AXI)
    data_udp = read.data.data

    write = eth_outfifo_if.init_write(address=0x00, data=data_udp)
    await with_timeout(write.wait(), *cfg_const.TIMEOUT_AXI)

    # RW MAC Address
    read = eth_csr_if.init_read(address=0x14, length=4)
    await with_timeout(read.wait(), *cfg_const.TIMEOUT_AXI)
    mac_low = read.data.data
    read = eth_csr_if.init_read(address=0x18, length=4)
    await with_timeout(read.wait(), *cfg_const.TIMEOUT_AXI)
    mac_high = read.data.data
    write = eth_csr_if.init_write(address=0x40, data=mac_low)
    await with_timeout(write.wait(), *cfg_const.TIMEOUT_AXI)
    write = eth_csr_if.init_write(address=0x44, data=mac_high)
    await with_timeout(write.wait(), *cfg_const.TIMEOUT_AXI)

    # RW IP address
    read = eth_csr_if.init_read(address=0x1C, length=4)
    await with_timeout(read.wait(), *cfg_const.TIMEOUT_AXI)
    ip_dst = read.data.data
    write = eth_csr_if.init_write(address=0x48, data=ip_dst)
    await with_timeout(write.wait(), *cfg_const.TIMEOUT_AXI)

    # W src/dst port
    src_port = 2020
    src_port = src_port.to_bytes(4,'little')
    write = eth_csr_if.init_write(address=0x50, data=src_port)
    await with_timeout(write.wait(), *cfg_const.TIMEOUT_AXI)
    dst_port = 2222
    dst_port = dst_port.to_bytes(4,'little')
    write = eth_csr_if.init_write(address=0x54, data=dst_port)
    await with_timeout(write.wait(), *cfg_const.TIMEOUT_AXI)

    # Set length
    udp_length = 1024
    udp_length = udp_length.to_bytes(4,'little')
    write = eth_csr_if.init_write(address=0x4c, data=udp_length)
    await with_timeout(write.wait(), *cfg_const.TIMEOUT_AXI)

    # Send pkt
    val = 1
    val = val.to_bytes(4,'little')
    write = eth_csr_if.init_write(address=0x6c, data=val)
    await with_timeout(write.wait(), *cfg_const.TIMEOUT_AXI)

    log.info("Receive ARP request")
    rx_frame = await phy_if.tx.recv()
    rx_pkt = Ether(bytes(rx_frame.get_payload()))
    log.info("RX packet: %s", repr(rx_pkt))

    assert rx_pkt.dst == 'ff:ff:ff:ff:ff:ff'
    assert rx_pkt.src == test_pkt.dst
    assert rx_pkt[ARP].hwtype == 1
    assert rx_pkt[ARP].ptype == 0x0800
    assert rx_pkt[ARP].hwlen == 6
    assert rx_pkt[ARP].plen == 4
    assert rx_pkt[ARP].op == 1
    assert rx_pkt[ARP].hwsrc == test_pkt.dst
    assert rx_pkt[ARP].psrc == test_pkt[IP].dst
    assert rx_pkt[ARP].hwdst == '00:00:00:00:00:00'
    assert rx_pkt[ARP].pdst == test_pkt[IP].src

    log.info("send ARP response")
    eth = Ether(src=test_pkt.src, dst=test_pkt.dst)
    arp = ARP(hwtype=1, ptype=0x0800, hwlen=6, plen=4, op=2,
        hwsrc=test_pkt.src, psrc=test_pkt[IP].src,
        hwdst=test_pkt.dst, pdst=test_pkt[IP].dst)
    resp_pkt = eth / arp
    resp_frame = GmiiFrame.from_payload(resp_pkt.build())
    await phy_if.rx.send(resp_frame)

    log.info("Receive UDP packet")
    rx_frame = await phy_if.tx.recv()
    rx_pkt = Ether(bytes(rx_frame.get_payload()))
    log.info("RX packet: %s", repr(rx_pkt))
    assert rx_pkt[UDP].payload == test_pkt[UDP].payload

def cycle_pause():
    return itertools.cycle([1, 1, 1, 0])

if cocotb.SIM_NAME:
    factory = TestFactory(test_function=run_test)
    # factory.add_option("idle_inserter", [None, cycle_pause])
    # factory.add_option("backpressure_inserter", [None, cycle_pause])
    factory.generate_tests()

@pytest.mark.parametrize("flavor",cfg_const.regression_setup)
def test_full_fifo(flavor):
    module = os.path.splitext(os.path.basename(__file__))[0]
    SIM_BUILD = os.path.join(cfg_const.TESTS_DIR,
            f"../../run_dir/run_{cfg_const.SIMULATOR}_{module}_{flavor}")
    cfg_const.EXTRA_ENV['SIM_BUILD'] = SIM_BUILD
    cfg_const.EXTRA_ENV['FLAVOR'] = flavor
    extra_args_sim = cfg_const._get_cfg_args(flavor)

    run(
        python_search=[cfg_const.TESTS_DIR],
        includes=cfg_const.INC_DIR,
        verilog_sources=cfg_const.VERILOG_SOURCES,
        toplevel=cfg_const.TOPLEVEL,
        module=module,
        sim_build=SIM_BUILD,
        compile_args=cfg_const.COMPILE_ARGS,
        extra_env=cfg_const.EXTRA_ENV,
        extra_args=extra_args_sim
    )

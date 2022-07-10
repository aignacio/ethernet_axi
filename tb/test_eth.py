#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# File              : test_eth.py
# License           : MIT license <Check LICENSE>
# Author            : Anderson Ignacio da Silva (aignacio) <anderson@aignacio.com>
# Date              : 03.06.2022
# Last Modified Date: 10.07.2022
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
from cocotbext.eth import GmiiFrame, MiiPhy
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
    mii_phy_if     = MiiPhy(dut.phy_txd, None, dut.phy_tx_en, dut.phy_tx_clk,
                            dut.phy_rxd, dut.phy_rx_er, dut.phy_rx_dv, dut.phy_rx_clk, speed=100e6)

    dut.phy_crs.setimmediatevalue(0)
    dut.phy_col.setimmediatevalue(0)

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
    payload = bytes([x % 256 for x in range(256)])
    eth = Ether(src='5a:51:52:53:54:55', dst='1D:EE:69:DE:F0:61')
    ip = IP(src='192.168.0.100', dst='192.168.0.211')
    udp = UDP(sport=5678, dport=1234)
    test_pkt = eth / ip / udp / payload
    test_frame = GmiiFrame.from_payload(test_pkt.build(), tx_complete=Event())
    await mii_phy_if.rx.send(test_frame)
    await test_frame.tx_complete.wait()
    timeout_cnt = 0
    while int(dut.pkt_recv) == 0:
        await RisingEdge(dut.clk)
        if timeout_cnt == cfg_const.TIMEOUT_VAL:
            log.error("Timeout on waiting for an IRQ")
            raise TestFailure("Timeout on waiting for an IRQ")
        else:
            timeout_cnt += 1

    data_udp = []
    for i in range(256//4):
        read = eth_infifo_if.init_read(address=0x00, length=4)
        await with_timeout(read.wait(), *cfg_const.TIMEOUT_AXI)
        data_udp.append(int.from_bytes(read.data.data, byteorder='little', signed=False))

    for i in data_udp:
        payload = i.to_bytes(4,'little')
        write = eth_outfifo_if.init_write(address=0x00, data=payload)
        await with_timeout(write.wait(), *cfg_const.TIMEOUT_AXI)

    # Prepare to send the pkt again
    read = eth_csr_if.init_read(address=0x14, length=4)
    await with_timeout(read.wait(), *cfg_const.TIMEOUT_AXI)
    mac_low = int.from_bytes(read.data.data, byteorder='little', signed=False)
    read = eth_csr_if.init_read(address=0x18, length=4)
    await with_timeout(read.wait(), *cfg_const.TIMEOUT_AXI)
    mac_high = int.from_bytes(read.data.data, byteorder='little', signed=False)

    dst_mac = mac_low|(mac_high << 24);
    print("Destination MAC addr = %s"%hex(dst_mac))

def cycle_pause():
    return itertools.cycle([1, 1, 1, 0])

if cocotb.SIM_NAME:
    factory = TestFactory(test_function=run_test)
    # factory.add_option("idle_inserter", [None, cycle_pause])
    # factory.add_option("backpressure_inserter", [None, cycle_pause])
    factory.generate_tests()

@pytest.mark.parametrize("flavor",cfg_const.regression_setup)
def test_eth(flavor):
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

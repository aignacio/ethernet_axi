#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# File              : test_eth.py
# License           : MIT license <Check LICENSE>
# Author            : Anderson Ignacio da Silva (aignacio) <anderson@aignacio.com>
# Date              : 03.06.2022
# Last Modified Date: 05.07.2022
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
from cocotb.triggers import ClockCycles, with_timeout
from cocotbext.axi import AxiBus, AxiLiteBus
from cocotbext.axi import AxiMaster, AxiLiteMaster

async def run_test(dut, config_clk="100MHz", idle_inserter=None, backpressure_inserter=None):
    eth_flavor = os.getenv("FLAVOR")

    log = logging.getLogger(f"cocotb.eth")
    await cocotb.start(Clock(dut.clk, *cfg_const.CLK_100MHz).start())
    dut.rst.setimmediatevalue(1)
    await ClockCycles(dut.clk, 3)
    dut.rst.setimmediatevalue(0)

    eth_csr_if  = AxiLiteMaster(AxiLiteBus.from_prefix(dut, "eth_csr"), dut.clk, dut.rst)
    eth_fifo_if = AxiMaster(AxiBus.from_prefix(dut, "eth_fifo_s"), dut.clk, dut.rst)

    eth_csr = {}
    for i in range(16):
        eth_csr['csr_'+str(i)] = i*0x8
    for csr in eth_csr:
        log.info("CSR [Addr: %s]", hex(eth_csr[csr]))
        read = eth_csr_if.init_read(address=eth_csr[csr], length=4)
        await with_timeout(read.wait(), *cfg_const.TIMEOUT_AXI)
        csr_data = int.from_bytes(read.data.data, byteorder='little', signed=False)
        log.info("Data = %s", hex(csr_data))

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

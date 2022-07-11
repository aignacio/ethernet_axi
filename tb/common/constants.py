#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# File              : constants.py
# License           : MIT license <Check LICENSE>
# Author            : Anderson Ignacio da Silva (aignacio) <anderson@aignacio.com>
# Date              : 03.06.2022
# Last Modified Date: 11.07.2022
import os
import glob
import copy
import math

class cfg_const:
    regression_setup = ['arty', 'nexys']

    NEXYS_VIDEO = {}
    NEXYS_VIDEO['AXI_ADDR_WIDTH'] = 32

    ARTY = {}
    ARTY['AXI_ADDR_WIDTH'] = 32
    ################### Start Configure ####################
    CLK_100MHz  = (10, "ns")
    CLK_200MHz  = (5, "ns")
    TIMEOUT_VAL = 500
    TIMEOUT_AXI_T = 800
    TIMEOUT_AXI = (CLK_100MHz[0]*TIMEOUT_AXI_T, "ns")
    TIMEOUT_IRQ = (CLK_100MHz[0]*TIMEOUT_AXI_T, "ns")

    TOPLEVEL  = str(os.getenv("DUT"))
    SIMULATOR = str(os.getenv("SIM"))
    EXTRA_ENV = {}
    EXTRA_ENV['COCOTB_HDL_TIMEUNIT'] = os.getenv("TIMEUNIT")
    EXTRA_ENV['COCOTB_HDL_TIMEPRECISION'] = os.getenv("TIMEPREC")

    TESTS_DIR       = os.path.dirname(os.path.abspath(__file__))
    RTL_DIR         = os.path.join(TESTS_DIR,"../../rtl/")
    RGGEN_V_DIR     = os.path.join(TESTS_DIR,"../../rggen-verilog-rtl/")
    ETH_V_DIR       = os.path.join(TESTS_DIR,"../../verilog-ethernet/")
    CSR_DIR         = os.path.join(TESTS_DIR,"../../csr_out/")
    INC_DIR         = [f'{RTL_DIR}inc']
    INC_DIR         = INC_DIR + [f'{RGGEN_V_DIR}']
    VERILOG_SOURCES = [] # The sequence below is important...
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{RTL_DIR}inc/*.sv',recursive=True)
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{RTL_DIR}inc/*.svh',recursive=True)
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{RTL_DIR}**/*.sv',recursive=True)
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{RTL_DIR}**/*.v',recursive=True)
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{RGGEN_V_DIR}**/*.v',recursive=True)
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{CSR_DIR}**/*.v',recursive=True)
    # VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/*.v',recursive=True)
    # VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/lib/axis/rtl/*.v',recursive=True)
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/eth_mac_mii_fifo.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/eth_mac_mii.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/eth_axis_rx.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/eth_axis_tx.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/udp_complete.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/ip_arb_mux.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/ip_complete.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/udp.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/udp_ip_rx.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/udp_ip_tx.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/udp_checksum_gen.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/lib/axis/rtl/axis_async_fifo_adapter.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/lib/axis/rtl/axis_fifo.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/lib/axis/rtl/axis_async_fifo.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/eth_arb_mux.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/lib/axis/rtl/arbiter.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/lib/axis/rtl/priority_encoder.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/mii_phy_if.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/axis_gmii_rx.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/axis_gmii_tx.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/eth_mac_1g.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/ip.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/ip_eth_tx.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/ip_eth_rx.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/arp.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/arp_cache.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/arp_eth_rx.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/arp_eth_tx.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/ssio_sdr_in.v')
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{ETH_V_DIR}/rtl/lfsr.v')
    PATH_RUN        = str(os.getenv("PATH_RUN"))
    COMPILE_ARGS    = ["-f",os.path.join(PATH_RUN,"verilator.flags"),"--coverage","--coverage-line","--coverage-toggle"]
    if SIMULATOR == "verilator":
        EXTRA_ARGS = ["--trace-fst","--trace-structs","--Wno-UNOPTFLAT","--Wno-REDEFMACRO"]
    else:
        EXTRA_ARGS = []

    ARTY_CFG = copy.deepcopy(EXTRA_ARGS)
    NEXYS_VIDEO_CFG = copy.deepcopy(EXTRA_ARGS)

    for param in ARTY.items():
        ARTY_CFG.append("-D"+param[0].upper()+"="+str(param[1]))
    for param in NEXYS_VIDEO.items():
        NEXYS_VIDEO_CFG.append("-D"+param[0].upper()+"="+str(param[1]))

    def _get_cfg_args(flavor):
        if flavor == "arty":
            return cfg_const.ARTY_CFG
        elif flavor == "nexys":
            return cfg_const.NEXYS_VIDEO_CFG
        else:
            return cfg_const.NEXYS_VIDEO_CFG

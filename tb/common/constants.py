#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# File              : constants.py
# License           : MIT license <Check LICENSE>
# Author            : Anderson Ignacio da Silva (aignacio) <anderson@aignacio.com>
# Date              : 03.06.2022
# Last Modified Date: 01.07.2022
import os
import glob
import copy
import math

class cfg_const:
    ################### Start Configure ####################
    CLK_100MHz  = (10, "ns")
    CLK_200MHz  = (5, "ns")
    TIMEOUT_AXI = (CLK_100MHz[0]*TIMEOUT_VAL, "ns")
    TIMEOUT_IRQ = (CLK_100MHz[0]*TIMEOUT_VAL, "ns")

    TOPLEVEL  = str(os.getenv("DUT"))
    SIMULATOR = str(os.getenv("SIM"))
    EXTRA_ENV = {}
    EXTRA_ENV['COCOTB_HDL_TIMEUNIT'] = os.getenv("TIMEUNIT")
    EXTRA_ENV['COCOTB_HDL_TIMEPRECISION'] = os.getenv("TIMEPREC")

    TESTS_DIR = os.path.dirname(os.path.abspath(__file__))
    RTL_DIR   = os.path.join(TESTS_DIR,"../../rtl/")
    INC_DIR   = [f'{RTL_DIR}inc']
    VERILOG_SOURCES = [] # The sequence below is important...
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{RTL_DIR}inc/*.sv',recursive=True)
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{RTL_DIR}inc/*.svh',recursive=True)
    VERILOG_SOURCES = VERILOG_SOURCES + glob.glob(f'{RTL_DIR}**/*.sv',recursive=True)
    PATH_RUN     = str(os.getenv("PATH_RUN"))
    COMPILE_ARGS = ["-f",os.path.join(PATH_RUN,"verilator.flags"),"--coverage","--coverage-line","--coverage-toggle"]
    if SIMULATOR == "verilator":
        EXTRA_ARGS = ["--trace-fst","--trace-structs","--Wno-UNOPTFLAT","--Wno-REDEFMACRO"]
    else:
        EXTRA_ARGS = []

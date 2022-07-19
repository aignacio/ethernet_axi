# File              : Makefile
# License           : MIT license <Check LICENSE>
# Author            : Anderson Ignacio da Silva (aignacio) <anderson@aignacio.com>
# Date              : 07.06.2022
# Last Modified Date: 19.07.2022
COV_REP			:=	$(shell find run_dir -name 'coverage.dat')
GTKWAVE_PRE	:=	/Applications/gtkwave.app/Contents/Resources/bin/
SPEC_TEST		?=	#-k test_single_pkt[nexys]
RUN_CMD			:=	docker run --rm --name eth_run 		\
								-v $(abspath .):/ethernet_axi -w	\
								/ethernet_axi aignacio/axi_dma

.PHONY: run cov clean

all: run
	say ">Test run finished, please check the terminal"

run: csr_out/eth_csr.v
	$(RUN_CMD) tox -- $(SPEC_TEST)

csr_out/eth_csr.v:
	$(RUN_CMD) rggen --plugin rggen-verilog -c config_csr.yml -o csr_out eth_csr.xlsx

wave:
	$(GTKWAVE_PRE)/gtkwave run_dir/run_verilator_test_single_pkt_nexys/dump.fst tmpl.gtkw

coverage.info:
	$(RUN_CMD) verilator_coverage $(COV_REP) --write-info coverage.info

cov: coverage.info
	$(RUN_CMD) genhtml $< -o output_lcov

clean:
	@rm -rf run_dir csr_out

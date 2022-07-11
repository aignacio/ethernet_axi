# File              : Makefile
# License           : MIT license <Check LICENSE>
# Author            : Anderson Ignacio da Silva (aignacio) <anderson@aignacio.com>
# Date              : 07.06.2022
# Last Modified Date: 11.07.2022
GTKWAVE_PRE	:=	/Applications/gtkwave.app/Contents/Resources/bin/
SPEC_TEST		?=	#-k test_full_fifo[arty]
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
	$(GTKWAVE_PRE)/gtkwave run_dir/run_verilator_test_full_fifo_arty/dump.fst tmpl.gtkw

clean:
	@rm -rf run_dir csr_out

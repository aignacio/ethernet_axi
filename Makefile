# File              : Makefile
# License           : MIT license <Check LICENSE>
# Author            : Anderson Ignacio da Silva (aignacio) <anderson@aignacio.com>
# Date              : 07.06.2022
# Last Modified Date: 03.07.2022
SPEC_TEST	?=	#-k test
RUN_CMD		:=	docker run --rm --name axi_dma		\
							-v $(abspath .):/ethernet_axi -w	\
							/ethernet_axi aignacio/axi_dma

.PHONY: run cov clean

all: run
	say ">Test run finished, please check the terminal"

run: csr_out/eth_csr.v
	$(RUN_CMD) tox -- $(SPEC_TEST)

csr_out/eth_csr.v:
	$(RUN_CMD) rggen --plugin rggen-verilog --plugin rggen-c-header -c config_csr.yml -o csr_out eth_csr.xlsx

clean:
	@rm -rf run_dir csr_out

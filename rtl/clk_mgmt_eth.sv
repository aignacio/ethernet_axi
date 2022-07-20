/**
 * File              : clk_mgmt_eth.sv
 * License           : MIT license <Check LICENSE>
 * Author            : Anderson Ignacio da Silva (aignacio) <anderson@aignacio.com>
 * Date              : 17.03.2022
 * Last Modified Date: 20.07.2022
 */

`default_nettype wire

module clk_mgmt_eth(
`ifdef ETH_TARGET_FPGA_KINTEX
  input         clk_in_p,
  input         clk_in_n,
`else
  input         clk_in,
`endif
  input         rst_in,
  output  logic clk_125MHz,
`ifdef ETH_TARGET_FPGA_NEXYSV
  output  logic clk_90MHz,
  output  logic clk_200MHz,
`endif
`ifdef ETH_TARGET_FPGA_ARTY
  output  logic clk_25MHz,
`endif
  output  logic clk_locked
);

`ifdef ETH_TARGET_FPGA_NEXYSV
  logic clk_ibufg;
  logic mmcm_clkfb;
  logic clk_mmcm_out_125MHz;
  logic clk_mmcm_out_90MHz;
  logic clk_mmcm_out_200MHz;

  // MMCM instance
  // 100 MHz in, 125 MHz out
  // PFD range: 10 MHz to 550 MHz
  // VCO range: 600 MHz to 1200 MHz
  // M = 10, D = 1 sets Fvco = 1000 MHz (in range)
  // Divide by 8 to get output frequency of 125 MHz
  // Need two 125 MHz outputs with 90 degree offset
  // Also need 200 MHz out for IODELAY
  // 1000 / 5 = 200 MHz
  MMCME2_BASE #(
    .BANDWIDTH         ("OPTIMIZED"),
    .CLKOUT0_DIVIDE_F  (8),
    .CLKOUT0_DUTY_CYCLE(0.5),
    .CLKOUT0_PHASE     (0),
    .CLKOUT1_DIVIDE    (8),
    .CLKOUT1_DUTY_CYCLE(0.5),
    .CLKOUT1_PHASE     (90),
    .CLKOUT2_DIVIDE    (5),
    .CLKOUT2_DUTY_CYCLE(0.5),
    .CLKOUT2_PHASE     (0),
    .CLKOUT3_DIVIDE    (1),
    .CLKOUT3_DUTY_CYCLE(0.5),
    .CLKOUT3_PHASE     (0),
    .CLKOUT4_DIVIDE    (1),
    .CLKOUT4_DUTY_CYCLE(0.5),
    .CLKOUT4_PHASE     (0),
    .CLKOUT5_DIVIDE    (1),
    .CLKOUT5_DUTY_CYCLE(0.5),
    .CLKOUT5_PHASE     (0),
    .CLKOUT6_DIVIDE    (1),
    .CLKOUT6_DUTY_CYCLE(0.5),
    .CLKOUT6_PHASE     (0),
    .CLKFBOUT_MULT_F   (10),
    .CLKFBOUT_PHASE    (0),
    .DIVCLK_DIVIDE     (1),
    .REF_JITTER1       (0.010),
    .CLKIN1_PERIOD     (10.0),
    .STARTUP_WAIT      ("FALSE"),
    .CLKOUT4_CASCADE   ("FALSE")
  ) clk_mmcm_inst (
    .CLKIN1            (clk_ibufg),
    .CLKFBIN           (mmcm_clkfb),
    .RST               (rst_in),
    .PWRDWN            (1'b0),
    .CLKOUT0           (clk_mmcm_out_125MHz),
    .CLKOUT0B          (),
    .CLKOUT1           (clk_mmcm_out_90MHz),
    .CLKOUT1B          (),
    .CLKOUT2           (clk_mmcm_out_200MHz),
    .CLKOUT2B          (),
    .CLKOUT3           (),
    .CLKOUT3B          (),
    .CLKOUT4           (),
    .CLKOUT5           (),
    .CLKOUT6           (),
    .CLKFBOUT          (mmcm_clkfb),
    .CLKFBOUTB         (),
    .LOCKED            (clk_locked)
  );

  BUFG clk_bufg_inst(
    .I(clk_mmcm_out_125MHz),
    .O(clk_125MHz)
  );

  BUFG clk90_bufg_inst(
    .I(clk_mmcm_out_90MHz),
    .O(clk_90MHz)
  );

  IBUFG clk_ibufg_inst(
    .I(clk_in),
    .O(clk_ibufg)
  );

  BUFG clk_200_bufg_inst(
    .I(clk_mmcm_out_200MHz),
    .O(clk_200MHz)
  );
`endif

`ifdef ETH_TARGET_FPGA_KINTEX
  assign  clk_125MHz  = 'b0;
  assign  clk_locked  = 'b0;
  IBUFDS clkin1_ibufgds (
    .O  (clk_in_pn),
    .I  (clk_in_p),
    .IB (clk_in_n)
  );
`endif

`ifdef ETH_TARGET_FPGA_ARTY
  assign  clk_125MHz  = 'b0;
  assign  clk_25MHz   = 'b0;
  assign  clk_locked  = 'b0;
`endif
endmodule

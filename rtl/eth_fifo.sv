/**
 * File              : eth_fifo.sv
 * License           : MIT license <Check LICENSE>
 * Author            : Anderson Ignacio da Silva (aignacio) <anderson@aignacio.com>
 * Date              : 10.06.2022
 * Last Modified Date: 09.07.2022
 */
module eth_fifo #(
  parameter SLOTS = 4,
  parameter WIDTH = 32
)(
  input                                       clk,
  input                                       rst,
  input                                       clear_i,
  input                                       write_i,
  input                                       read_i,
  input         [WIDTH-1:0]                   data_i,
  output  logic [WIDTH-1:0]                   data_o,
  output  logic                               error_o,
  output  logic                               full_o,
  output  logic                               empty_o,
  output  logic [$clog2(SLOTS>1?SLOTS:2):0]   ocup_o,
  output  logic [$clog2(SLOTS>1?SLOTS:2):0]   free_o
);
  `define MSB_SLOT  $clog2(SLOTS>1?SLOTS:2)
  typedef logic [$clog2(SLOTS>1?SLOTS:2):0] msb_t;

  logic [SLOTS-1:0] [WIDTH-1:0] fifo_ff;
  msb_t                         write_ptr_ff;
  msb_t                         read_ptr_ff;
  msb_t                         next_write_ptr;
  msb_t                         next_read_ptr;
  msb_t                         fifo_ocup;

  always_comb begin
    next_read_ptr = read_ptr_ff;
    next_write_ptr = write_ptr_ff;
    if (SLOTS == 1) begin
      empty_o = (write_ptr_ff == read_ptr_ff);
      full_o  = (write_ptr_ff[0] != read_ptr_ff[0]);
      data_o  = empty_o ? '0 : fifo_ff[0];
    end
    else begin
      empty_o = (write_ptr_ff == read_ptr_ff);
      full_o  = (write_ptr_ff[`MSB_SLOT-1:0] == read_ptr_ff[`MSB_SLOT-1:0]) &&
                (write_ptr_ff[`MSB_SLOT] != read_ptr_ff[`MSB_SLOT]);
      data_o  = empty_o ? '0 : fifo_ff[read_ptr_ff[`MSB_SLOT-1:0]];
    end

    if (write_i && ~full_o)
      next_write_ptr = write_ptr_ff + 'd1;

    if (read_i && ~empty_o)
      next_read_ptr = read_ptr_ff + 'd1;

    error_o = (write_i && full_o) || (read_i && empty_o);
    fifo_ocup = write_ptr_ff - read_ptr_ff;
    free_o = msb_t'(SLOTS) - fifo_ocup;
    ocup_o = fifo_ocup;
  end

  always_ff @ (posedge clk) begin
    if (rst) begin
      write_ptr_ff <= '0;
      read_ptr_ff  <= '0;
    end
    else begin
      if (clear_i) begin
        write_ptr_ff <= '0;
        read_ptr_ff  <= '0;
      end
      else begin
        write_ptr_ff <= next_write_ptr;
        read_ptr_ff <= next_read_ptr;
        if (write_i && ~full_o) begin
          if (SLOTS == 1) begin
            fifo_ff[0] <= data_i;
          end
          else begin
            fifo_ff[write_ptr_ff[`MSB_SLOT-1:0]] <= data_i;
          end
        end
      end
    end
  end

`ifndef NO_ASSERTIONS
  initial begin
    illegal_fifo_slot : assert (2**$clog2(SLOTS) == SLOTS)
    else $error("FIFO Slots must be power of 2");

    min_fifo_size : assert (SLOTS >= 1)
    else $error("FIFO size of SLOTS defined is illegal!");
  end
`endif

endmodule

/**
 * File              : pkt_fifo.sv
 * License           : MIT license <Check LICENSE>
 * Author            : Anderson Ignacio da Silva (aignacio) <anderson@aignacio.com>
 * Date              : 08.07.2022
 * Last Modified Date: 08.07.2022
 */
module pkt_fifo
  import utils_pkg::*;
#(
  parameter int FIFO_TYPE   = "IN" // or "OUT"
)(
  input                 clk,
  input                 rst,
  // Slave AXI I/F
  input   s_axi_mosi_t  axi_mosi,
  output  s_axi_miso_t  axi_miso,
  // UDP Stream_In I/F
  input   s_axis_mosi_t axis_sin_mosi,
  output  s_axis_miso_t axis_sin_miso,
  // UDP Stream_Out I/F
  output  s_axis_mosi_t axis_sout_mosi,
  input   s_axis_miso_t axis_sout_miso,
  // FIFO status
  output  s_fifo_st_t   fifo_st_o,
  input   s_fifo_cmd_t  fifo_cmd_i
);
  localparam  M_WIDTH = (FIFO_TYPE == "IN") ? (INFIFO_KB_SIZE*256) :
                                              (OUTFIFO_KB_SIZE*256);

  logic [M_WIDTH-1:0][31:0] mem_ff;

  logic axis_read;
  logic axis_write;
  logic axi_read;
  logic axi_write;
  logic axis_rd_ff, next_axis_rd;
  udp_length_t len_cnt_ff, next_len;

  // Byte based pointers
  ptr_t rd_ptr_ff, next_rd_ptr;
  ptr_t wr_ptr_ff, next_wr_ptr;

  logic [$clog2(M_WIDTH)-1:0] rd_mem_addr;
  logic                       rd_mem_en;
  logic [31:0]                rd_mem_data;
  logic [$clog2(M_WIDTH)-1:0] wr_mem_addr;
  logic                       wr_mem_en;
  logic [31:0]                wr_mem_data;
  logic [31:0]                wr_mem_strb;
  logic                       done_ff, next_done;

  always_comb begin
    fifo_st_o = s_fifo_st_t'('0);
    fifo_st_o.rd_ptr = rd_ptr_ff;
    fifo_st_o.wr_ptr = wr_ptr_ff;
    fifo_st_o.empty  = (rd_ptr_ff == wr_ptr_ff);

    if (FIFO_TYPE == "IN") begin
      fifo_st_o.full = ((rd_ptr_ff-wr_ptr_ff) == INFIFO_KB_SIZE*1024);
      fifo_st_o.done = axis_sin_mosi.tlast;
    end
    else begin
      fifo_st_o.full = ((rd_ptr_ff-wr_ptr_ff) == OUTFIFO_KB_SIZE*1024);
      fifo_st_o.done = 1'b0;
    end
  end

  always_comb begin : fifo_st_and_mem
    next_rd_ptr = rd_ptr_ff;
    next_wr_ptr = wr_ptr_ff;

    axi_read    = 1'b0;
    axi_write   = 1'b0;

    if (FIFO_TYPE == "IN") begin
      // InFIFO
      next_rd_ptr = rd_ptr_ff + (axi_read   ? 'd4 : 'd0);
      next_wr_ptr = wr_ptr_ff + (axis_write ? 'd1 : 'd0);

      rd_mem_addr = rd_ptr_ff[$clog2(INFIFO_KB_SIZE*1024)-1:0] >> 2;
      rd_mem_en   = axi_read;
      wr_mem_addr = wr_ptr_ff[$clog2(INFIFO_KB_SIZE*1024)-1:0] >> 2;
      wr_mem_en   = axis_write;
      wr_mem_data = {axis_sin_mosi.tdata, axis_sin_mosi.tdata,
                     axis_sin_mosi.tdata, axis_sin_mosi.tdata};
      case (wr_ptr_ff[1:0])
        'd0:  wr_mem_strb = 'b0001;
        'd1:  wr_mem_strb = 'b0010;
        'd2:  wr_mem_strb = 'b0100;
        'd3:  wr_mem_strb = 'b1000;
      endcase
    end
    else begin
      // OutFIFO
      next_rd_ptr = rd_ptr_ff + ((axis_read && axis_sout_miso.tready) ? 'd1 : 'd0);
      next_wr_ptr = wr_ptr_ff + (axi_write  ? 'd4 : 'd0);

      rd_mem_addr = rd_ptr_ff[$clog2(OUTFIFO_KB_SIZE*1024)-1:0] >> 2;
      rd_mem_en   = axis_read;
      wr_mem_addr = wr_ptr_ff[$clog2(OUTFIFO_KB_SIZE*1024)-1:0] >> 2;
      wr_mem_en   = axi_write;
      wr_mem_data = axi_mosi.wdata;
      wr_mem_strb = axi_mosi.wstrb;
    end

    if (fifo_cmd_st.clear) begin
      next_rd_ptr = '0;
      next_wr_ptr = '0;
    end
  end : fifo_st_and_mem

  always_comb begin : axi_stream_ctrl
    next_len = len_cnt_ff;
    next_axis_rd = axis_rd_ff;
    axis_write   = 1'b0;
    axis_read    = 1'b0;
    next_done    = (done_ff && fifo_cmd_i.start) ? 1'b1 : 1'b0;

    if (FIFO_TYPE == "IN") begin
      axis_sout_mosi = s_axis_mosi_t'('0);
      axis_sin_miso  = s_axis_miso_t'('0);
      // Data is coming from UDP Complete through AXIS I/F
      axis_sin_miso.tready = ~fifo_st_o.full;

      if (axis_sin_miso.tready && axis_sin_mosi.tvalid) begin
        axis_write = 1'b1;
      end
    end
    else begin
      axis_sin_miso  = s_axis_miso_t'('0);
      axis_sout_mosi = s_axis_mosi_t'('0);
      axis_sout_mosi.tvalid = axis_rd_ff;
      axis_sout_mosi.tdata  = //TODO;
      axis_sout_mosi.tlast  = axis_rd_ff ? (len_cnt_ff == (fifo_cmd_i.len_cnt_ff - 'd1)) : 1'b0;
      fifo_st_o.done = done_ff;

      if (axis_sout_mosi.tvalid && axis_sout_miso.tready) begin
        next_len = len_cnt_ff + 'd1;
      end

      if (~done_ff && fifo_cmd_i.start && (len_cnt_ff < fifo_cmd_i.length)) begin
        next_axis_rd = 1'b1;
        axis_read = 1'b1;
        if (next_len == fifo_cmd_i.length) begin
          next_done    = 1'b1;
          next_axis_rd = 1'b0;
          axis_read    = 1'b0;
        end
      end
      else begin
        next_len = 0;
      end
    end
  end : axi_stream_ctrl

  always_ff @ (posedge clk) begin
    if (rst) begin
      rd_ptr_ff       <= '0;
      wr_ptr_ff       <= '0;
      axis_rd_ff      <= '0;
      len_cnt_ff      <= '0;
      done_ff         <= '0;
    end
    else begin
      rd_ptr_ff       <= next_rd_ptr;
      wr_ptr_ff       <= next_wr_ptr;
      axis_rd_ff      <= next_axis_rd;
      len_cnt_ff      <= next_len;
      done_ff         <= next_done;
    end
  end

  bytewrite_tdp_ram_rf#(
    .ADDR_WIDTH ($clog2(M_WIDTH))
  ) u_ram (
    .clkA   (clk),
    .enaA   (rd_mem_en),
    .weA    ('b0),
    .addrA  (rd_mem_addr),
    .dinA   ('b0),
    .doutA  (rd_mem_data),
    .clkB   (clk),
    .enaB   (wr_mem_en),
    .weB    (wr_mem_strb),
    .addrB  (wr_mem_addr),
    .dinB   (wr_mem_data),
    .doutB  ()
  );
endmodule

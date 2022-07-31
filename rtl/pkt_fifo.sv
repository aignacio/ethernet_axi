/**
 * File              : pkt_fifo.sv
 * License           : MIT license <Check LICENSE>
 * Author            : Anderson Ignacio da Silva (aignacio) <anderson@aignacio.com>
 * Date              : 08.07.2022
 * Last Modified Date: 31.07.2022
 */
module pkt_fifo
  import utils_pkg::*;
#(
  parameter int FIFO_TYPE   = "IN" // or "OUT"
)(
  input                 clk_axi,
  input                 rst_axi,
  input                 clk_eth,
  input                 rst_eth,
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

  typedef logic [$bits({axi_mosi.arlen,axi_mosi.arid})-1:0] fifo_t;

  logic axis_read;
  logic axis_write;
  logic axi_read;
  logic axi_write;
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
  logic [3:0]                 wr_mem_strb;
  logic                       full_ot;
  logic                       empty_ot;
  logic                       rd_ot;
  logic                       wr_ot;
  logic                       start_rd_ff, next_rd_start;
  logic                       bid_ff, next_bid;

  // Controls streaming out of data in OutFIFO
  fsm_pkt_t   st_ff, next_st;
  logic [1:0] lsb_ff, next_lsb;
  logic       txn_done;

  fifo_t      data_in_ot;
  fifo_t      data_out_ot;
  axi_alen_t  alen_rd_ff, next_alen;
  axi_alen_t  cur_alen;

  function automatic ptr_t conv_strb(axi_wr_strb_t strb);
    case (strb)
      'b0001:  return 1;
      'b0010:  return 1;
      'b0100:  return 1;
      'b1000:  return 1;
      'b0011:  return 2;
      'b0110:  return 2;
      'b1100:  return 2;
      'b0111:  return 3;
      'b1110:  return 3;
      'b1111:  return 4;
      default: return 4;
    endcase
  endfunction

  always_comb begin
    fifo_st_o.rd_ptr = rd_ptr_ff;
    fifo_st_o.wr_ptr = wr_ptr_ff;
    fifo_st_o.empty  = (rd_ptr_ff == wr_ptr_ff);

    if (FIFO_TYPE == "IN") begin
      fifo_st_o.full = ((wr_ptr_ff-rd_ptr_ff) == INFIFO_KB_SIZE*1024);
      fifo_st_o.done = axis_sin_mosi.tvalid && axis_sin_mosi.tlast && axis_sin_miso.tready;
    end
    else begin
      fifo_st_o.full = ((wr_ptr_ff-rd_ptr_ff) == OUTFIFO_KB_SIZE*1024);
    end
  end

  always_comb begin : fifo_st_and_mem
    next_rd_ptr = rd_ptr_ff;
    next_wr_ptr = wr_ptr_ff;

    if (FIFO_TYPE == "IN") begin
      // InFIFO
      next_rd_ptr = rd_ptr_ff + (axi_read ? 'd4 : 'd0);
      rd_mem_addr = rd_ptr_ff[$clog2(INFIFO_KB_SIZE*1024)-1:2];
      rd_mem_en   = axi_read;

      next_wr_ptr = wr_ptr_ff + (axis_write ? 'd1 : 'd0);
      wr_mem_addr = wr_ptr_ff[$clog2(INFIFO_KB_SIZE*1024)-1:2];
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
      next_rd_ptr = rd_ptr_ff + (axis_read ? 'd1 : 'd0);
      rd_mem_addr = rd_ptr_ff[$clog2(OUTFIFO_KB_SIZE*1024)-1:2];
      rd_mem_en   = axis_read;

      next_wr_ptr = wr_ptr_ff + (axi_write ? conv_strb(axi_mosi.wstrb) : 'd0);
      wr_mem_addr = wr_ptr_ff[$clog2(OUTFIFO_KB_SIZE*1024)-1:2];
      wr_mem_en   = axi_write;
      wr_mem_data = axi_mosi.wdata;
      wr_mem_strb = axi_mosi.wstrb;
    end

    if (fifo_cmd_i.clear) begin
      next_rd_ptr = '0;
      next_wr_ptr = '0;
    end
  end : fifo_st_and_mem

  always_comb begin : axi_stream_ctrl
    next_len   = len_cnt_ff;
    axis_write = 1'b0;
    axis_read  = 1'b0;
    next_lsb   = lsb_ff;

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

      if ((st_ff == IDLE_PKT_ST) && (next_st == STREAMING_PKT_ST)) begin
        axis_read = 1'b1;
        next_lsb  = rd_ptr_ff[1:0];
      end

      if ((st_ff == IDLE_PKT_ST) && (next_st == IDLE_PKT_ST)) begin
        next_len = '0;
      end

      if (st_ff == STREAMING_PKT_ST) begin
        axis_sout_mosi.tvalid = 1'b1;
        axis_sout_mosi.tlast  = (len_cnt_ff == (fifo_cmd_i.length - 'd1));
        case (lsb_ff)
          'd0:  axis_sout_mosi.tdata = rd_mem_data[7:0];
          'd1:  axis_sout_mosi.tdata = rd_mem_data[15:8];
          'd2:  axis_sout_mosi.tdata = rd_mem_data[23:16];
          'd3:  axis_sout_mosi.tdata = rd_mem_data[31:24];
        endcase

        if (axis_sout_miso.tready && ~axis_sout_mosi.tlast) begin
          axis_read = 1'b1;
          next_len  = len_cnt_ff + 'd1;
          next_lsb  = rd_ptr_ff[1:0];
        end
      end

      fifo_st_o.done = (next_st == DONE_PKT_ST) && (st_ff == STREAMING_PKT_ST);
    end

    txn_done = axis_sout_mosi.tvalid && axis_sout_miso.tready;
  end : axi_stream_ctrl

  always_comb begin : st_axi_stream
    next_st = st_ff;
    if (FIFO_TYPE != "IN") begin
      case (st_ff)
        IDLE_PKT_ST:      next_st = fifo_cmd_i.start ? STREAMING_PKT_ST : IDLE_PKT_ST;
        STREAMING_PKT_ST: next_st = (txn_done && ((fifo_cmd_i.length-1) == len_cnt_ff)) ? DONE_PKT_ST : STREAMING_PKT_ST;
        DONE_PKT_ST:      next_st = fifo_cmd_i.start ? DONE_PKT_ST : IDLE_PKT_ST;
        default           next_st = IDLE_PKT_ST;
      endcase
    end
  end : st_axi_stream

  always_comb begin : axi_slave_if
    axi_miso      = s_axi_miso_t'('0);
    wr_ot         = 1'b0;
    data_in_ot    = '0;
    next_alen     = alen_rd_ff;
    axi_write     = 1'b0;
    axi_read      = 1'b0;
    next_rd_start = start_rd_ff;
    rd_ot         = 1'b0;
    cur_alen      = '0;
    next_bid      = bid_ff;

    if (FIFO_TYPE == "IN") begin
      axi_miso.arready = 1'b1;

      if (axi_mosi.arvalid && axi_miso.arready) begin
        data_in_ot = {axi_mosi.arlen,axi_mosi.arid};
        wr_ot      = 1'b1;
      end

      if (~empty_ot && ~fifo_st_o.empty && ~start_rd_ff) begin
        {next_alen, axi_miso.rid} = data_out_ot;
        next_rd_start = 1'b1;
        axi_read      = 1'b1;
      end

      // Empty FIFO
      if (~empty_ot && fifo_st_o.empty && ~start_rd_ff) begin
        // Return error
        axi_miso.rresp  = AXI_SLVERR;
        axi_miso.rvalid = 1'b1;
        axi_miso.rlast  = 1'b1;
      end

      if (start_rd_ff) begin
        {cur_alen, axi_miso.rid} = data_out_ot;
        axi_miso.rvalid = 1'b1; //~fifo_st_o.empty;
        axi_miso.rlast  = (alen_rd_ff == 'd0);
        next_alen = alen_rd_ff - ((axi_miso.rvalid && axi_mosi.rready) ? 'd1 : 'd0);
        axi_read  = axi_miso.rvalid && axi_mosi.rready && ~axi_miso.rlast;
        axi_miso.rdata = rd_mem_data;
      end

      if (start_rd_ff) begin
        next_rd_start = (axi_miso.rvalid && axi_mosi.rready && axi_miso.rlast) ? 1'b0 : 1'b1;
      end

      rd_ot = axi_miso.rvalid && axi_miso.rlast && axi_mosi.rready;
    end
    else begin
      axi_miso.awready = ~full_ot;
      axi_miso.wready = ~fifo_st_o.full;

      if (axi_mosi.awvalid && axi_miso.awready) begin
        data_in_ot = {axi_mosi.awlen,axi_mosi.awid};
        wr_ot      = 1'b1;
      end

      if (axi_mosi.wvalid && axi_miso.wready) begin
        axi_write = 1'b1;
        if (axi_mosi.wlast) begin
          next_bid = 1'b1;
        end
      end

      if (bid_ff) begin
        axi_miso.bvalid = 1'b1;
        {cur_alen,axi_miso.bid} = data_out_ot;
        if (axi_mosi.bready) begin
          rd_ot    = 1'b1;
          next_bid = 1'b0;
        end
      end
    end
  end : axi_slave_if

  always_ff @ (posedge clk_axi) begin
    if (rst_axi) begin
      if (FIFO_TYPE == "IN") begin
        rd_ptr_ff   <= '0;
      end
      else begin
        wr_ptr_ff   <= '0;
      end
      alen_rd_ff  <= '0;
      start_rd_ff <= '0;
      bid_ff      <= '0;
    end
    else begin
      if (FIFO_TYPE == "IN") begin
        rd_ptr_ff   <= next_rd_ptr;
      end
      else begin
        wr_ptr_ff   <= next_wr_ptr;
      end
      alen_rd_ff  <= next_alen;
      start_rd_ff <= next_rd_start;
      bid_ff      <= next_bid;
    end
  end

  always_ff @ (posedge clk_eth) begin
    if (rst_eth) begin
      if (FIFO_TYPE == "IN") begin
        wr_ptr_ff   <= '0;
      end
      else begin
        rd_ptr_ff   <= '0;
      end
      len_cnt_ff  <= '0;
      st_ff       <= IDLE_PKT_ST;
      lsb_ff      <= '0;
    end
    else begin
      if (FIFO_TYPE == "IN") begin
        wr_ptr_ff   <= next_wr_ptr;
      end
      else begin
        rd_ptr_ff   <= next_rd_ptr;
      end
      len_cnt_ff  <= next_len;
      st_ff       <= next_st;
      lsb_ff      <= next_lsb;
    end
  end

  eth_fifo #(
    .SLOTS (ETH_OT_FIFO),
    .WIDTH ($bits({axi_mosi.arlen,axi_mosi.arid}))
  ) u_axi_ot_txn (
    .clk     (clk_axi),
    .rst     (rst_axi),
    .clear_i ('0),
    .write_i (wr_ot),
    .read_i  (rd_ot),
    .data_i  (data_in_ot),
    .data_o  (data_out_ot),
    .error_o (),
    .full_o  (full_ot),
    .empty_o (empty_ot),
    .ocup_o  (),
    .free_o  ()
  );

  if (FIFO_TYPE == "IN") begin
    // Write at 125MHz from UDP design
    // Read at AXI Clk from AXI slave I/F
    bytewrite_tdp_ram_rf#(
      .ADDR_WIDTH ($clog2(M_WIDTH))
    ) u_ram (
      .clkA   (clk_axi),
      .enaA   (rd_mem_en),
      .weA    ('b0),
      .addrA  (rd_mem_addr),
      .dinA   ('b0),
      .doutA  (rd_mem_data),
      .clkB   (clk_eth),
      .enaB   (wr_mem_en),
      .weB    (wr_mem_strb),
      .addrB  (wr_mem_addr),
      .dinB   (wr_mem_data),
      .doutB  ()
    );
  end
  else begin
    // Read at 125MHz from UDP design
    // Write at AXI Clk from AXI slave I/F
    bytewrite_tdp_ram_rf#(
      .ADDR_WIDTH ($clog2(M_WIDTH))
    ) u_ram (
      .clkA   (clk_eth),
      .enaA   (rd_mem_en),
      .weA    ('b0),
      .addrA  (rd_mem_addr),
      .dinA   ('b0),
      .doutA  (rd_mem_data),
      .clkB   (clk_axi),
      .enaB   (wr_mem_en),
      .weB    (wr_mem_strb),
      .addrB  (wr_mem_addr),
      .dinB   (wr_mem_data),
      .doutB  ()
    );

  end

endmodule

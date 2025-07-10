`timescale 1ns / 1ps

// ==================== Synchronizer ====================
module synchronizer #(parameter WIDTH=4) (
  input wire clk,
  input wire rst_n,
  input wire [WIDTH-1:0] d_in,
  output reg [WIDTH-1:0] d_out
);
  reg [WIDTH-1:0] q1;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      q1 <= 0;
      d_out <= 0;
    end else begin
      q1 <= d_in;
      d_out <= q1;
    end
  end
endmodule

// ==================== Write Pointer Handler ====================
module wptr_handler #(parameter PTR_WIDTH=3) (
  input wire wclk,
  input wire wrst_n,
  input wire w_en,
  input wire [PTR_WIDTH:0] g_rptr_sync,
  output reg [PTR_WIDTH:0] b_wptr,
  output reg [PTR_WIDTH:0] g_wptr,
  output reg full
);
  wire [PTR_WIDTH:0] b_wptr_next;
  wire [PTR_WIDTH:0] g_wptr_next;
  wire wfull;

  assign b_wptr_next = b_wptr + (w_en & ~full);
  assign g_wptr_next = (b_wptr_next >> 1) ^ b_wptr_next;

  assign wfull = (g_wptr_next == {~g_rptr_sync[PTR_WIDTH:PTR_WIDTH-1], g_rptr_sync[PTR_WIDTH-2:0]});

  always @(posedge wclk or negedge wrst_n) begin
    if (!wrst_n) begin
      b_wptr <= 0;
      g_wptr <= 0;
    end else begin
      b_wptr <= b_wptr_next;
      g_wptr <= g_wptr_next;
    end
  end

  always @(posedge wclk or negedge wrst_n) begin
    if (!wrst_n)
      full <= 0;
    else
      full <= wfull;
  end
endmodule

// ==================== Read Pointer Handler ====================
module rptr_handler #(parameter PTR_WIDTH=3) (
  input wire rclk,
  input wire rrst_n,
  input wire r_en,
  input wire [PTR_WIDTH:0] g_wptr_sync,
  output reg [PTR_WIDTH:0] b_rptr,
  output reg [PTR_WIDTH:0] g_rptr,
  output reg empty
);
  wire [PTR_WIDTH:0] b_rptr_next;
  wire [PTR_WIDTH:0] g_rptr_next;
  wire rempty;

  assign b_rptr_next = b_rptr + (r_en & ~empty);
  assign g_rptr_next = (b_rptr_next >> 1) ^ b_rptr_next;
  assign rempty = (g_rptr_next == g_wptr_sync);

  always @(posedge rclk or negedge rrst_n) begin
    if (!rrst_n) begin
      b_rptr <= 0;
      g_rptr <= 0;
    end else begin
      b_rptr <= b_rptr_next;
      g_rptr <= g_rptr_next;
    end
  end

  always @(posedge rclk or negedge rrst_n) begin
    if (!rrst_n)
      empty <= 1;
    else
      empty <= rempty;
  end
endmodule

// ==================== FIFO Memory ====================
module fifo_mem #(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=3) (
  input wire wclk,
  input wire w_en,
  input wire rclk,
  input wire r_en,
  input wire [ADDR_WIDTH:0] wptr,
  input wire [ADDR_WIDTH:0] rptr,
  input wire [DATA_WIDTH-1:0] data_in,
  output reg [DATA_WIDTH-1:0] data_out
);
  reg [DATA_WIDTH-1:0] fifo [0:(1<<ADDR_WIDTH)-1];

  always @(posedge wclk) begin
    if (w_en)
      fifo[wptr[ADDR_WIDTH-1:0]] <= data_in;
  end

  always @(posedge rclk) begin
    if (r_en)
      data_out <= fifo[rptr[ADDR_WIDTH-1:0]];
  end
endmodule

// ==================== Asynchronous FIFO Top ====================
module asynchronous_fifo #(
  parameter DEPTH = 8,
  parameter DATA_WIDTH = 8,
  parameter PTR_WIDTH = 3
)(
  input wire wclk, wrst_n,
  input wire rclk, rrst_n,
  input wire w_en, r_en,
  input wire [DATA_WIDTH-1:0] data_in,
  output wire [DATA_WIDTH-1:0] data_out,
  output wire full, empty
);

  wire [PTR_WIDTH:0] g_wptr, g_rptr;
  wire [PTR_WIDTH:0] g_wptr_sync, g_rptr_sync;
  wire [PTR_WIDTH:0] b_wptr, b_rptr;

  synchronizer #(PTR_WIDTH+1) sync_rptr (.clk(wclk), .rst_n(wrst_n), .d_in(g_rptr), .d_out(g_rptr_sync));
  synchronizer #(PTR_WIDTH+1) sync_wptr (.clk(rclk), .rst_n(rrst_n), .d_in(g_wptr), .d_out(g_wptr_sync));

  wptr_handler #(PTR_WIDTH) wptr_h (
    .wclk(wclk),
    .wrst_n(wrst_n),
    .w_en(w_en),
    .g_rptr_sync(g_rptr_sync),
    .b_wptr(b_wptr),
    .g_wptr(g_wptr),
    .full(full)
  );

  rptr_handler #(PTR_WIDTH) rptr_h (
    .rclk(rclk),
    .rrst_n(rrst_n),
    .r_en(r_en),
    .g_wptr_sync(g_wptr_sync),
    .b_rptr(b_rptr),
    .g_rptr(g_rptr),
    .empty(empty)
  );

  fifo_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(PTR_WIDTH)) fifom (
    .wclk(wclk),
    .w_en(w_en & ~full),
    .rclk(rclk),
    .r_en(r_en & ~empty),
    .wptr(b_wptr),
    .rptr(b_rptr),
    .data_in(data_in),
    .data_out(data_out)
  );
endmodule

// ==================== Testbench ====================
module async_fifo_tb;

  parameter DATA_WIDTH = 8;
  parameter DEPTH = 8;
  parameter PTR_WIDTH = 3;

  reg wclk, rclk;
  reg wrst_n, rrst_n;
  reg w_en, r_en;
  reg [DATA_WIDTH-1:0] data_in;
  wire [DATA_WIDTH-1:0] data_out;
  wire full, empty;

  asynchronous_fifo #(
    .DEPTH(DEPTH),
    .DATA_WIDTH(DATA_WIDTH),
    .PTR_WIDTH(PTR_WIDTH)
  ) dut (
    .wclk(wclk),
    .wrst_n(wrst_n),
    .rclk(rclk),
    .rrst_n(rrst_n),
    .w_en(w_en),
    .r_en(r_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
  );

  // Clock generation
  initial begin
    wclk = 0; rclk = 0;
    forever begin
      #5 wclk = ~wclk;
      #3 rclk = ~rclk;
    end
  end

  // Tasks
  task write(input [7:0] din);
    begin
      @(posedge wclk);
      if (!full) begin
        w_en <= 1;
        data_in <= din;
      end
      @(posedge wclk);
      w_en <= 0;
    end
  endtask

  task read();
    begin
      @(posedge rclk);
      if (!empty) r_en <= 1;
      @(posedge rclk);
      r_en <= 0;
    end
  endtask

  integer i;

  initial begin
    w_en = 0; r_en = 0; data_in = 0;
    wrst_n = 0; rrst_n = 0;
    #20;
    wrst_n = 1; rrst_n = 1;

    $display("=== FIFO WRITE START ===");
    for (i = 0; i < DEPTH; i = i + 1) begin
      write(i + 1);
      $display("WROTE: %0d, FULL: %b", i + 1, full);
    end
    write(99); // attempt when full
    $display("Tried writing when full. FULL: %b", full);

    #50;
    $display("=== FIFO READ START ===");
    for (i = 0; i < DEPTH; i = i + 1) begin
      read();
      @(posedge rclk);
      $display("READ: %0d, EMPTY: %b", data_out, empty);
    end
    read(); // attempt when empty
    $display("Tried reading when empty. EMPTY: %b", empty);

    #50;
    $display("=== ASYNC READ-WRITE MIX ===");
    for (i = 0; i < 4; i = i + 1) begin
      write(100 + i);
      read();
      @(posedge rclk);
      $display("WROTE: %0d, READ: %0d", 100 + i, data_out);
    end

    $display("=== TEST COMPLETE ===");
    #50;
    $finish;
  end

endmodule

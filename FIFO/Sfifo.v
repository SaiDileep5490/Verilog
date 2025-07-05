`timescale 1ns / 1ps

module Sfifo (
    input clk,
    input rst,
    input cs,
    input wrt_en,
    input rd_en,
    input [31:0] data_in,
    output reg [31:0] data_out,
    output full,
    output empty
);
    parameter FIFO_DEPTH = 8, FIFO_WIDTH = 32;

    reg [FIFO_WIDTH-1:0] fifo [FIFO_DEPTH-1:0];
    reg [2:0] wrt_ptr = 0, rd_ptr = 0;
    reg [3:0] fifo_count = 0; // Range: 0 to FIFO_DEPTH

    // Write Operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wrt_ptr <= 0;
        end else if (cs && wrt_en && !full) begin
            fifo[wrt_ptr] <= data_in;
            wrt_ptr <= wrt_ptr + 1;
        end
    end

    // Read Operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_ptr <= 0;
            data_out <= 0;
        end else if (cs && rd_en && !empty) begin
            data_out <= fifo[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end

    // FIFO Counter for full/empty
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fifo_count <= 0;
        end else begin
            case ({cs && wrt_en && !full, cs && rd_en && !empty})
                2'b10: fifo_count <= fifo_count + 1; // Write only
                2'b01: fifo_count <= fifo_count - 1; // Read only
                default: fifo_count <= fifo_count;   // No change or simultaneous R/W
            endcase
        end
    end

    assign empty = (fifo_count == 0);
    assign full  = (fifo_count == FIFO_DEPTH);

endmodule



`timescale 1ns / 1ps

module tb;

    reg clk;
    reg rst;
    reg cs;
    reg wrt_en;
    reg rd_en;
    reg [31:0] data_in;
    wire [31:0] data_out;
    wire full;
    wire empty;

    integer i;

    // Instantiate the FIFO module
    Sfifo f1 (
        .clk(clk),
        .rst(rst),
        .cs(cs),
        .wrt_en(wrt_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Write task
    task write_data(input [31:0] d_in);
    begin
        @(posedge clk);
        cs = 1; wrt_en = 1; data_in = d_in;
        @(posedge clk);
        wrt_en = 0;
        $display($time, " WRITE: data_in = %0d, full = %b", d_in, full);
    end
    endtask

    // Read task
    task read_data();
    begin
        @(posedge clk);
        cs = 1; rd_en = 1;
        @(posedge clk);
        rd_en = 0;
        $display($time, " READ : data_out = %0d, empty = %b", data_out, empty);
    end
    endtask

    // Testbench main logic
    initial begin
        // Initialize all signals
        clk = 0;
        rst = 1;
        cs = 0;
        wrt_en = 0;
        rd_en = 0;
        data_in = 0;

        // Apply reset
        @(posedge clk);
        rst = 0;

        // -------------------------
        $display($time, " Case 1: Basic write and read");
        write_data(1);
        write_data(10);
        write_data(100);
        read_data();
        read_data();
        read_data();

        // -------------------------
        $display($time, " Case 2: Write and read alternatively");
        for (i = 0; i < 8; i = i + 1) begin
            write_data(2**i);
            read_data();
        end

        // -------------------------
        $display($time, " Case 3: Fill FIFO to full");
        for (i = 0; i < 8; i = i + 1) begin
            write_data(100 + i);
        end

        // Try writing when FIFO is full
        $display($time, " Case 3.1: Try writing when FIFO is full");
        write_data(999);  // Should not be written

        // -------------------------
        $display($time, " Case 4: Empty the FIFO");
        for (i = 0; i < 8; i = i + 1) begin
            read_data();
        end

        // Try reading when FIFO is empty
        $display($time, " Case 4.1: Try reading when FIFO is empty");
        read_data();  // Should do nothing

        // -------------------------
        $display($time, " Case 5: Simultaneous write and read");
        for (i = 0; i < 4; i = i + 1) begin
            @(posedge clk);
            cs = 1; wrt_en = 1; rd_en = 1;
            data_in = 200 + i;
            @(posedge clk);
            wrt_en = 0; rd_en = 0;
            $display($time, " Simul: Wrote %0d, Read %0d", data_in, data_out);
        end

        #50;
        $display("Testbench completed.");
        $finish;
    end

endmodule

 
 




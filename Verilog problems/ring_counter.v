`timescale 1ns / 1ps

module ring_counter (
    input  clk,       // Clock input
    input  rst,       // Synchronous reset
    output reg [3:0] out  // 4-bit ring counter output
);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b1000;        // Initial state (only one bit high)
        else
            out <= {out[2:0], out[3]};  // Circular shift left
    end

endmodule



module tb_ring_counter;
    reg clk, rst;
    wire [3:0] out;

    ring_counter uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;  // 10ns clock period

    initial begin
 $display("  Time   |  out");
 $monitor("Time = %0t | out = %b", $time, out);
        rst = 1;
        #10 rst = 0;

        #100 $finish;
    end
endmodule

`timescale 1ns / 1ps

// ========== Decade Counter ==========
// Counts from 0000 (0) to 1001 (9), then rolls over to 0000
module decade_counter (
    input clk,
    input rst,       // Active-low reset
    input en,        // Enable count
    output reg [3:0] out
);

    always @(posedge clk) begin
        if (!rst)
            out <= 4'b0000;
        else if (en) begin
            if (out == 4'b1001)  // If count reaches 9
                out <= 4'b0000;
            else
                out <= out + 1;
        end
    end
endmodule


module tb1();
    reg clk, en, rst;
    wire [3:0] out;

    // Instantiate the counter
    decade_counter uut(clk, rst, en, out);

    // Clock generation (10 ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Apply stimulus
    initial begin
 $display(" rst | en | out");
 $monitor(" %b  |  %b  | %d",  rst, en, out);

        rst = 0; en = 0;     // Hold in reset
        #10 rst = 1; en = 1; // Release reset and enable count
        #200;                // Let it count a few cycles
        $finish;
    end

    
endmodule

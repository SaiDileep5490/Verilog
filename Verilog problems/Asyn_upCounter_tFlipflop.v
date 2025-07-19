`timescale 1ns / 1ps

// ---------- T Flip-Flop ----------
module tff (
    input clk,
    input rst,
    input t,
    output reg q
);
    always @(negedge clk or negedge rst) begin
        if (!rst)
            q <= 0;
        else if (t)
            q <= ~q;
    end
endmodule

// ---------- Asynchronous 4-bit Up Counter using T Flip-Flops ----------
module Asyn_upCounter_tFlipflop (
    input clk,
    input rst,
    output [3:0] q,
    output q0, q1, q2, q3
);

    // Instantiate 4 T flip-flops for the counter
    tff t1(clk,  rst, 1'b1, q0);       // LSB
    tff t2(q0, rst, 1'b1, q1);
    tff t3(q1, rst, 1'b1, q2);
    tff t4(q2, rst, 1'b1, q3);        // MSB

    assign q = {q3, q2, q1, q0};       // Final 4-bit output

endmodule


`timescale 1ns / 1ps

module tb_Asyn_upCounter_tFlipflop;

    reg clk;
    reg rst;
    wire [3:0] q;
    wire q0, q1, q2, q3;

  
    Asyn_upCounter_tFlipflop uut (
        .clk(clk),
        .rst(rst),
        .q(q),
        .q0(q0),
        .q1(q1),
        .q2(q2),
        .q3(q3)
    );

    // Generate a 10 ns clock
    initial clk = 0;
    always #5 clk = ~clk;

    // Dump waveform for GTKWave
    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0, tb_Asyn_upCounter_tFlipflop);
    end

    // Apply reset and observe
    initial begin
        $display("Time | rst | q3 q2 q1 q0 | Count");
        $monitor("%4t |  %b  |  %b  %b  %b  %b |  %b", $time, rst, q3, q2, q1, q0, q);

        rst = 0;     // Apply reset
        #10 rst = 1; // Release reset
        #200;        // Observe for 200ns
        $finish;
    end

endmodule

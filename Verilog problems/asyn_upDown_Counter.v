`timescale 1ns / 1ps

module tff (
    input clk,
    input rst,
    input t,
    output reg q,
    output q_bar
);
    always @(negedge clk or negedge rst) begin
        if (!rst)
            q <= 0;
        else if (t)
            q <= ~q;
    end

    assign q_bar = ~q;
endmodule


module Async_UpDownCounter (
    input clk,
    input rst,
    input up_down,          // 1 for up, 0 for down
    output [3:0] q,
    output q0, q1, q2, q3
);

    wire _q0, _q1, _q2, _q3;
    wire q0_bar, q1_bar, q2_bar;

    wire clk1 = up_down ? _q0    : q0_bar;
    wire clk2 = up_down ? _q1    : q1_bar;
    wire clk3 = up_down ? _q2    : q2_bar;

    // T flip-flops with ripple clocking based on up_down control
    tff t1(clk,     rst, 1'b1, _q0, q0_bar);   // LSB
    tff t2(clk1,    rst, 1'b1, _q1, q1_bar);
    tff t3(clk2,    rst, 1'b1, _q2, q2_bar);
    tff t4(clk3,    rst, 1'b1, _q3,       );   // MSB (no q_bar needed)

    assign q = {_q3, _q2, _q1, _q0};
    assign q0 = _q0;
    assign q1 = _q1;
    assign q2 = _q2;
    assign q3 = _q3;

endmodule


module tb_Async_UpDownCounter;

    reg clk;
    reg rst;
    reg up_down;
    wire [3:0] q;
    wire q0, q1, q2, q3;

    // Instantiate the counter
    Async_UpDownCounter uut (
        .clk(clk),
        .rst(rst),
        .up_down(up_down),
        .q(q),
        .q0(q0),
        .q1(q1),
        .q2(q2),
        .q3(q3)
    );

    // Clock generation (10 ns period)
    initial clk = 0;
    always #5 clk = ~clk;

    // VCD waveform output
   

    // Test stimulus
    initial begin
$display(" up_down | q3 q2 q1 q0 | Count");
$monitor(" %b  |  %b  %b  %b  %b | %b",  up_down, q3, q2, q1, q0, q);

        // Reset and up count
        rst = 0; up_down = 1;
        #10 rst = 1;

        #80;

        // Now count down
        up_down = 0;
        #80;

        $finish;
    end
endmodule

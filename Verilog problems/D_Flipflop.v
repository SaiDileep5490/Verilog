`timescale 1ns / 1ps

module D_Flipflop (
    input clk,
    input d,
    output reg q,
    output reg q_bar
);

always @(posedge clk) begin
    q     <= d;
    q_bar <= ~d;
end

endmodule

   
// Test Bench
module tb;
    reg clk;
    reg d;
    wire q, q_bar;

    // Correct instance of D_Flipflop
    D_Flipflop d1 (
        .clk(clk),
        .d(d),
        .q(q),
        .q_bar(q_bar)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
$display(" D | Q ~Q");
$monitor(" %b | %b  %b",  d, q, q_bar);

        d = 0;
        #5 d = 1;
        #15 d = 0;
        #30 $finish;
    end
endmodule


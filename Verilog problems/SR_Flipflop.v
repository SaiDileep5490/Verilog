`timescale 1ns / 1ps

module SR_Flipflop (
    input clk,
    input s,
    input r,
    output reg q,
    output reg q_bar
);

always @(posedge clk) begin
    if (s == 0 && r == 0) begin
        // No change (hold previous state)
        q     <= q;
        q_bar <= q_bar;
    end
    else if (s == 0 && r == 1) begin
        q     <= 0;
        q_bar <= 1;
    end
    else if (s == 1 && r == 0) begin
        q     <= 1;
        q_bar <= 0;
    end
    else if (s == 1 && r == 1) begin
        q     <= 1'bx; // Invalid state
        q_bar <= 1'bx;
    end
end

endmodule
// Test Bench
module tb;
reg clk;
reg s,r;
wire q,q_bar;

SR_Flipflop s1(.clk(clk),
               .s(s),
               .r(r),
               .q(q),
               .q_bar(q_bar)
               );
               
initial clk =0;
always #5 clk = ~clk;
initial begin

$display(" S   R   |  Q   ~Q");
$monitor(" %b   %b   |  %b   %b",s,r,q,q_bar);

s =0 ; r=0;
#5 s=0 ; r =1;
#5 s= 0 ; r=0;
#5 s = 1; r = 0;
#5 s = 0 ; r = 0;
#5 s = 1 ; r=1;
#50 $finish;
end
endmodule

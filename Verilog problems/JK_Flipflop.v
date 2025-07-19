`timescale 1ns / 1ps

module JK_Flipflop (
    input clk,
    input j,
    input k,
    output reg q,
    output reg q_bar
);

always @(posedge clk) begin
    case({j,k})
    2'b00 : begin
            q <= q;
            q_bar <= q_bar;
            end
    2'b01 : begin
            q <= 0;
            q_bar <= 1;
            end
    2'b10 : begin
            q <= 1;
            q_bar <= 0;
            end
    2'b11 : begin
            q <= ~q;
            q_bar <= q;
            end
            endcase
            
end

endmodule
// Test Bench
module tb;
reg clk;
reg j,k;
wire q,q_bar;

JK_Flipflop j1(.clk(clk),
               .j(j),
               .k(k),
               .q(q),
               .q_bar(q_bar)
               );
               
initial clk =0;
always #5 clk = ~clk;
initial begin

$display(" J   K   |  Q   ~Q");
$monitor(" %b   %b   |  %b   %b",j,k,q,q_bar);

j =0 ; k=0;
#5 j=0 ; k =1;
#5 j= 0 ; k=0;
#5 j = 1; k = 0;
#5 j = 0 ; k = 0;
#5 j = 1 ; k=1;
#50 $finish;
end
endmodule

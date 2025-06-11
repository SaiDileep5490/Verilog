`timescale 1ns / 1ps

module add_sub(sum, carry_out, a, b, mode);
output [3:0] sum;
output carry_out;
input [3:0] a, b;
input mode;

wire [3:0] b_xor;
wire c1, c2, c3;

assign b_xor = b ^ {4{mode}};

full_add f0(sum[0], c1, a[0], b_xor[0], mode);
full_add f1(sum[1], c2, a[1], b_xor[1], c1);
full_add f2(sum[2], c3, a[2], b_xor[2], c2);
full_add f3(sum[3], carry_out, a[3], b_xor[3], c3);

endmodule

module full_add(sum, carry, a, b, c_in);
output sum, carry;
input a, b, c_in;

wire t1, t2, t3;

xor x1(t1, a, b);
xor x2(sum, t1, c_in);
and a1(t2, a, b);
and a2(t3, t1, c_in);
or o1(carry, t2, t3);

endmodule


module tb;
reg [3:0] a, b;
reg mode;
wire [3:0] sum;
wire carry_out;

add_sub uut(sum, carry_out, a, b, mode);

initial begin
  $display("A      B      Mode | Result  Carry");
  $monitor("%b  %b   %b    |  %b     %b", a, b, mode, sum, carry_out);

  a = 4'b0101; b = 4'b0011; mode = 0; #10
  a = 4'b0101; b = 4'b0011; mode = 1; #10
  a = 4'b1111; b = 4'b0001; mode = 0; #10
  a = 4'b1111; b = 4'b0001; mode = 1; #10
  a = 4'b1000; b = 4'b1000; mode = 0; #10
  a = 4'b1000; b = 4'b1000; mode = 1; #10

  $finish;
end
endmodule

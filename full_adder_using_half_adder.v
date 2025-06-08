`timescale 1ns / 1ps

module half_add(sum,carry,a,b);
output sum,carry;
input a,b;
xor a1(sum,a,b);
and a2(carry,a,b);
endmodule

module Full_adder(sum,carry ,a,b,c_in );
output sum,carry;
input a,b,c_in;

wire t1,t2,t3;

half_add h1(t1,t2,a,b);
half_add h2(sum,t3,t1,c_in);

assign carry = (t2|t3);

endmodule

module tb;
reg a,b,c_in;
wire sum,carry;

Full_adder f1(sum,carry,a,b,c_in);
initial begin
$display(" A  B  Cin  |  SUM  CARRY");
$monitor(" %b  %b  %b    |  %b    %b ",a,b,c_in,sum,carry);
a = 0; b = 0;c_in=0; #10;
a = 0; b = 1; c_in=1;#10;
a = 1; b = 0;c_in=1; #10;
a = 1; b = 1;c_in =1; #10;
#50 $finish;
    end
endmodule

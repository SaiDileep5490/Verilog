`timescale 1ns / 1ps

module Full_adder(sum,carry ,a,b,c_in );
output sum,carry;
input a,b,c_in;
// data model
assign  sum = a^b^c_in;
assign carry = (a&b)|(b&c_in)|(a&c_in);

// gate level model
/*
wire t1,t2,t3;
xor a1(t1,a,b);
xor a2(sum,t1,c_in);
and b1(t2,a,b);
and b2(t3,t1,c_in);
or m1(carry,t2,t3);
*/

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

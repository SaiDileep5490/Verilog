`timescale 1ns / 1ps

module full_add(sum,carry,a,b,c_in);
output sum,carry;
input a,b,c_in;
wire t1,t2,t3;

xor x1(t1,a,b);
xor x2(sum,t1,c_in);
and a1(t2,a,b);
and a2(t3,t1,c_in);
or o1(carry,t2,t3);
endmodule

module rip_adder(sum,carry,a,b,c_in);
output [3:0]sum;
output carry;
input [3:0]a,b;
input c_in;

wire w1,w2,w3;

full_add f1(sum[0],w1,a[0],b[0],c_in);
full_add f2(sum[1],w2,a[1],b[1],w1);
full_add f3(sum[2],w3,a[2],b[2],w2);
full_add f4(sum[3],carry,a[3],b[3],w3);

endmodule


 module tb( );
 reg [3:0] a,b;
 reg c_in;
 wire [3:0] sum;
 wire carry;
 rip_adder uut (sum,carry,a,b,c_in);
 initial begin
 $display("A    B    C_in  |  SUM     CARRY");
 $monitor( "%b  %b  %b  | %b   %b",a,b,c_in,sum,carry);
 a=4'b0000; b=4'b0101; c_in=0; #10
 a=4'b0110; b=4'b0101; c_in=1; #10
 a=4'b0110; b=4'b1111; c_in=0; #10
 a=4'b1111; b=4'b1111; c_in=1; #10
 $finish;
end
endmodule

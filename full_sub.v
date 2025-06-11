`timescale 1ns / 1ps


module full_sub(diff,bor,a,b,b_in );
output diff,bor;
input a,b,b_in;
// data flow modeling
wire t1,t2,t3;
assign t1 = a^b;
assign diff = t1^b_in;
assign t2 = (~a) &(b);
assign t3 = (~t1) &(b_in);
assign bor = t2|t3;

/*
gate level
xor x1(t1,a,b);
xor x2(diff,t1,b_in);
not n1(t4,a);
and a1(t2,t4,b);
not n2(t5,t1);
and a2(t3,t5,b_in);
or o1(bor,t2,t3);
*/
endmodule


module tb;
reg a,b,b_in;
wire diff,bor;

full_sub S1(diff,bor,a,b,b_in);
initial begin
$display(" A  B  B_in  |   DIFFERENCE BORROW");
$monitor(" %b   %b   %b   |      %b      %b",a,b,b_in,diff,bor);
#10 a=0;b=0;b_in=0;
#10 a=0;b=0;b_in=1;
#10 a=0;b=1;b_in=0;
#10 a=0;b=1;b_in=1;
#10 a=1;b=0;b_in=0;
#10 a=1;b=0;b_in=1;
#10 a=1;b=1;b_in=0;
#10 a=1;b=1;b_in=1;
#10 $finish;
end
endmodule


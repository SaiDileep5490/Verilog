`timescale 1ns / 1ps


module half_sub(diff,borrow,a,b );
output diff,borrow;
input a,b; 
//data flow level
assign diff = a^b;
assign borrow = (~a)&(b);

//gate level
/*
wire t1;
not n1(t1,a);
xor x1(diff,a,b);
and x2(t1,b);
*/
endmodule

module tb;
reg a,b;
wire diff,borrow;
half_sub S1(diff,borrow,a,b);
initial
begin
$display(" A  B  | DIFFERENCE  BORROW");
$monitor(" %b   %b   |   %b       %b",a,b,diff,borrow);
#10 a=0;b=0;
#10 a=0;b=1;
#10 a=1;b=0;
#10 a=1;b=1;
#20 $finish;
end
endmodule

`timescale 1ns / 1ps

module half_sub(diff,bor,a,b);
output diff,bor;
input a,b;
wire w1;
not n1(w1,a);
xor x1(diff,a,b);
and a1(bor,w1,b);
endmodule


module full_sub(diff,bor,a,b,b_in );
output diff,bor;
input a,b,b_in;
wire t1,t2,t3;
half_sub x1(t1,t2,a,b);
half_sub x2(diff,t3,t1,b_in);

assign bor = t2|t3;

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




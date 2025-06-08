`timescale 1ns / 1ps

module logic_gates(out_and,out_or,out_nand,out_nota,out_notb,out_nor,out_xor,out_xnor,a,b);
output out_and,out_or,out_nota,out_notb,out_nand,out_nor,out_xor,out_xnor;
input a,b;
and A1(out_and,a,b);
or  O1(out_or,a,b);
not N1(out_nota,a);
not N2(out_notb,b);
nand n1(out_nand,a,b);
nor n2(out_nor,a,b);
xor x1(out_xor,a,b);
xnor x2(out_xnor,a,b);

endmodule

module tb;
reg a,b;
wire out_and,out_or,out_nota,out_notb,out_nand,out_nor,out_xor,out_xnor;
logic_gates L1(out_and,out_or,out_nand,out_nota,out_notb,out_nor,out_xor,out_xnor,a,b);
initial
begin
 $display("A B | AND OR NAND NOTA NOTB NOR XOR XNOR");
$monitor("%b %b |  %b   %b   %b    %b    %b   %b   %b", a, b, out_and, out_or, out_nand, out_nota, out_notb, out_nor, out_xor, out_xnor);
#5 a= 0;b=0;
#5 a= 0; b= 1;
#5 a=1;b=0;
#5 a=1;b=1;
#25 $finish;
end
endmodule

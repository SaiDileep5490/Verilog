`timescale 1ns / 1ps

module logic_gates(out_and,out_or,out_nand,out_nota,out_notb,out_nor,out_xor,out_xnor,a,b );
output out_and,out_or,out_nand,out_nota,out_notb,out_nor,out_xor,out_xnor;
input a,b;
assign out_and = a&b;
assign out_or = a|b;
assign out_nota= ~a;
assign out_notb = ~b;
assign out_nand = ~(a&b);
assign out_nor = ~(a|b);
assign out_xor = a^b;
assign out_xnor = ~(a^b);
endmodule

module tb;
reg a,b;
wire out_and,out_or,out_nand,out_nota,out_notb,out_nor,out_xor,out_xnor;

logic_gates G1(out_and,out_or,out_nand,out_nota,out_notb,out_nor,out_xor,out_xnor,a,b);
initial begin
$display( " A  B  | and  or  notA  notB  nand  nor  xor  xnor ");
$monitor(" %b  %b  | %b    %b   %b      %b     %b     %b    %b     %b",a,b,out_and,out_or,out_nota,out_notb,out_nand,out_nor,out_xor,out_xnor);
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;
        #70 $finish;
    end

endmodule
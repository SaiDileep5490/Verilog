`timescale 1ns / 1ps


 module up_down_counter(clk,rst,en,out);
 input clk,rst,en;
 output reg[2:0] out;
 always @(posedge clk)
    begin
        if(!rst)
            out=3'b000;
        else if (en)
            out=out+1;
        else
            out=out-1;
    end
 endmodule
 

 module tb1();
 reg clk,en,rst;
 wire[2:0]out;
 up_down_counter uut(clk,rst,en,out);
 initial
 begin
 clk=0;
 forever #5 clk=~clk;
end
 initial
 begin
 en=0;rst=1; #5
 en=1;rst=0; #5
 en=1;rst=1;#85
 en=0;rst=1; #90
 $finish;
 end
 endmodule
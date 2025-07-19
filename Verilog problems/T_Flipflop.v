 module t_ff(t,rst,clk,q  );
 input clk,t,rst;
 output reg q;
 always@(posedge clk)
 begin
 if(!rst)
 q=1'b0;
 else if(t)
 q=~q;
 end
 endmodule
 //TestBench:
 module tb10();
 reg clk,t,rst;
 wire q;
 t_ff uut(t,rst,clk,q);
 initial
 begin
 clk=0;
 forever #5 clk=~clk;
 end
 initial
 begin
rst =0;#7
 rst=1;t=0; #10
 t=1; #10
 t=1; #10
 rst=0;t=0; #10
 rst=1;t=1; #10
 t=0; #10
 $finish;
 end
 endmodule
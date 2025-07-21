`timescale 1ns / 1ps

module Tristate_Buffer(in,out,en  );
input en;
input in;
output out;

assign out = en ? in : 1'bz;

endmodule

module tb();
reg en;
reg in;
wire out;

Tristate_Buffer t1(.in(in),
                   .en(en),
                   .out(out)
                   );
                   
initial begin
$display( " En In    | Out ");
$monitor(" %b  %b     |  %b ", en,in,out);

en =0 ; in =0;
#5 en =0 ; in =1;
#5 en =1 ; in =0;
#5 en =1; in =1;

#10 $finish;
end
endmodule

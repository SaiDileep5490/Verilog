`timescale 1ns / 1ps


module Odd_Parity_Checker(
input [3:0]in,
input pb,
output Error
 );
 
 assign Error = ~((^in) ^ pb);
 
endmodule


module tb;
  reg [3:0] in;
  reg pb;
  wire Error;

  Odd_Parity_Checker uut(
    .in(in),
    .pb(pb),
    .Error(Error)
  );

  initial begin
    $display("  Input |  Parity Bit | Error");
    $monitor("  %b   |     %b      |   %b", in, pb, Error);

   
    in = 4'b0000; pb = 0; #5; 
    in = 4'b0001; pb = 1; #5; 
    in = 4'b1010; pb = 1; #5; 

    
    in = 4'b0001; pb = 0; #5; 
    in = 4'b1010; pb = 0; #5; 

    #10 $finish;
  end
endmodule

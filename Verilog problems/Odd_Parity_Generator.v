`timescale 1ns / 1ps



module Odd_Parity_Generator(
input [3:0]in,
output Pout
);

assign Pout =  (^in) ? 1'b0 : 1'b1;
endmodule


module tb;
  reg [3:0] in;
  wire Pout;

  Odd_Parity_Generator uut(
    .in(in),
    .Pout(Pout)
  );

  integer i;
initial in = 4'b0000;
 
  initial begin
    $display(" Input  | Parity");
    $monitor("  %b  |   %b", in, Pout);

    for (i = 0; i < 16; i = i + 1) begin
      in = i[3:0];
      #5;
    end

    #10 $finish;
  end
endmodule

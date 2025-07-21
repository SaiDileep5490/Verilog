`timescale 1ns / 1ps


module Even_Parity_Generator(
input [3:0]in,
output Pout
);

assign Pout =  ^in;
endmodule


module tb;
  reg [3:0] in;
  wire Pout;

  Even_Parity_Generator uut(
    .in(in),
    .Pout(Pout)
  );

  integer i;

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

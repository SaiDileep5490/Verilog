`timescale 1ns / 1ps


module Binary_to_Gray_Converter(bin,gout );
input [3:0]bin;
output [3:0] gout;

assign gout = bin ^ (bin >> 1);
endmodule

module tb;
  reg [3:0] bin;
  wire [3:0] gout;


  Binary_to_Gray_Converter uut (
    .bin(bin),
    .gout(gout)
  );

  initial begin
    $display(" Binary | Gray ");
    $monitor(" %b   | %b",  bin, gout);

    bin = 4'b0000; #5;
    bin = 4'b0001; #5;
    bin = 4'b0010; #5;
    bin = 4'b0011; #5;
    bin = 4'b0100; #5; 
    bin = 4'b0101; #5;
    bin = 4'b0110; #5;
    bin = 4'b0111; #5;
    bin = 4'b1000; #5;
    bin = 4'b1001; #5;
    bin = 4'b1010; #5; 
    bin = 4'b1011; #5;
    bin = 4'b1100; #5;
    bin = 4'b1101; #5;
    bin = 4'b1110; #5;
    bin = 4'b1111; #5;

    #10;
    $finish;
  end
endmodule

`timescale 1ns / 1ps

module Gray_to_Binary_Converter(
    input [3:0] gin,
    output [3:0] bout
);

assign bout[3] = gin[3];
assign bout[2] = bout[3] ^ gin[2];
assign bout[1] = bout[2] ^ gin[1];
assign bout[0] = bout[1] ^ gin[0];

endmodule

module tb;
  reg [3:0] gin;
  wire [3:0] bout;

  Gray_to_Binary_Converter uut(
    .gin(gin),
    .bout(bout)
  );

  integer i;

  initial begin
    $display(" Gray   | Binary");
    $display("-------------");
    $monitor("  %b  |  %b", gin, bout);

    for (i = 0; i < 16; i = i + 1) begin
      gin = i[3:0];
      #5;
    end

    #10 $finish;
  end
endmodule

`timescale 1ns / 1ps


module bcd_sevensegment_conv(D,a,b,c,d,e,f,g );
input[3:0]D;
output reg a,b,c,d,e,f,g;
integer i;
always @(*) begin
  case(D)
     4'b0000: {a,b,c,d,e,f,g} = 7'b1111110;
     4'b0001: {a,b,c,d,e,f,g} = 7'b0110000;
     4'b0010: {a,b,c,d,e,f,g} = 7'b1101101;
     4'b0011: {a,b,c,d,e,f,g} = 7'b1111001;
     4'b0100: {a,b,c,d,e,f,g} = 7'b0110011;
     4'b0101: {a,b,c,d,e,f,g} = 7'b1011011;
     4'b0110: {a,b,c,d,e,f,g} = 7'b1011111;
     4'b0111: {a,b,c,d,e,f,g} = 7'b1110000;
     4'b1000: {a,b,c,d,e,f,g} = 7'b1111111;
     4'b1001: {a,b,c,d,e,f,g} = 7'b1111011;
     default: {a,b,c,d,e,f,g} = 7'b0000000;
     endcase
    end
 endmodule

 module tb;
    reg [3:0] D;
    wire a, b, c, d, e, f, g;

    // Instantiate the DUT (Device Under Test)
    bcd_sevensegment_conv uut(D, a, b, c, d, e, f, g);

    integer i;

    initial begin
 $display("   D         |     a b c d e f g");
        for (i = 0; i < 16; i = i + 1) begin
            D = i[3:0];
            #10;
  $display("%d  | %b %b %b %b %b %b %b", i, a, b, c, d, e, f, g);
        end
        $finish;
    end
endmodule

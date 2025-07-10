`timescale 1ns / 1ps

module comparator(a, b, le, eq, ge);
    input [3:0] a, b;
    output le, eq, ge;

    assign le = a < b;
    assign eq = a == b;
    assign ge = a > b;
endmodule

module tb;
    reg [3:0] a, b;
    wire le, eq, ge;

    comparator c1 (
        .a(a),
        .b(b),
        .le(le),
        .eq(eq),
        .ge(ge)
    );

    initial begin 
        $display(" a       b    |  Le   Eq  Ge");
        $monitor(" %b   %b  |  %b   %b   %b", a, b, le, eq, ge);
        
        a = 4'b1011; b = 4'b1010; #5;
        a = 4'b0000; b = 4'b0000; #5;
        a = 4'b1010; b = 4'b1011; #5;
        a = 4'b1011; b = 4'b1010; #5;

        $finish;
    end
endmodule

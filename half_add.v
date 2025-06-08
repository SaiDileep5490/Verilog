`timescale 1ns / 1ps

module half_add(sum, carry, a, b);
    output sum, carry;
    input a, b;

    // Gate-level implementation
    xor X1(sum, a, b);
    and A1(carry, a, b);
    
    // Dataflow (commented)
    /*
    assign sum = a ^ b;
    assign carry = a & b;
    */
endmodule


module tb;
    reg a, b;
    wire sum, carry;

    half_add H1(sum, carry, a, b);

    initial begin
        $display(" A  B  |  SUM  CARRY");
        $monitor("%b  %b   |   %b     %b", a, b, sum, carry);

        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;

        #50 $finish;
    end
endmodule


`timescale 1ns / 1ps

//==================== Full Adder ====================
module full_adder(sum, carry, a, b, cin);
    output sum, carry;
    input a, b, cin;
    wire w1, w2, w3;

    xor x1(w1, a, b);
    and x2(w2, a, b);
    xor x3(sum, w1, cin);
    and x4(w3, w1, cin);
    or  x5(carry, w2, w3);
endmodule

//==================== 2:1 Multiplexer ====================
module mux2x1(y, s, i1, i0);
    output y;
    input s, i1, i0;
    wire sbar, w1, w2;

    not x1(sbar, s);
    and x2(w1, i0, sbar);
    and x3(w2, i1, s);
    or  x4(y, w1, w2);
endmodule

//==================== Carry Skip Adder ====================
module carrySkipAdder(sum, carry, a, b, c_in);
    output [3:0] sum;
    output carry;
    input [3:0] a, b;
    input c_in;

    wire [3:0] c, p;
    wire pout;

    // Instantiate 4 Full Adders
    full_adder Fa1(sum[0], c[0], a[0], b[0], c_in);
    full_adder Fa2(sum[1], c[1], a[1], b[1], c[0]);
    full_adder Fa3(sum[2], c[2], a[2], b[2], c[1]);
    full_adder Fa4(sum[3], c[3], a[3], b[3], c[2]);

    // Compute propagate signals
    xor (p[0], a[0], b[0]);
    xor (p[1], a[1], b[1]);
    xor (p[2], a[2], b[2]);
    xor (p[3], a[3], b[3]);

    and A5(pout, p[0], p[1], p[2], p[3]);

    // Select carry using skip logic
    mux2x1 M6(carry, pout, c_in, c[3]);  
endmodule

//==================== Testbench ====================
module carrySkipAdder_tb;
    reg [3:0] a, b;
    reg c_in;
    wire [3:0] sum;
    wire carry;

    // Instantiate the carrySkipAdder module
    carrySkipAdder uut (
        .sum(sum),
        .carry(carry),
        .a(a),
        .b(b),
        .c_in(c_in)
    );

    initial begin
        // Monitor outputs
        $monitor("Time = %0t | a = %b | b = %b | c_in = %b | sum = %b | carry = %b", 
                  $time, a, b, c_in, sum, carry);
        
        // Test Cases
        a = 4'b0000; b = 4'b0000; c_in = 0; #10;
        a = 4'b0001; b = 4'b0001; c_in = 0; #10;
        a = 4'b0011; b = 4'b0011; c_in = 0; #10;
        a = 4'b0110; b = 4'b0101; c_in = 1; #10;
        a = 4'b1111; b = 4'b1111; c_in = 0; #10;
        a = 4'b1010; b = 4'b0101; c_in = 1; #10;
        
        $finish;
    end
endmodule

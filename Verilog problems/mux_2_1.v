module x1_mux(
    input a,
    input b,
    input s,
    output out
);
    assign out = (~s & a) | (s & b);
endmodule


module tb1();
    reg a, b, s;
    wire out;

    
    x1_mux uut (
        .a(a),
        .b(b),
        .s(s),
        .out(out)
    );

    initial begin
      $display(" a   b   s   |  out");
      $monitor(" %b  %b   %b  |  %b",a,b,s,out);
        // Apply test vectors
        a = 0; b = 1; s = 0; #10;  // Expect out = a = 0
        a = 0; b = 1; s = 1; #10;  // Expect out = b = 1
        a = 1; b = 0; s = 0; #10;  // Expect out = a = 1
        a = 1; b = 0; s = 1; #10;  // Expect out = b = 0

        #50 $finish;  // End simulation
    end
endmodule

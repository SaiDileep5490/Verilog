
module x1_mux(
    input a, 
    input b, 
    input s, 
    output out
);
    assign out = (~s & a) | (s & b);
endmodule


module x8(
    input [7:0] in,
    input [2:0] sel,
    output out
);
    wire w1, w2, w3, w4, w5, w6;

    x1_mux m1(in[0], in[1], sel[0], w1);
    x1_mux m2(in[2], in[3], sel[0], w2);
    x1_mux m3(in[4], in[5], sel[0], w3);
    x1_mux m4(in[6], in[7], sel[0], w4);

    x1_mux m5(w1, w2, sel[1], w5);
    x1_mux m6(w3, w4, sel[1], w6);

    x1_mux m7(w5, w6, sel[2], out);
endmodule


module tb2();
    reg [7:0] in;
    reg [2:0] sel;
    wire out;

    x8 dut (in, sel, out);

    initial begin
        $monitor("Time=%0t | in=%b | sel=%b | out=%b", $time, in, sel, out);

        in = 8'b10101010;

        sel = 3'b000; #10;
        sel = 3'b001; #10;
        sel = 3'b010; #10;
        sel = 3'b011; #10;
        sel = 3'b100; #10;
        sel = 3'b101; #10;
        sel = 3'b110; #10;
        sel = 3'b111; #10;

        in = 8'b11101000;

        sel = 3'b000; #10;
        sel = 3'b010; #10;
        sel = 3'b001; #10;
        sel = 3'b011; #10;
        sel = 3'b100; #10;
        sel = 3'b101; #10;
        sel = 3'b110; #10;
        sel = 3'b111; #10;

        $finish;
    end
endmodule

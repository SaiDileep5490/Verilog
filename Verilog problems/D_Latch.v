`timescale 1ns / 1ps

module D_Latch (
    input d,
    input en,
    output reg q,
    output q_bar
);

    assign q_bar = ~q;

    always @(*) begin
        if (en)
            q = d;
        // else q retains its value
    end

endmodule


module tb;
    reg d, en;
    wire q, q_bar;

    D_Latch dut (
        .d(d),
        .en(en),
        .q(q),
        .q_bar(q_bar)
    );

    initial begin
 $display(" EN  D | Q ~Q");
$monitor( "  %b  %b | %b  %b", en, d, q, q_bar);

        // Initial state
        d = 0; en = 0;
        #5 en = 1; d = 1;  // latch input
        #5 en = 0; d = 0;  // hold
        #5 en = 1; d = 0;  // latch 0
        #5 en = 0; d = 1;  // hold
        #10 $finish;
    end
endmodule

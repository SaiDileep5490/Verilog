`timescale 1ns / 1ps



module SR_Nor_Latch (
    input s,
    input r,
    output q,
    output q_bar
);

    wire nq, nq_bar;

    nor (nq, r, nq_bar);
    nor (nq_bar, s, nq);

    assign q = nq;
    assign q_bar = nq_bar;

endmodule

// ========== Testbench ==========
module tb;
    reg s, r;
    wire q, q_bar;

    SR_Nor_Latch s1 (
        .s(s),
        .r(r),
        .q(q),
        .q_bar(q_bar)
    );

    initial begin
 $display(" S R | Q ~Q | Remark");
 $monitor(" %b %b | %b  %b | %s", s, r, q, q_bar,
                  (s == 0 && r == 0) ? "Hold" :
                  (s == 0 && r == 1) ? "Reset" :
                  (s == 1 && r == 0) ? "Set" :
                  "Invalid");

        // Stimulus
        s = 0; r = 0;  // Hold (initial)
        #5 s = 0; r = 1;  // Set
        #5 s = 0; r = 0;  // Hold
        #5 s = 1; r = 0;  // Reset
        #5 s = 0; r = 0;  // Hold
        #5 s = 1; r = 1;  // Invalid
        #10 $finish;
    end
endmodule

`timescale 1ns / 1ps

// SR Latch using NAND gates (Active-Low Inputs)
module SR_Nand_Latch (
    input s,
    input r,
    output q,
    output q_bar
);

    wire nq, nq_bar;

    nand (nq, s, nq_bar);
    nand (nq_bar, r, nq);

    assign q = nq;
    assign q_bar = nq_bar;

endmodule

// ========== Testbench ==========
module tb;
    reg s, r;
    wire q, q_bar;

    SR_Nand_Latch s1 (
        .s(s),
        .r(r),
        .q(q),
        .q_bar(q_bar)
    );

    initial begin
 $display(" S R | Q ~Q | Remark");
 $monitor(" %b %b | %b  %b | %s", s, r, q, q_bar,
                  (s == 0 && r == 0) ? "Invalid" :
                  (s == 0 && r == 1) ? "Set" :
                  (s == 1 && r == 0) ? "Reset" :
                  "Hold");

        // Stimulus
        s = 1; r = 1;  // Hold (initial)
        #5 s = 0; r = 1;  // Set
        #5 s = 1; r = 1;  // Hold
        #5 s = 1; r = 0;  // Reset
        #5 s = 1; r = 1;  // Hold
        #5 s = 0; r = 0;  // Invalid
        #10 $finish;
    end
endmodule

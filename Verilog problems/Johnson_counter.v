`timescale 1ns / 1ps

module johnson_counter (
    input  clk,       // Clock input
    input  rst,       // Synchronous reset
    output reg [3:0] out  // 4-bit Johnson counter output
);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;
        else
            out <= {out[2:0], ~out[3]};  // Twisted feedback
    end

endmodule


module tb_johnson_counter;

    reg clk, rst;
    wire [3:0] out;

    johnson_counter uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    initial clk = 0;
    always #5 clk = ~clk;  // Clock period: 10ns

    initial begin
        $monitor("Time=%0t | out = %b", $time, out);
        rst = 1;
        #10 rst = 0;

        #100 $finish;
    end
endmodule

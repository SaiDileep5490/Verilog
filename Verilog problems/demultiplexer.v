module eight_demux (
    input in,
    input en,
    input [2:0] sel,
    output reg [7:0] out
);
    always @(*) begin
        out = 8'b00000000; // Default
        if (en) begin
            case (sel)
                3'b000: out[0] = in;
                3'b001: out[1] = in;
                3'b010: out[2] = in;
                3'b011: out[3] = in;
                3'b100: out[4] = in;
                3'b101: out[5] = in;
                3'b110: out[6] = in;
                3'b111: out[7] = in;
                default: out = 8'b00000000;
            endcase
        end
    end
endmodule

module tb5();
    reg in, en;
    reg [2:0] sel;
    wire [7:0] out;

    // Instantiate the demux
    eight_demux dut (
        .in(in),
        .en(en),
        .sel(sel),
        .out(out)
    );

    initial begin
        $monitor("Time=%0t | in=%b | en=%b | sel=%b | out=%b", $time, in, en, sel, out);

        in = 1; en = 1;
        sel = 3'b000; #10;
        sel = 3'b001; #10;
        sel = 3'b010; #10;
        sel = 3'b011; #10;
        sel = 3'b100; #10;
        sel = 3'b101; #10;
        sel = 3'b110; #10;
        sel = 3'b111; #10;

        en = 0; #10;  // Output should go to all 0s
        en = 1; #10;  // Enable again
        in = 0; #10;  // in = 0, output should all be 0s
        in = 1; #10;  // in = 1 again
        $finish;
    end
endmodule

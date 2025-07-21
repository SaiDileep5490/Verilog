module decimal_to_bcd_encoder(
    input  [9:0] decimal_in,  // One-hot input
    output reg [3:0] bcd_out
);

always @(*) begin
    case (decimal_in)
        10'b0000000001: bcd_out = 4'b0000; // 0
        10'b0000000010: bcd_out = 4'b0001; // 1
        10'b0000000100: bcd_out = 4'b0010; // 2
        10'b0000001000: bcd_out = 4'b0011; // 3
        10'b0000010000: bcd_out = 4'b0100; // 4
        10'b0000100000: bcd_out = 4'b0101; // 5
        10'b0001000000: bcd_out = 4'b0110; // 6
        10'b0010000000: bcd_out = 4'b0111; // 7
        10'b0100000000: bcd_out = 4'b1000; // 8
        10'b1000000000: bcd_out = 4'b1001; // 9
        default:        bcd_out = 4'b1111; // Invalid input
    endcase
end

endmodule



module tb_decimal_to_bcd;
    reg [9:0] decimal_in;
    wire [3:0] bcd_out;

    decimal_to_bcd_encoder uut (
        .decimal_in(decimal_in),
        .bcd_out(bcd_out)
    );

    integer i;
    initial begin
        $display("Decimal Input -> BCD Output");
        for (i = 0; i < 10; i = i + 1) begin
            decimal_in = 10'b1 << i;
            #10;
            $display("    %b   ->   %b", decimal_in, bcd_out);
        end
        $stop;
    end
endmodule

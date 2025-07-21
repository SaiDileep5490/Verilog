`timescale 1ns / 1ps


module hex_to_binary_encoder(
    input [15:0] in,
    output [3:0] out
);

assign out[3] = in[8] | in[9] | in[10] | in[11] | in[12] | in[13] | in[14] | in[15];
assign out[2] = in[4] | in[5] | in[6] | in[7] | in[12] | in[13] | in[14] | in[15];
assign out[1] = in[2] | in[3] | in[6] | in[7] | in[10] | in[11] | in[14] | in[15];
assign out[0] = in[1] | in[3] | in[5] | in[7] | in[9] | in[11] | in[13] | in[15];

endmodule

module tb_hex_to_binary;
    reg [15:0] in;
    wire [3:0] out;

    hex_to_binary_encoder uut (
        .in(in),
        .out(out)
    );

    integer i;
    initial begin
        $display("Hex Input -> Binary Output");
        for (i = 0; i < 16; i = i + 1) begin
            in = 16'b1 << i;
            #10;
            $display(" %b -> %b", in, out);
        end
        $stop;
    end
endmodule

module octal_to_binary_encoder (
    input  [7:0] octal_in,     
    output reg [2:0] binary_out
);

always @(*) begin
    case (octal_in)
        8'b00000001: binary_out = 3'b000; // 0
        8'b00000010: binary_out = 3'b001; // 1
        8'b00000100: binary_out = 3'b010; // 2
        8'b00001000: binary_out = 3'b011; // 3
        8'b00010000: binary_out = 3'b100; // 4
        8'b00100000: binary_out = 3'b101; // 5
        8'b01000000: binary_out = 3'b110; // 6
        8'b10000000: binary_out = 3'b111; // 7
        default:     binary_out = 3'bxxx; 
    endcase
end

endmodule


module tb_octal_to_binary;
    reg [7:0] octal_in;
    wire [2:0] binary_out;

    octal_to_binary_encoder uut (
        .octal_in(octal_in),
        .binary_out(binary_out)
    );

    integer i;
    initial begin
        $display("Octal Input -> Binary Output");
        for (i = 0; i < 8; i = i + 1) begin
            octal_in = 8'b1 << i;
            #10;
            $display("   %b  ->  %b", octal_in, binary_out);
        end
        $stop;
    end
endmodule

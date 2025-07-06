module mux8to1 (
    input [7:0] in,       
    input [2:0] sel,      
    output out           
);
    assign out = in[sel]; 
endmodule

module tb_mux8to1();
    reg [7:0] in;
    reg [2:0] sel;
    wire out;

    // Instantiate the mux
    mux8to1 uut (
        .in(in),
        .sel(sel),
        .out(out)
    );

    initial begin
        $monitor("Time=%0t, in=%b, sel=%b, out=%b", $time, in, sel, out);

        in = 8'b10101010;

        sel = 3'b000; #10; 
        sel = 3'b001; #10; 
        sel = 3'b010; #10; 
        sel = 3'b011; #10; 
        sel = 3'b100; #10; 
        sel = 3'b101; #10; 
        sel = 3'b110; #10; 
        sel = 3'b111; #10; 

        #20 $finish;
    end
endmodule


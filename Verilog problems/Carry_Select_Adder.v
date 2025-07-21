`timescale 1ns / 1ps

module full_adder(sum,carry,a,b,cin);
output sum,carry;
input a,b,cin;
wire w1,w2,w3;
xor x1(w1,a,b);
and x2(w2,a,b);
xor x3(sum,w1,cin);
and x4(w3,w1,cin);
or x5(carry,w2,w3);
endmodule 


module mux2x1(y,s,i1,i0);
output y;
input s,i1,i0;
wire sbar,w1,w2;
not x1(sbar,s);
and x2(w1,i0,sbar);
and x3(w2,i1,s);
or x4(y,w1,w2);
endmodule 


module CSA4(cout, S, A, B, aOut, cin);
    output [3:0] S;
    output aOut;
    output cout;
    input [3:0] A, B;
    input cin;
    wire c1, c2, c3, Cout, p0, p1, p2, p3;

    full_adder F1(S[0], c1, A[0], B[0], cin);
    full_adder F2(S[1], c2, A[1], B[1], c1);
    full_adder F3(S[2], c3, A[2], B[2], c2);
    full_adder F4(S[3], Cout, A[3], B[3], c3);

    xor g0(p0, A[0], B[0]);
    xor g1(p1, A[1], B[1]);
    xor g2(p2, A[2], B[2]);
    xor g3(p3, A[3], B[3]);

    and v(aOut, p0, p1, p2, p3);
    
    mux2x1 m1(cout, aOut, cin, Cout);
endmodule


 module CSA4_tb;
    reg [3:0] A, B;
    reg cin;
    wire [3:0] S;
    wire cout;
    
    // Instantiate the CSA4 module
    CSA4 uut (
        .S(S),
        .cout(cout),
        .A(A),
        .B(B),
        .cin(cin)
    );
    
    initial begin
        // Initialize inputs
        A = 4'b0000; B = 4'b0000; cin = 1'b0;
        #10;
        
        A = 4'b0011; B = 4'b0101; cin = 1'b0;
        #10;
        
        A = 4'b1010; B = 4'b1100; cin = 1'b1;
        #10;
        
        A = 4'b1111; B = 4'b1111; cin = 1'b1;
        #10;
        
        A = 4'b0110; B = 4'b0011; cin = 1'b0;
        #10;
        
        A = 4'b0001; B = 4'b1001; cin = 1'b1;
        #10;
        
        // End simulation
        $stop;
    end
    
    initial begin
        $monitor("Time=%0t A=%b B=%b Cin=%b | Sum=%b Cout=%b", $time, A, B, cin, S, cout);
    end
    
endmodule
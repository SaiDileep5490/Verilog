`timescale 1ns / 1ps

`define S0 3'b000
`define S1 3'b001
`define S2 3'b010
`define S3 3'b011
`define S4 3'b100

`define RED    2'b00
`define YELLOW 2'b01
`define GREEN  2'b10

`define Y2RDELAY  3
`define R2GDELAY  5

module traffic_light_controller(
    output reg [1:0] highWay,
    output reg [1:0] countryRoad,
    input x,
    input clk,
    input clear
);

    reg [2:0] current_state, next_state;
    reg [2:0] counter; // 3-bit counter for delay

    // State Register
    always @(posedge clk or posedge clear) begin
        if (clear) begin
            current_state <= `S0;
            counter <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Output Logic
    always @(*) begin
        case(current_state)
            `S0: begin
                highWay = `GREEN;
                countryRoad = `RED;
            end
            `S1: begin
                highWay = `YELLOW;
                countryRoad = `RED;
            end
            `S2: begin
                highWay = `RED;
                countryRoad = `RED;
            end
            `S3: begin
                highWay = `RED;
                countryRoad = `GREEN;
            end
            `S4: begin
                highWay = `RED;
                countryRoad = `YELLOW;
            end
            default: begin
                highWay = `RED;
                countryRoad = `RED;
            end
        endcase
    end

    // Next-State Logic with Delay Counter
    always @(posedge clk or posedge clear) begin
        if (clear) begin
            next_state <= `S0;
            counter <= 0;
        end else begin
            case (current_state)
                `S0: begin
                    if (x)
                        next_state <= `S1;
                    else
                        next_state <= `S0;
                    counter <= 0;
                end
                `S1: begin
                    if (counter < `Y2RDELAY - 1)
                        counter <= counter + 1;
                    else begin
                        counter <= 0;
                        next_state <= `S2;
                    end
                end
                `S2: begin
                    if (counter < `R2GDELAY - 1)
                        counter <= counter + 1;
                    else begin
                        counter <= 0;
                        next_state <= `S3;
                    end
                end
                `S3: begin
                    if (!x) begin
                        next_state <= `S4;
                        counter <= 0;
                    end else begin
                        next_state <= `S3;
                        counter <= 0;
                    end
                end
                `S4: begin
                    if (counter < `Y2RDELAY - 1)
                        counter <= counter + 1;
                    else begin
                        counter <= 0;
                        next_state <= `S0;
                    end
                end
                default: begin
                    next_state <= `S0;
                    counter <= 0;
                end
            endcase
        end
    end
endmodule


module tb;
    reg x, clk, clear;
    wire [1:0] highWay, countryRoad;

    traffic_light_controller T1(highWay, countryRoad, x, clk, clear);

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10 ns period

    // Simulation control
    initial begin
        $monitor("Time: %0t | HW: %b, CR: %b | x: %b", $time, highWay, countryRoad, x);

        clear = 1; x = 0;
        #10 clear = 0;

        #20 x = 1;  // vehicle on country road
        #40 x = 0;

        #200 $finish;
    end
endmodule

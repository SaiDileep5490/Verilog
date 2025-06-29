`timescale 1ns / 1ps

module elevator_control (
    input clk,
    input rst,
    input [1:0] floor_select,
    output reg [1:0] current_floor,
    output reg door_status   // 1 = open, 0 = closed
);

    reg [1:0] current_state, next_state;
    reg [2:0] door_timer;  // 3-bit counter (can count up to 7)

    parameter GROUND_FLOOR = 2'b00,
              FIRST_FLOOR  = 2'b01,
              SECOND_FLOOR = 2'b10,
              THIRD_FLOOR  = 2'b11;

    parameter DOOR_OPEN_CYCLES = 3;

    // State Register
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= GROUND_FLOOR;
            door_timer <= 0;
            door_status <= 1'b1;
        end else begin
            current_state <= next_state;

            // Door logic
            if (current_state == floor_select) begin
                if (door_timer < DOOR_OPEN_CYCLES) begin
                    door_status <= 1'b1;
                    door_timer <= door_timer + 1;
                end else begin
                    door_status <= 1'b0;  // Auto close after timer expires
                end
            end else begin
                door_status <= 1'b0;      // Moving: door closed
                door_timer <= 0;         // Reset timer if moving
            end
        end
    end

    // Next State Logic
    always @(*) begin
        next_state = floor_select;
    end

    // Output Logic
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_floor <= GROUND_FLOOR;
        else
            current_floor <= current_state;
    end

endmodule


`timescale 1ns / 1ps

module tb_elevator_control;

    // Inputs
    reg clk;
    reg rst;
    reg [1:0] floor_select;

    // Outputs
    wire [1:0] current_floor;
    wire door_status;

    // Instantiate the Unit Under Test (UUT)
    elevator_control uut (
        .clk(clk),
        .rst(rst),
        .floor_select(floor_select),
        .current_floor(current_floor),
        .door_status(door_status)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        floor_select = 2'b00;

        // Reset system
        #10 rst = 0;

        // Go to 1st floor
        #10 floor_select = 2'b01;
        #50;

        // Go to 3rd floor
        floor_select = 2'b11;
        #50;

        // Go to 2nd floor
        floor_select = 2'b10;
        #50;

        // Back to ground
        floor_select = 2'b00;
        #50;

        $finish;
    end
  

    initial begin
        $monitor("Time=%0t | Floor Select=%b | Current Floor=%b | Door Status=%b", 
                 $time, floor_select, current_floor, door_status);
    end

endmodule

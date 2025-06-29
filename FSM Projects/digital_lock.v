`timescale 1ns / 1ps

module enhanced_digital_lock(
    input clk,
    input reset,
    input [3:0] entered_password,
    input submit,
    input change_mode_button,       // Button to hold for password change
    input [3:0] master_key_input,   // Input for master key
    input master_key_submit,        // Signal to submit master key
    input [3:0] new_password_input, // New password to set
    input new_password_submit,      // Signal to submit new password
    output reg door_unlock,
    output reg alarm,
    output reg [2:0] state_display  // For visual feedback
);
    // Internal Registers
    reg [3:0] SET_PASSWORD = 4'b1010;
    parameter [3:0] MASTER_KEY = 4'b1111;

    integer wrong_count = 0;
    integer alarm_counter = 0;
    integer hold_counter = 0;
    reg change_mode_flag = 0;
    reg alarm_active = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wrong_count <= 0;
            alarm <= 0;
            door_unlock <= 0;
            alarm_counter <= 0;
            alarm_active <= 0;
            change_mode_flag <= 0;
            hold_counter <= 0;
            state_display <= 3'b000;
        end
        else begin
            // Password Change Mode
            if (change_mode_button) begin
                hold_counter <= hold_counter + 1;
                if (hold_counter >= 5) begin
                    change_mode_flag <= 1;
                    state_display <= 3'b100; // CHANGE_MODE
                end
            end else begin
                hold_counter <= 0;
            end

            if (change_mode_flag) begin
                if (master_key_submit) begin
                    if (master_key_input == MASTER_KEY) begin
                        SET_PASSWORD <= new_password_input;
                        state_display <= 3'b101; // PASSWORD_UPDATED
                        change_mode_flag <= 0;
                    end else begin
                        state_display <= 3'b110; // INVALID_MASTER_KEY
                        change_mode_flag <= 0;
                    end
                end
            end
            else if (submit && !alarm_active) begin
                if (entered_password == SET_PASSWORD) begin
                    door_unlock <= 1;
                    wrong_count <= 0;
                    state_display <= 3'b001; // CORRECT
                end
                else begin
                    door_unlock <= 0;
                    wrong_count <= wrong_count + 1;
                    state_display <= 3'b010; // WRONG

                    if (wrong_count + 1 >= 3) begin
                        alarm <= 1;
                        alarm_active <= 1;
                        alarm_counter <= 0;
                    end
                end
            end

            // Alarm handling
            if (alarm_active) begin
                alarm_counter <= alarm_counter + 1;
                state_display <= 3'b011; // COUNT/ALARM
                if (alarm_counter >= 10) begin
                    alarm <= 0;
                    alarm_active <= 0;
                    wrong_count <= 0;
                    state_display <= 3'b000; // IDLE
                end
            end
        end
    end
endmodule


`timescale 1ns / 1ps

module enhanced_digital_lock_tb;
    // Inputs
    reg clk;
    reg reset;
    reg [3:0] entered_password;
    reg submit;
    reg change_mode_button;
    reg [3:0] master_key_input;
    reg master_key_submit;
    reg [3:0] new_password_input;
    reg new_password_submit;

    // Outputs
    wire door_unlock;
    wire alarm;
    wire [2:0] state_display;

    // Instantiate the Unit Under Test (UUT)
    enhanced_digital_lock uut (
        .clk(clk),
        .reset(reset),
        .entered_password(entered_password),
        .submit(submit),
        .change_mode_button(change_mode_button),
        .master_key_input(master_key_input),
        .master_key_submit(master_key_submit),
        .new_password_input(new_password_input),
        .new_password_submit(new_password_submit),
        .door_unlock(door_unlock),
        .alarm(alarm),
        .state_display(state_display)
    );

    // Clock generator
    always #5 clk = ~clk;

    // Task to simulate button press
    task press_submit(input [3:0] pass);
    begin
        entered_password = pass;
        submit = 1;
        #10;
        submit = 0;
        #20;
    end
    endtask

    // Task to simulate change password sequence
    task change_password(input [3:0] mkey, input [3:0] newpass);
    begin
        // Hold button
        change_mode_button = 1;
        #60;
        change_mode_button = 0;
        #10;

        master_key_input = mkey;
        master_key_submit = 1;
        #10;
        master_key_submit = 0;
        #20;

        new_password_input = newpass;
        new_password_submit = 1;
        #10;
        new_password_submit = 0;
        #20;
    end
    endtask

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        entered_password = 4'b0000;
        submit = 0;
        change_mode_button = 0;
        master_key_input = 4'b0000;
        master_key_submit = 0;
        new_password_input = 4'b0000;
        new_password_submit = 0;

        #20 reset = 0;

        // Test 1: Enter correct password (default: 1010)
        press_submit(4'b1010);   // Correct
        #50;

        // Test 2: Enter wrong password 3 times to trigger alarm
        press_submit(4'b1110);   // Wrong 1
        press_submit(4'b1100);   // Wrong 2
        press_submit(4'b0001);   // Wrong 3 (Alarm triggers)
        #100;

        // Wait for alarm to auto turn off
        #100;

        // Test 3: Reset system
        reset = 1; #20; reset = 0;
        #20;

        // Test 4: Change password using correct master key
        change_password(4'b1111, 4'b0101);  // Master key OK, new password = 0101
        #100;

        // Test 5: Try new password
        press_submit(4'b0101);   // Should unlock
        #50;

        // Test 6: Try changing with wrong master key
        change_password(4'b0000, 4'b0011);  // Wrong master key → should not change
        #100;

        // Test 7: Try old password again
        press_submit(4'b0101);   // Should still work
        press_submit(4'b0011);   // Should fail

        $stop;
    end
endmodule

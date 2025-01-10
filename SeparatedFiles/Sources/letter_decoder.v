`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2024 01:56:20 PM
// Design Name: 
// Module Name: letter_decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

      
 module letter_decoder (
    input clk,// Clock signal
    input rst,// Reset signal (clears everything)
    input en,// Enable signal for input
    input del,// Delete signal
   
    input [5:0] switch_input,// 6-bit switch input
    input [1:0] tilt_input,  // Tilt input from accelerometer
    output reg [5:0]letter1,// First letter
    output reg [5:0]letter2,// Second letter
    output reg [5:0]letter3// Third letter
    );
    
    reg [5:0]letter_buffer; // new inputed letter
    reg [1:0] current_position; // Keeps track of letter slot index
    reg flagDel, flagEN;
    
    // NEW: Previous tilt input to detect changes
    reg [1:0] prev_tilt_input; 

    initial begin
        flagDel = 0;
        flagEN = 0;
        letter_buffer = 0 ; // new inputed letter
        current_position = 2'b00; // Keeps track of letter slot index
        letter1 = 6'b111111;
        letter2 = 6'b111111;
        letter3 = 6'b111111;
        prev_tilt_input = 2'b00; // Start with neutral tilt
    end
    
    // Switch encodings passed to vga_controller for bitmap selection and VGA display
    always @(*) begin
        case (switch_input)
            6'b000000, 6'b000001, 6'b000010, 6'b000011, 
            6'b000100, 6'b000101, 6'b000110, 6'b000111, 
            6'b001000, 6'b001001, 6'b001010, 6'b001011, 
            6'b001100, 6'b001101, 6'b001110, 6'b001111, 
            6'b010000, 6'b010001, 6'b010010, 6'b010011, 
            6'b010100, 6'b010101, 6'b010110, 6'b010111, 
            6'b011000, 6'b011001                            
                    : letter_buffer = switch_input; 
            
            default: letter_buffer = 6'b111111;   // Default to space
        endcase
    end 

    // Sequential Logic for Buffer Management
    always @(posedge clk) begin
        if (rst) begin
            letter1 <= 6'b111111;
            letter2 <= 6'b111111;
            letter3 <= 6'b111111;
            current_position <= 2'b00;
            flagEN <= 0;
            flagDel <= 0;
            prev_tilt_input <= 2'b00; // Start from neutral
        end
        
        // Handle letter insertion (press/release en)
        if (en & ~flagEN) begin
            // Add a new letter to the next available position
            case (current_position)
                2'b00: letter1 <= letter_buffer;
                2'b01: letter2 <= letter_buffer;

                2'b10: letter3 <= letter_buffer;
            endcase
            flagEN <= 1;
        end else if (~en) flagEN <= 0;
        
        // Handle letter deletion (press/release del)
        if (del & !flagDel) begin
            // Perform delete action based on last_inserted_position
            case (current_position)
                2'b00: 
letter1 <= 6'b111111; // Clear the first letter

                2'b01: letter2 <= 6'b111111; // Clear the second letter

                2'b10: letter3 <= 6'b111111; // Clear the third letter

            endcase
            flagDel <= 1; // Set the flag to indicate delete action is in progress
        end else if (!del) flagDel <= 0; // Reset the flag when delete button is released
       
        
        
        // NEW LOGIC: Simplified tilt handling
        // Instead of flags, we detect when tilt_input changes.
        // If tilt_input changes to 2'b01 (left) from something else, move left if possible.
        // If tilt_input changes to 2'b10 (right) from something else, move right if possible.
        
        // Detect rising edge-like behavior: tilt moves pointer only when tilt_input changes.
        if (tilt_input == 2'b01 && prev_tilt_input != 2'b01) begin
            if (current_position > 2'b00)
                current_position = current_position - 1;
        end
        else if (tilt_input == 2'b10 && prev_tilt_input != 2'b10) begin
            if (current_position < 2'b10)
                current_position <= current_position + 1;
        end
       
        
        // Update prev_tilt_input to current tilt_input every cycle
        prev_tilt_input <= tilt_input;
    end
endmodule

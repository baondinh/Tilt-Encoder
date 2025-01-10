# EC311-Project 
# Tilt Encoder
### Yuxuan Chen, Phyliss Darko, Bao Dinh, Kelsey Sweeney

## Link to Project Demo Video
https://drive.google.com/drive/folders/19lKSHvc7CjlXUHgSjlxcV4TZcBsX02wY?usp=drive_link


## Overview of the Project
This project involves using switch inputs to write letters onto a screen and tilt inputs from an accelerometer to select the location of the lettering. The system integrates an accelerometer and VGA display to provide interactive feedback and visualization.


## How to Run Project
1. Add all source files (vga_top.v, accelerometer_SPI.v, letter_decoder.v, etc.) to your Vivado project.
2. Set vga_top.v as the top module.
3. Program the FPGA using the provided bitstream file.
4. Use the 6 switch inputs to write letters onto the VGA screen.
5. Tilt the FPGA board to adjust the location of the letters using accelerometer input.
6. Press enable button (N17) to display character to screen
7. To delete character, press delete button (P18).
8. To reset screen, press M18.


## Overview of the code structure
| Module Name        | Description                                                                 | Important Notes                                                        |
| ------------------ | --------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| `vga_top`          | The top-level module that integrates all components.                        | Handles VGA output, SPI interface, and tilt detection logic.          |
| `clk_divider`      | Divides the input clock from 100MHz to 25MHz for VGA synchronization.       | Ensures timing compatibility with VGA display and sequential logic.   |
| `accelerometer_SPI`| Uses SPI bus to communicate with the ADXL362 accelerometer. Processes raw accelerometer data and decodes it into 2-bit tilt values. | The first bit is the sign bit of the axis, the second bit is determined by magnitude. |
| `debouncer`        | Debounces push-button inputs to prevent repeating noise signals.            | Used for stable `en` and `del` logic signals.                          |
| `letter_decoder`   | Decodes switch inputs and tilt data into letters and positions on the screen. | Hardcoded letter output and updates display position based on tilt.   |
| `vga_controller`   | Manages VGA timing and pixel rendering for the screen display.              | Handles the drawing of letters and background color logic.            |


## Sources and Citations
#### FPGADude - Accelerometer SPI Master and Top module
* [YouTube Demo](https://www.youtube.com/watch?v=7b3YwQWwvXM)
* [FPGADude GitHub Accelerometer](https://github.com/FPGADude/Digital-Design/tree/main/FPGA%20Projects/Nexys%20A7%203-Axis%20Accelerometer%20SPI)

#### [FPGADude - ASCII ROM](https://github.com/FPGADude/Digital-Design/blob/main/FPGA%20Projects/VGA%20Projects/VGA%20Full%20Screen%20Text%20Editor/ascii_rom.v)
* Adapted bitmaps for vga_controller

#### [Project F](https://projectf.io/posts/racing-the-beam/)
* Modeled code that magnified smaller bitmap off of "Racing the Beam" project





## Feature 
### Overall System Workflow management: 
Clock Generation: The clk_divider provides a 25 MHz clock for timing-sensitive modules. 
Input Handling: Button presses (en and del) are debounced. Accelerometer SPI processes input data. Switch and tilt inputs are decoded into letters.
Letter Display: The letter_decoder updates the three-letter storage (letter1, letter2, letter3) based on user input. 
Visual Output: The vga_controller uses the updated letters to render them on the display, with specific color configurations for letters and background.

### Accelerometer Input 
The tilt detection logic determines the direction and magnitude of tilt based on accelerometer data. The tilt information is used to update the position of the letters dynamically on the VGA screen.
#### Key Component: 
The code implements a simplified and efficient mechanism for handling tilt-based input to control a position pointer. It detects changes in the tilt state by comparing the current tilt input (tilt_input) with its previous value (prev_tilt_input). When a left tilt (2’b01) or right tilt (2’b10) is detected, the pointer moves left or right, respectively, but only within defined bounds to prevent invalid positions. By updating the previous input state after each cycle, the logic ensures edge-triggered behavior, responding only to changes in tilt rather than steady-state inputs. Additionally, the design has been updated to prevent the position from shifting unless a tilt is detected, enabling users to perform actions such as deletion and updating letters while remaining at the same position. This approach enhances usability, precision, and efficiency in tilt-based control. 






### Letter Typing System 
Using the onboard switches, users can type characters and send them to the VGA screen. The switches select letters, while debounce buttons confirm the selection or delete the last input. Characters are displayed at the tilt-determined position.
#### Key Component: 
Letter Management Logic: The system maintains three letter slots (letter1, letter2, letter3), each capable of holding a single letter.The switch_input is mapped to letters using a case statement. Each 6-bit combination corresponds to a specific letter (or blank space by default). The selected letter is temporarily stored in letter_buffer.
Enable signal:  The en signal triggers the addition of a new letter to the next available slot. When a letter is added, the current_position shifts to the next slot, cycling between the three available positions. A flag (flagEN) ensures only one letter is added per press. 
Delete signal: The del signal removes the letter in the slot pointed to by last_inserted_position. The last_inserted_position register keeps track of the most recently modified slot.
Reset logic: Reset Logic Clear State: Asserting the rst signal resets all letters (letter1, letter2, letter3) to a blank state (6'b111111). Position Reset: The current_position and last_inserted_position are reset to their initial values, ensuring the system starts fresh.

### VGA Display 
The VGA takes in three 6’bit encoding inputs and outputs information for the VGA display including; h_sync, v_sync and logic for when a pixel should be on or off.

#### Key Component:
Enable logic: There are three sections of the screen; one for each of the letters that can be displayed. A for loop iterates over each pixel coordinate. When the current pixel coordinate is located within one of three Bitmap enable regions, the specific character that should be displayed there is stored in curr_letter_sel and the pixel is reported as on or off. 
Expanding Letter Logic:
Alphabet Bitmap: Depending on which letter is passed to the vga_controller, the 6 bit representation of that letter is matched with one of twenty-six case statements and reported to curr_letter_sel. 

## Letter Index:
| 6-bit Input | Letter | ASCII Value |
| ----------- | ------ | ----------- |
| 6'b000000   | A      | 65          |
| 6'b000001   | B      | 66          |
| 6'b000010   | C      | 67          |
| 6'b000011   | D      | 68          |
| 6'b000100   | E      | 69          |
| 6'b000101   | F      | 70          |
| 6'b000110   | G      | 71          |
| 6'b000111   | H      | 72          |
| 6'b001000   | I      | 73          |
| 6'b001001   | J      | 74          |
| 6'b001010   | K      | 75          |
| 6'b001011   | L      | 76          |
| 6'b001100   | M      | 77          |
| 6'b001101   | N      | 78          |
| 6'b001110   | O      | 79          |
| 6'b001111   | P      | 80          |
| 6'b010000   | Q      | 81          |
| 6'b010001   | R      | 82          |
| 6'b010010   | S      | 83          |
| 6'b010011   | T      | 84          |
| 6'b010100   | U      | 85          |
| 6'b010101   | V      | 86          |
| 6'b010110   | W      | 87          |
| 6'b010111   | X      | 88          |
| 6'b011000   | Y      | 89          |
| 6'b011001   | Z      | 90          |
| 6'b111111   | (Blank)|             |

#### Other Code Snippets
Before getting the accelerometer output to work, character positions after insertion and deletion were handled using pointers and sequential logic. The following shows the old logic that has since been replaced by accelerometer input to control position.
```
// Sequential Logic for Buffer Management
    always @(posedge clk) begin
        if (rst) begin
            letter1 <= 6'b111111;
            letter2 <= 6'b111111;
            letter3 <= 6'b111111;
            current_position <= 2'b00;
            last_inserted_position <= 2'b00; // Reset the last inserted position
        end
        
        if (en & ~flagEN) begin
            // Add a new letter to the next available position
            case (current_position)
                2'b00: begin
                    letter1 <= letter_buffer;
                    current_position <= 2'b01; // Move to next available slot
                    last_inserted_position <= 2'b00; // Track letter1 as the last inserted
                end
                2'b01: begin
                    letter2 <= letter_buffer;
                    current_position <= 2'b10; // Move to next available slot
                    last_inserted_position <= 2'b01; // Track letter2 as the last inserted
                end
                2'b10: begin
                    letter3 <= letter_buffer;
                    last_inserted_position <= 2'b10;
                end
            endcase
            flagEN = 1;
        end else if (~en) flagEN = 0;
        
        if (del & !flagDel) begin
            // Perform delete action based on last_inserted_position
            case (last_inserted_position)
                2'b00: begin
                    letter1 <= 6'b111111; // Clear the first letter
                    current_position <= 2'b00; // Remain at the start (no letters to delete)
                    last_inserted_position <= 2'b00;
                end
                2'b01: begin
                    letter2 <= 6'b111111; // Clear the second letter
                    current_position <= 2'b01; // Move position back to letter1
                    last_inserted_position <= 2'b00;
                end
                2'b10: begin
                    letter3 <= 6'b111111; // Clear the third letter
                    current_position <= 2'b10; // Move position back to letter2
                    last_inserted_position <= 2'b01;
                end
            endcase
            flagDel = 1; // Set the flag to indicate delete action is in progress
        end else if (!del) flagDel = 0; // Reset the flag when delete button is released
    end
```


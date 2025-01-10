`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2024 05:21:28 PM
// Design Name: 
// Module Name: vga_top
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


module vga_top(clk, ACL_MISO, ACL_MOSI, ACL_SCLK, ACL_CSN, reset, en, del, switch_input, vga_r, vga_g, vga_b, h_sync, v_sync, LED);
   
    // FPGA button and switch inputs
    input clk, reset, en, del;
    input [5:0] switch_input;
    
    // Accelerometer SPI inputs and outputs
    input ACL_MISO; 
    output ACL_MOSI, ACL_SCLK, ACL_CSN;

    output [1:0] LED;
    
    // VGA output
    output reg [3:0] vga_r, vga_g, vga_b;
    output h_sync, v_sync;
    
    wire newClk, ledOn, char, clean_en, clean_del;
    wire [5:0] letter1; 
    wire [5:0] letter2;
    wire [5:0] letter3;
    wire [1:0] acl_data; 

    // CLK DIVIDER FROM 100MHz -> 25 MHz
    clk_divider clkDiv (clk, reset, newClk);
    
    // Accelerometer (example uses 4MHz clock but will try to use with 
    // the 25 MHz clock to reduce number of modules needed
    accelerometer_SPI acl(
        .iclk(newClk), 
        .miso(ACL_MISO), 
        .sclk(ACL_SCLK), 
        .mosi(ACL_MOSI), 
        .cs(ACL_CSN), 
        .acl_data(acl_data) 
    ); 
    
    // Debounced signals for each button 
    debouncer debEN(clk, en, clean_en);
    debouncer debDEL(clk, del, clean_del);
    
    // Letter decoder
    letter_decoder ltrd(
        .clk(clk), 
        .rst(reset), 
        .en(clean_en), 
        .del(clean_del), 
        .switch_input(switch_input), 
        .tilt_input(acl_data),   
        .letter1(letter1), 
        .letter2(letter2), 
        .letter3(letter3)
    );
    
    vga_controller vga_con(newClk, letter1, letter2, letter3, h_sync, v_sync, ledOn, char);
    
    // VGA color output    
    always@(posedge newClk) begin
        vga_r <= (ledOn) ? (char ? 255: 0) : 0; 
        vga_g <= (ledOn) ? (char ? 255: 0) : 0;
        vga_b <= (ledOn) ? (char ? 0: 255) : 0;
    end    
    
    // LED indicator for tilts
    assign LED[1:0] = acl_data[1:0];
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2024 05:22:10 PM
// Design Name: 
// Module Name: vga_controller
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

`timescale 1ns / 1ps

module vga_controller(clk, letter_sel_ONE, letter_sel_TWO, letter_sel_THREE, h_sync, v_sync, led_on, char);
    
    input clk;
    input wire [5:0] letter_sel_ONE;
    input wire [5:0] letter_sel_TWO;
    input wire [5:0] letter_sel_THREE;
    
    output reg h_sync, v_sync, led_on, char;
    
    localparam TOTAL_WIDTH = 800;
    localparam TOTAL_HEIGHT = 525;
    localparam ACTIVE_WIDTH = 640;
    localparam ACTIVE_HEIGHT = 480;
    localparam H_SYNC_COLUMN = 704;
    localparam V_SYNC_LINE = 523;
    
    reg [11:0] widthPos = 0;
    reg [11:0] heightPos = 0;
    
    wire enable = ((widthPos >=50 & widthPos < 690) & (heightPos >=33 & heightPos < 513)) ? 1'b1: 1'b0;
    
    wire bmapenableONE = ((widthPos >= 220 & widthPos < 300) & ( heightPos >= 160 & heightPos < 320)) ? 1'b1: 1'b0;
    wire bmapenableTWO = ((widthPos >= 320 & widthPos < 400) & ( heightPos >= 160 & heightPos < 320)) ? 1'b1: 1'b0;
    wire bmapenableTHREE = ((widthPos >= 420 & widthPos < 500) & ( heightPos >= 160 & heightPos < 320)) ? 1'b1: 1'b0;
    
    wire [0:5] curr_letter_sel;
    assign curr_letter_sel = bmapenableONE ? letter_sel_ONE : (bmapenableTWO ? letter_sel_TWO : letter_sel_THREE);
    
    reg [2:0] x;
    reg [3:0] y; 

    reg [0:7] bmap [0:15];

    // bitmaps taken from FPGADude ASCII_ROM and adapted for purposes of our code
    always @(posedge clk) begin
        case (curr_letter_sel)
            6'b000000:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b00010000;	//   *
                bmap[3] = 8'b00111000;	//  ***
                bmap[4] = 8'b01101100;	// ** **   
                bmap[5] = 8'b11000110;	//**   **   
                bmap[6] = 8'b11000110;	//**   **
                bmap[7] = 8'b11111110;	//*******
                bmap[8] = 8'b11111110;	//*******
                bmap[9] = 8'b11000110;	//**   **
                bmap[10] = 8'b11000110;	//**   **
                bmap[11] = 8'b11000110;	//**   **
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                    
            6'b000001:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b11111100;	//******
                bmap[3] = 8'b11111110;	//*******
                bmap[4] = 8'b11000110;	//**   **
                bmap[5] = 8'b11000110;	//**   **   
                bmap[6] = 8'b11111100;	//******
                bmap[7] = 8'b11111100;	//******
                bmap[8] = 8'b11000110;	//**   **
                bmap[9] = 8'b11000110;	//**   **
                bmap[10] = 8'b11111110;	//*******
                bmap[11] = 8'b11111100;	//******
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
            6'b000010:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b01111100;	// *****
                bmap[3] = 8'b11111110;	//*******
                bmap[4] = 8'b11000000;	//**
                bmap[5] = 8'b11000000;	//**   
                bmap[6] = 8'b11000000;	//**
                bmap[7] = 8'b11000000;	//**
                bmap[8] = 8'b11000000;	//** 
                bmap[9] = 8'b11000000;	//** 
                bmap[10] = 8'b11111110;	//*******
                bmap[11] = 8'b01111100;	// *****
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
            6'b000011:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b11111100;	//******
                bmap[3] = 8'b11111110;	//*******
                bmap[4] = 8'b11000110;	//**   **
                bmap[5] = 8'b11000110;	//**   **   
                bmap[6] = 8'b11000110;	//**   **
                bmap[7] = 8'b11000110;	//**   **
                bmap[8] = 8'b11000110;	//**   ** 
                bmap[9] = 8'b11000110;	//**   ** 
                bmap[10] = 8'b11111110;	//*******
                bmap[11] = 8'b11111100;	//******
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
            6'b000100:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b11111110;	//*******
                bmap[3] = 8'b11111110;	//*******
                bmap[4] = 8'b11000000;	//**
                bmap[5] = 8'b11000000;	//**   
                bmap[6] = 8'b11111100;	//******
                bmap[7] = 8'b11111100;	//******
                bmap[8] = 8'b11000000;	//** 
                bmap[9] = 8'b11000000;	//** 
                bmap[10] = 8'b11111110;	//*******
                bmap[11] = 8'b11111110;	//*******
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
    
            6'b000101:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b11111110;	//*******
                bmap[3] = 8'b11111110;	//*******
                bmap[4] = 8'b11000000;	//** 
                bmap[5] = 8'b11000000;	//**
                bmap[6] = 8'b11111100;	//******
                bmap[7] = 8'b11111100;	//******
                bmap[8] = 8'b11000000;	//**
                bmap[9] = 8'b11000000;	//**
                bmap[10] = 8'b11000000;	//**
                bmap[11] = 8'b11000000;	//**
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
    
            6'b000110:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b01111100;	// *****
                bmap[3] = 8'b11111110;	//*******
                bmap[4] = 8'b11000000;	//**
                bmap[5] = 8'b11000000;	//**   
                bmap[6] = 8'b11111110;	//*******
                bmap[7] = 8'b11111110;	//*******
                bmap[8] = 8'b11000110;	//**   **
                bmap[9] = 8'b11000110;	//**   **
                bmap[10] = 8'b11111110;	//*******
                bmap[11] = 8'b01110110;	// *** **
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
    
            6'b000111:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b11000110;	//**   **
                bmap[3] = 8'b11000110;	//**   **
                bmap[4] = 8'b11000110;	//**   **
                bmap[5] = 8'b11000110;	//**   **
                bmap[6] =  8'b11111110;	//*******
                bmap[7] =  8'b11111110;	//*******
                bmap[8] = 8'b11000110;	//**   **
                bmap[9] = 8'b11000110;	//**   **
                bmap[10] = 8'b11000110;	//**   **
                bmap[11] = 8'b11000110;	//**   **
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
            6'b001000:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b11111110;	//*******
                bmap[3] = 8'b11111110;	//*******
                bmap[4] = 8'b00110000;	//  **
                bmap[5] = 8'b00110000;	//  **
                bmap[6] =  8'b00110000;	//  **
                bmap[7] =  8'b00110000;	//  **
                bmap[8] = 8'b00110000;	//  **
                bmap[9] = 8'b00110000;	//  **
                bmap[10] = 8'b11111110;	//*******
                bmap[11] = 8'b11111110;	//*******
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
            6'b001001:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b11111110;	//*******
                bmap[3] = 8'b11111110;	//*******
                bmap[4] = 8'b00011000;	//   **
                bmap[5] = 8'b00011000;	//   **
                bmap[6] =  8'b00011000;	//   **
                bmap[7] =  8'b00011000;	//   **
                bmap[8] = 8'b00011000;	//   **
                bmap[9] = 8'b00011000;	//   **
                bmap[10] = 8'b11111000;	//*****
                bmap[11] = 8'b01111000;	// ****
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
            6'b001010:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b11000110;	//**   **
                bmap[3] =  8'b11001100;	//**  **
                bmap[4] = 8'b11011000;	//** **
                bmap[5] = 8'b11110000;	//****
                bmap[6] =  8'b11100000;	//***
                bmap[7] =  8'b11100000;	//***
                bmap[8] =  8'b11110000;	//****
                bmap[9] = 8'b11011000;	//** **
                bmap[10] = 8'b11001100;	//**  **
                bmap[11] = 8'b11000110;	//**   **
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
    
            6'b001011:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b11000000;	//**
                bmap[3] =  8'b11000000;	//**
                bmap[4] =  8'b11000000;	//**
                bmap[5] =  8'b11000000;	//**
                bmap[6] =  8'b11000000;	//**
                bmap[7] =  8'b11000000;	//**
                bmap[8] =  8'b11000000;	//**
                bmap[9] =  8'b11000000;	//**
                bmap[10] = 8'b11111110;	//*******
                bmap[11] = 8'b11111110;	//*******
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
    
            6'b001100:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] =8'b11000110;	//**   **
                bmap[3] = 8'b11000110;	//**   **
                bmap[4] = 8'b11101110;	//*** ***
                bmap[5] =  8'b11111110;	//*******
                bmap[6] =  8'b11010110;	//** * **
                bmap[7] =  8'b11000110;	//**   **
                bmap[8] =  8'b11000110;	//**   **
                bmap[9] =  8'b11000110;	//**   **
                bmap[10] = 8'b11000110;	//**   **
                bmap[11] = 8'b11000110;	//**   **
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
    
            6'b001101:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b11000110;	//**   **
                bmap[3] = 8'b11000110;	//**   **
                bmap[4] = 8'b11100110;	//***  **
                bmap[5] = 8'b11110110;	//**** **
                bmap[6] =  8'b11111110;	//*******
                bmap[7] =  8'b11011110;	//** ****
                bmap[8] = 8'b11001110;	//**  ***
                bmap[9] = 8'b11000110;	//**   **
                bmap[10] = 8'b11000110;	//**   ** 
                bmap[11] = 8'b11000110;	//**   **
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
    
            6'b001110:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b01111100;	// *****
                bmap[3] = 8'b11111110;	//*******
                bmap[4] = 8'b11000110;	//**   **
                bmap[5] = 8'b11000110;	//**   **
                bmap[6] =  8'b11000110;	//**   **
                bmap[7] =  8'b11000110;	//**   **
                bmap[8] = 8'b11000110;	//**   **
                bmap[9] = 8'b11000110;	//**   **
                bmap[10] = 8'b11111110;	//*******
                bmap[11] = 8'b01111100;	// *****
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
    
            6'b001111:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b11111100;	//******
                bmap[3] = 8'b11111110;	//*******
                bmap[4] = 8'b11000110;	//**   **
                bmap[5] = 8'b11000110;	//**   **
                bmap[6] =  8'b11111110;	//*******
                bmap[7] =  8'b11111100;	//****** 
                bmap[8] = 8'b11000000;	//**
                bmap[9] = 8'b11000000;	//**
                bmap[10] = 8'b11000000;	//**
                bmap[11] = 8'b11000000;	//**
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                    
    
            6'b010000:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b11111100;	// *****
                bmap[3] = 8'b11111110;	//*******
                bmap[4] = 8'b11000110;	//**   **
                bmap[5] = 8'b11000110;	//**   **
                bmap[6] =  8'b11000110;	//**   **
                bmap[7] =  8'b11000110;	//**   **
                bmap[8] =  8'b11010110;	//** * **
                bmap[9] = 8'b11111110;	//*******
                bmap[10] = 8'b01101100;	// ** ** 
                bmap[11] = 8'b00000110;	//     **
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
    
            6'b010001:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b11111100;	//******
                bmap[3] = 8'b11111110;	//*******
                bmap[4] = 8'b11000110;	//**   **
                bmap[5] = 8'b11000110;	//**   **
                bmap[6] = 8'b11111110;	//*******
                bmap[7] = 8'b11111100;	//******   
                bmap[8] = 8'b11011000;	//** **
                bmap[9] =  8'b11001100;	//**  **
                bmap[10] = 8'b11000110;	//**   **
                bmap[11] = 8'b11000110;	//**   **
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
    
            6'b010010:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b01111100;	// *****
                bmap[3] = 8'b11111110;	//*******
                bmap[4] = 8'b11000000;	//**
                bmap[5] =  8'b11000000;	//**
                bmap[6] =  8'b11111100;	//******
                bmap[7] =  8'b01111110;	// ******  
                bmap[8] = 8'b00000110;	//     ** 
                bmap[9] = 8'b00000110;	//     ** 
                bmap[10] = 8'b11111110;	//*******  
                bmap[11] = 8'b01111100;	// *****
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
    
            6'b010011:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b11111110;	//*******
                bmap[3] = 8'b11111110;	//*******
                bmap[4] = 8'b00110000;	//  **
                bmap[5] = 8'b00110000;	//  **
                bmap[6] =  8'b00110000;	//  **
                bmap[7] =  8'b00110000;	//  **
                bmap[8] = 8'b00110000;	//  ** 
                bmap[9] = 8'b00110000;	//  **
                bmap[10] = 8'b00110000;	//  **
                bmap[11] = 8'b00110000;	//  **
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
    
            6'b010100:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] =8'b11000110;	//**   **
                bmap[3] = 8'b11000110;	//**   **
                bmap[4] = 8'b11000110;	//**   **
                bmap[5] = 8'b11000110;	//**   **
                bmap[6] =  8'b11000110;	//**   **
                bmap[7] =  8'b11000110;	//**   **
                bmap[8] = 8'b11000110;	//**   **
                bmap[9] = 8'b11000110;	//**   **
                bmap[10] = 8'b11111110;	//*******
                bmap[11] = 8'b01111100;	// *****
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
    
            6'b010101: 
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b11000110;	//**   **
                bmap[3] = 8'b11000110;	//**   **
                bmap[4] = 8'b11000110;	//**   **
                bmap[5] =8'b11000110;	//**   ** 
                bmap[6] =8'b11000110;	//**   ** 
                bmap[7] = 8'b11000110;	//**   **
                bmap[8] = 8'b11000110;	//**   **
                bmap[9] = 8'b01101100;	// ** **
                bmap[10] = 8'b00111000;	//  *** 
                bmap[11] = 8'b00010000;	//   *
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
    
            6'b010110:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b11000110;	//**   **
                bmap[3] = 8'b11000110;	//**   **
                bmap[4] = 8'b11000110;	//**   **
                bmap[5] = 8'b11000110;	//**   **
                bmap[6] = 8'b11000110;	//**   **
                bmap[7] = 8'b11000110;	//**   **
                bmap[8] = 8'b11010110;	//** * **
                bmap[9] = 8'b11111110;	//*******
                bmap[10] = 8'b11101110;	//*** ***  
                bmap[11] = 8'b11000110;	//**   **
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
    
            6'b010111:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b11000110;	//**   **
                bmap[3] =  8'b11000110;	//**   **
                bmap[4] = 8'b01101100;	// ** ** 
                bmap[5] = 8'b00111000;	//  ***
                bmap[6] =  8'b00111000;	//  ***
                bmap[7] =  8'b00111000;	//  ***
                bmap[8] = 8'b00111000;	//  ***
                bmap[9] = 8'b01101100;	// ** **
                bmap[10] = 8'b11000110;	//**   **  
                bmap[11] = 8'b11000110;	//**   **
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
    
            6'b011000:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b11000110;	//**   **
                bmap[3] = 8'b11000110;	//**   **
                bmap[4] = 8'b01101100;	// ** **
                bmap[5] = 8'b00111000;	//  ***
                bmap[6] =  8'b00011000;	//   **
                bmap[7] =  8'b00011000;	//   **
                bmap[8] = 8'b00011000;	//   **
                bmap[9] = 8'b00011000;	//   **
                bmap[10] = 8'b00011000;	//   **
                bmap[11] = 8'b00011000;	//   **
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//
            end
                
    
            6'b011001:
            begin
                bmap[0] = 8'b00000000;	//
                bmap[1] = 8'b00000000;	//
                bmap[2] = 8'b11111110;	//*******
                bmap[3] = 8'b11111110;	//*******
                bmap[4] = 8'b00000110;	//     **  
                bmap[5] = 8'b00001100;	//    **
                bmap[6] =  8'b00011000;	//   **
                bmap[7] =  8'b00110000;	//  **
                bmap[8] = 8'b01100000;	// **
                bmap[9] = 8'b11000000;	//**
                bmap[10] = 8'b11111110;	//******* 
                bmap[11] = 8'b11111110;	//*******
                bmap[12] = 8'b00000000;	//
                bmap[13] = 8'b00000000;	//
                bmap[14] = 8'b00000000;	//
                bmap[15] = 8'b00000000;	//    
            end
    
            6'b111111: //delete (no letter)   
            begin
                bmap[0]   = 8'b00000000;
                bmap[1]   = 8'b00000000;
                bmap[2]   = 8'b00000000;
                bmap[3]   = 8'b00000000;
                bmap[4]   = 8'b00000000;
                bmap[5]   = 8'b00000000;
                bmap[6]   = 8'b00000000;
                bmap[7]   = 8'b00000000;
                bmap[8]   = 8'b00000000;
                bmap[9]   = 8'b00000000;
                bmap[10]  = 8'b00000000;
                bmap[11]  = 8'b00000000;
                bmap[12]  = 8'b00000000;
                bmap[13]  = 8'b00000000;
                bmap[14]  = 8'b00000000;
                bmap[15]  = 8'b00000000;
            end          
        endcase
    end
    
    // Following always block ensures that 
    // you go through all pixel coordinates
    always@(posedge clk)
    begin
        // check if end of the width 
        if(widthPos < TOTAL_WIDTH -1)
        begin 
            widthPos <= widthPos + 1;
        end
        else
        begin
            // move back to the first column
            widthPos <=0;
            // check if end of the height
            if(heightPos < TOTAL_HEIGHT -1)
            begin
                heightPos <= heightPos + 1;
            end
            else
            begin
                 heightPos <= 0;
            end       
        end
    end
    
    always@(posedge clk)
    begin
        if (widthPos < H_SYNC_COLUMN)
        begin
            h_sync <= 1'b1;
        end
        else
        begin
            h_sync <= 1'b0;
        end
    end

    always@(posedge clk)
    begin
        if (heightPos < V_SYNC_LINE)
        begin
            v_sync <= 1'b1;
        end
        else
        begin
            v_sync <= 1'b0;
        end
   end
    
    // bmap expansion
    always @(*) begin
        if (bmapenableONE) begin
            x <= (widthPos - 220)/10;
            y <= (heightPos - 160)/10;
        end
        else if (bmapenableTWO) begin
            x <= (widthPos - 320)/10;
            y <= (heightPos - 160)/10;
        end
        else if (bmapenableTHREE) begin
            x <= (widthPos - 420)/10;
            y <= (heightPos - 160)/10;
        end
        else begin
            x <= 0;
            y <= 0;
        end
    end
    
    // Display logic
    // Ensures characters are enlarged and displayed in appropriate region
    always@(posedge clk)begin
        if (enable) begin
            if(bmapenableONE) begin
                led_on <= 1'b1;
                char <= bmap[y][x];
            end
            else if ( bmapenableTWO) begin
                led_on <= 1'b1;
                char <= bmap[y][x];
            end            
            else if (bmapenableTHREE) begin
                led_on <= 1'b1;
                char <= bmap[y][x];
            end
            else begin
                led_on <= 1'b1;
                char <= 1'b0;
            end
        end
        else begin
            led_on <= 1'b0;
            char <= 1'b0;
        end
    end        
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2024 09:00:55 PM
// Design Name: 
// Module Name: letter_decoder_tb
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


module letter_decoder_tb(

    );
    
    reg clk;// Clock signal
    reg rst;// Reset signal (clears everything)
    reg en;// Enable signal for input
    reg del;// Delete signal
   
    reg [5:0] switch_input;// 6-bit switch input
    wire [5:0]letter1;// First letter
    wire [5:0]letter2;// Second letter
    wire [5:0]letter3;// Third letter
    
    letter_decoder decoder(clk, rst, en, del, switch_input, letter1, letter2, letter3); 
    
    initial begin
        clk = 0; 
        rst = 0;
        en = 0; 
        del = 0; 
        switch_input = 0;
    end
    
    always begin
        #4 en = 1; 
        #10 en = 0; switch_input = 6'b001101;
        #13 en = 1; 
        #17 en = 0; switch_input = 6'b010011;
        #20 en = 1;        
        #25 en = 0; 
        #40 del = 1;
        #49 del = 0;
        #53 del = 1; 
        #58 del = 0; 
        #67 del = 1;
        #70 del = 0; 
        #74 switch_input = 6'b010011; en = 1;
        #79 en = 0; switch_input = 6'b010011;
        #83 en = 1; 
        #87 en = 0; 
        #88 del = 1; 
        #93 del = 0; 
        #102 switch_input = 6'b010011; en = 1;
        #107 en = 0; switch_input = 6'b010011;
        #130 en = 1; 
        #200 $finish;
    end
    
    
    
    always #5 clk=~clk;     
endmodule
`timescale 1ns / 1ps
// Debouncer to ensure stable button signals

module debouncer(
    input clk,
    input trigger,
    output reg button  
    );
    
    reg [20:0]counter;
    reg [20:0]next_counter;
    reg [20:0]max_num;
    
    initial begin
    button = 1'b0;
    max_num = 20'b10000000000000000000;
    counter = 0;
    next_counter = 0;
    end
    
    always @(posedge clk) begin
    // is the trigger on? if yes, then we count
    if (trigger)
    begin
        // if already established that button = 1 then reset 
        if (button == 1) 
            begin
            counter = 0;
            next_counter = 0;
            end
        else begin
            if (counter == max_num) 
                begin
                button = 1'b1;
                end
            
            else 
                begin
                next_counter = counter + 1'b1;
                counter = next_counter;
                end
        end
    end
    // once the trigger is off, we need to mimic this off state in button
    else
        begin
            button = 0;
        end
    end
endmodule

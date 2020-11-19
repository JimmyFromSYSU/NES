`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2015 12:18:26 AM
// Design Name: 
// Module Name: joystick
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
module test_bentch();
    logic clk;
    logic wait_15,wait_10,en;
    initial begin
        wait_10 = 0;
        wait_15 = 0;
        #10 wait_10 = 1;
        repeat (1000000) #5 clk = ~clk;
    end
    logic n_clk;
    //get_clk(clk,n_clk);
    //joy_counter(wait_10,wait_15,n_clk,en);
    
    always_ff @(posedge en)
        wait_10 <= 0;
        
endmodule

module get_clk(
    input logic clk,
    output logic clk_15
);
    bit [5:0] counter; 
    always_ff @(posedge clk)
        counter = counter + 1;
   assign clk_15 = counter[5];
endmodule


module joystick(
    
    );
endmodule

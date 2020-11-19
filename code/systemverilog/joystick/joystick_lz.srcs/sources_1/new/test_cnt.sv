`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2015 11:53:50 AM
// Design Name: 
// Module Name: test_cnt
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


module test_bentch_cnt();
    logic clk;
    logic wait_15,wait_10,end_15us,end_10us;
    
    
    initial begin
        clk = 0;
        repeat (200000) #5 clk = ~clk;
    end
    
    time_counter tc (clk,wait_15,wait_10,end_15us,end_10us);
    
    test_wait_sig ws(clk,wait_15,wait_10);
  
endmodule

module test_wait_sig(
     input logic clk_100M,
     output logic wait_15,
     output logic wait_10
);

    bit [20:0] counter;
    
    always_ff @(negedge clk_100M)begin
        counter  <= counter +1;
    end
    
    always_comb begin
        wait_15 = 0;
        wait_10 = 0;
    if(counter == 11 || counter == 1020)
         wait_10 = 1;
    else if(counter == 60)
         wait_15 = 1;      
    end
endmodule

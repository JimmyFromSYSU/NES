`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/03/19 18:37:59
// Design Name: 
// Module Name: PULSE_TEST
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


module PULSE_TEST(

    );
    logic nmi,nmi_p,clk;
    initial begin
         clk = 0;

         //repeat (1000000) #5 clk = ~clk;
         repeat (4000) #5 clk = ~clk;
    end
        
    PULSE pusle(.clk(clk),.s(nmi),.p(nmi_p));
    
    bit [10:0] count;
    always_ff @(posedge clk)
        count <= count + 1;  
        
    always_ff @(posedge clk)begin
         if(count == 1) nmi <= 0;
         else if(count == 10) nmi <= 1;
         else if(count == 30)nmi <= 0;
    end
endmodule

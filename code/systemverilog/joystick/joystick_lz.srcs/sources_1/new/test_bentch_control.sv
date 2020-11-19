`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2015 04:27:42 PM
// Design Name: 
// Module Name: test_bentch_control
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


module test_bentch_control(

);
   logic clk;
   initial begin
       clk = 0;
       repeat (1000000) #5 clk = ~clk;
   end
   
   logic start,clk_390K,s_clk,SS,en_recei;
   
   get_clk gc(clk,clk_390K);
   
   ///////////////////////// counter
   logic wait_15,wait_10,end_15,end_10;
   time_counter tc (clk,wait_15,wait_10,end_15,end_10);
   fsm testfsm(
        .start(start),
        .clk_100M(clk),
        .clk_390K(clk_390K),
        .wait_15(wait_15),
        .wait_10(wait_10),
        .end_15(end_15),
        .end_10(end_10),
        .s_clk(s_clk),
        .SS(SS),
   //output logic en_trans,
        .en_recei(en_recei)
   );
   
   bit [20:0] counter;
   always_ff @(negedge clk)begin
        counter = counter+1;
   end
   
   always_comb begin
        start = 0;
        if(counter == 10) start = 1;
        else if(counter == 18000)start = 1;
        //if(counter == 10) start = 1;
   end
   
endmodule


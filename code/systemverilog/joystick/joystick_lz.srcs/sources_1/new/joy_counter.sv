`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2015 12:15:54 AM
// Design Name: 
// Module Name: joy_counter
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

module counter
#(parameter W=8)
(
    input logic [W-1:0] P,
    output logic [W-1:0] Q,
    input logic reset,
    input logic load,
    input logic en,
    input logic clk
);
    always_ff @(posedge clk)begin
        if(reset)
            Q <= 0;
        else if(load)
            Q <= P;
        else if (Q == 0)
            Q <= 0;
        else if (en) 
            Q <= Q-1;
    end
endmodule

module time_counter(
    input logic clk_100M,
    input logic start_15us,
    input logic start_10us,
    output logic end_15us,
    output logic end_10us
);
    logic [19:0] over_10;
    logic [19:0] over_15;
    
    counter #(20) c10 (
        .P(20'd1000),
        .Q(over_10),
        .reset(1'b0),
        .load(start_10us),
        .en(1'b1),
        .clk(clk_100M)
    ); 
    
    assign end_10us = (over_10 == 0);
    
    counter #(20) c15 (
        .P(20'd1500),
        .Q(over_15),
        .reset(1'b0),
        .load(start_15us),
        .en(1'b1),
        .clk(clk_100M)
    ); 
    assign end_15us = (over_15 == 0);
endmodule


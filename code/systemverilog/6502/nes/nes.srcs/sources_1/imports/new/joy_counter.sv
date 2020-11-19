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
    input bit [W-1:0] P,
    output bit [W-1:0] Q,
    input bit reset,
    input bit load,
    input bit en,
    input bit clk
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


module auto_add
#(parameter W=8)
(
    input bit [W-1:0] P,
    output bit [W-1:0] Q,
    input bit reset,
    input bit load,
    input bit en,
    input bit clk
);
    always_ff @(posedge clk)begin
        if(reset)
            Q <= 0;
        else if(load)
            Q <= P;
       // else if (Q == 0)
       //     Q <= 0;
        else if (en) 
            Q <= Q+1;
    end
endmodule

module time_counter(
    input bit clk_100M,
    input bit start_15us,
    input bit start_10us,
    output bit end_15us,
    output bit end_10us
);
    bit [19:0] over_10;
    bit [19:0] over_15;
    
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

module divide_16(
    input bit clk,
    output bit nclk
);
    bit [5:0] counter;
    always_ff @(posedge clk)begin
        counter <= counter+1;
    end
    assign nclk = counter[2];
endmodule


module divide_cpu(
    input bit clk,
    output bit cpu_clk
);
    bit [25:0] counter;
    always_ff @(posedge clk)begin
        counter <= counter+1;
    end
    assign cpu_clk = counter[2];
endmodule
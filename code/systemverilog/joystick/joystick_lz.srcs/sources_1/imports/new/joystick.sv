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


module get_clk(
    input logic clk_100M,
    output logic clk_390K
);

    bit [8:0] counter; 
    always_ff @(posedge clk_100M)
        counter = counter + 1;
   assign clk_390K = counter[7];
endmodule


module joystick(
    input logic clk,
    input logic MISO,
    output logic SS,
    output logic MOSI,
    output logic SCK,
    
    input logic [15:0] sw,
    output logic [15:0] led
    //output logic en_trans,
    //output logic en_recei

);

//    logic en;
//    logic en_trans,en_recei,ready_1byte;
//    logic ready_5byte;
   logic start,clk_390K,s_clk,en_recei;
   
   get_clk gc(clk,clk_390K);
   
   pulse(
       .clk(clk),
       .en(sw[15]), // en --> en > 3*clk
       .pulse(start)
   );
   
   ///////////////////////// counter
   logic wait_15,wait_10,end_15,end_10;
   time_counter tc (clk,wait_15,wait_10,end_15,end_10);
   assign SCK = s_clk;
   
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
   
   logic [39:0] rdata;
   shift_left_register #(40) slr
   (
       .clk_100M(clk),
       .L(40'b00000000_00000000_00000000_00000000_00000000),
       .reset(1'b0), .load(1'b0), .shift(en_recei), .IN(MISO),
        .Q(rdata) 
   );
   
   showdata sd(rdata,sw[4:0],led[7:0]);
   
endmodule


module showdata(
    input logic [39:0] data,
    input logic [4:0] select,
    output logic [7:0] show
);
    always_comb begin
        case(select)
            5'b00001: show[7:0] = data[7:0];
            5'b00010: show[7:0] = data[15:8];
            5'b00100: show[7:0] = data[23:16];
            5'b01000: show[7:0] = data[31:24];
            5'b10000: show[7:0] = data[39:32];
            default: show[7:0] = 8'b0000_0000;
        endcase
    end
endmodule
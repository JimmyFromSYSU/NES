`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/04/13 09:30:44
// Design Name: 
// Module Name: button_input
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


module button_input(
        input logic MISO,
    output logic SS,
    output logic MOSI,
    output logic SCK,
    
    input bit read,
    input bit write,
    input bit [7:0] din,
    output bit [7:0] dout,
    input bit [15:0] addr,
    input bit [15:0] sw,
    input bit clk,
    input bit clk100M
);
    bit[3:0] count;
    bit access4016;

    assign access4016 = ((addr == 16'h4016));
    
    always_ff @(negedge clk)begin
        if(access4016 && write) count<=0;
        else if(access4016 && read) count <= count + 1;
    end

//    logic en;
//    logic en_trans,en_recei,ready_1byte;
//    logic ready_5byte;
   logic start,clk_390K,s_clk,en_recei;
   
   get_clk gc(clk100M,clk_390K);
   get_fetch_clk gfc(clk100M,fetch_clk);
   bit en_joystick;
   assign en_joystick = fetch_clk;
   pulse(
       .clk(clk100M),
       .en(en_joystick), // en --> en > 3*clk
       .pulse(start)
   );
    
   
   ///////////////////////// counter
   logic wait_15,wait_10,end_15,end_10;
   time_counter tc (clk100M,wait_15,wait_10,end_15,end_10);
   assign SCK = s_clk;
   
   joystick_FSM testfsm(
        .start(start),
        .clk_100M(clk100M),
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
       .clk_100M(clk100M),
       .L(40'b00000000_00000000_00000000_00000000_00000000),
       .reset(1'b0), .load(1'b0), .shift(en_recei), .IN(MISO),
        .Q(rdata) 
   );
   
   //showdata sd(rdata,sw[4:0],led[7:0]);
    //data[7:0]
    always_comb begin
         case(count)
             0:dout = 8'h40 + rdata[2];//sw[1]; //A
             1:dout = 8'h40 + rdata[1];//sw[2]; //B
             2:dout = 8'h40 + sw[14]; //Select
             3:dout = 8'h40 + sw[15]; //Start
//             4:dout = 8'h40 + sw[5]; //Up
//             5:dout = 8'h40 + sw[6]; //Down
//             6:dout = 8'h40 + sw[7]; //Left
//             7:dout = 8'h40 + sw[8]; //Right
                4:dout = 8'h40 + (rdata[8]==1 && rdata[9]==1?1'b1:1'b0); //Up
                5:dout = 8'h40 + (rdata[8]==0 && rdata[9]==0?1'b1:1'b0); //Down
                6:dout = 8'h40 + (rdata[24]==0 && rdata[25]==0?1'b1:1'b0); //Left
                7:dout = 8'h40 + (rdata[24]==1 && rdata[25]==1?1'b1:1'b0); //Right
             default:dout = 8'h40 + sw[9];
         endcase
    end
endmodule
